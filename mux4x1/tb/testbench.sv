// Layered testbench for the 4x1 mux
// transaction -> generator -> (mailbox) -> driver -> intf -> DUT -> monitor -> (mailbox) -> scoreboard
// The mux is combinational; the clock only paces the testbench
// (driver drives on negedge, monitor samples on posedge).
//
// Compile order wrapper: this is the only testbench file a simulator needs to be given.

`include "mux_intf.sv"
`include "mux_tb_pkg.sv"
`include "test.sv"
`include "tb_top.sv"
