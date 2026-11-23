# SystemVerilog Layered Testbenches

Class-based, layered SystemVerilog testbenches (no UVM) for three small designs:

| Design | Description | Reference model |
|---|---|---|
| [`mux4x1`](mux4x1) | 4-to-1 multiplexer, 8-bit data | `case` on `sel` |
| [`dff`](dff) | D flip-flop, async active-high reset | `q = rst ? 0 : d` |
| [`fifo`](fifo) | Synchronous FIFO, 8 deep × 8 bits, registered `dout` | SV queue (`push_back` / `pop_front`) |

## Architecture

```
            ┌───────────┐  mailbox  ┌────────┐       ┌─────────────┐       ┌─────────┐  mailbox  ┌────────────┐
 test ───▶  │ generator │ ────────▶ │ driver │ ────▶ │ interface + │ ────▶ │ monitor │ ────────▶ │ scoreboard │
            └───────────┘           └────────┘ (vif) │     DUT     │ (vif) └─────────┘           │ + ref model│
                                                     └─────────────┘                             └────────────┘
                   └──────────────────────────── environment ───────────────────────────────────────┘
```

| Component | Role |
|---|---|
| `transaction` | DUT inputs (`rand`) and outputs, constraints, `display()` / `copy()` |
| `generator` | Randomizes transactions and puts them into the generator → driver mailbox |
| `driver` | Applies reset, then drives each transaction onto the virtual interface on the falling edge |
| `monitor` | Samples inputs at the rising edge (outputs just after it for sequential DUTs) |
| `scoreboard` | Compares DUT output against the reference model; prints a pass/fail summary |
| `environment` | Builds the components and mailboxes, runs them in parallel with `fork…join_none`, ends the test |
| `test` | `program` block that creates the environment and sets the number of transactions |
| `tb_top` | Clock, interface, test and DUT instance |

### Stimulus highlights
- **mux4x1**: the four data inputs are constrained to be different, so a wrong `sel` can't give the right answer by chance.
- **dff**: reset is weighted (`dist`) to about 10% so `q` mostly follows `d`.
- **fifo**: the generator runs three phases by changing `dist` weights (fill → drain → mixed), so the run hits full, empty, writes when full, reads when empty, and simultaneous read and write. The scoreboard checks `full`, `empty` and `dout` every cycle and reports how often each scenario occurred.

## Repository layout

```
<design>/
├── files.f              # file list for the simulator
├── rtl/<design>.sv      # DUT
└── tb/
    ├── testbench.sv     # wrapper: `includes everything below in compile order
    ├── <x>_intf.sv      # interface
    ├── <x>_tb_pkg.sv    # package that `includes all classes
    ├── transaction.sv
    ├── generator.sv
    ├── driver.sv
    ├── monitor.sv
    ├── scoreboard.sv
    ├── environment.sv
    ├── test.sv          # program block
    └── tb_top.sv        # top module
```

## Running

**Synopsys VCS**
```bash
cd fifo
vcs -sverilog -full64 -f files.f -o simv && ./simv
```

**Siemens Questa**
```bash
cd fifo
qverilog -f files.f
```

**EDA Playground** ([edaplayground.com](https://www.edaplayground.com))
1. Paste `rtl/<design>.sv` into the *design.sv* pane.
2. Paste `tb/testbench.sv` into the *testbench.sv* pane.
3. Add every other file from `tb/` with the **+** button (keep the same file names).
4. Choose **Synopsys VCS** or **Aldec Riviera-PRO**, set the top to `tb_top`, and run. Tick *Open EPWave after run* for waveforms.

Icarus Verilog does not support classes, mailboxes or `randomize()`, so it can't run these testbenches.

### Sample output (fifo)
```
--------------------------------------------
 FIFO : 171 checks passed, 0 failed
  writes=24 reads=19
  cycles full=17, empty=18
  write attempts when full=15, read attempts when empty=13
 TEST PASSED
--------------------------------------------
```
