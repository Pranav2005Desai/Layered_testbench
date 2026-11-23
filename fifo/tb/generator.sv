// Three phases: fill (mostly writes), drain (mostly reads), mixed.
class generator;
  transaction            trans;
  mailbox #(transaction) gen2drv;
  int                    repeat_count;   // transactions per phase
  event                  done;

  function new(mailbox #(transaction) gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task gen_phase(int wr_wt, int rd_wt);
    repeat (repeat_count) begin
      trans       = new();
      trans.wr_wt = wr_wt;
      trans.rd_wt = rd_wt;
      if (!trans.randomize()) $fatal(1, "Generator: randomization failed");
      gen2drv.put(trans.copy());
    end
  endtask

  task run();
    gen_phase(9, 1);   // fill   -> hits full
    gen_phase(1, 9);   // drain  -> hits empty
    gen_phase(5, 5);   // mixed  -> simultaneous read/write
    -> done;
  endtask

  function int total();
    return 3 * repeat_count;
  endfunction
endclass
