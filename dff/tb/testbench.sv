// Layered testbench for the D flip-flop
// transaction -> generator -> (mailbox) -> driver -> intf -> DUT -> monitor -> (mailbox) -> scoreboard
// Driver changes inputs on negedge; monitor samples inputs at posedge and q just after it.
//
// Compile order wrapper: this is the only testbench file a simulator needs to be given.

`include "dff_intf.sv"
`include "dff_tb_pkg.sv"
`include "test.sv"
`include "tb_top.sv"
