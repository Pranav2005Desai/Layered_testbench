// Layered testbench for the synchronous FIFO
// transaction -> generator -> (mailbox) -> driver -> intf -> DUT -> monitor -> (mailbox) -> scoreboard
// Driver changes inputs on negedge; monitor samples inputs and flags at posedge, dout just after it.
// The scoreboard's reference model is an SV queue.
//
// Compile order wrapper: this is the only testbench file a simulator needs to be given.

`include "fifo_params_pkg.sv"
`include "fifo_intf.sv"
`include "fifo_tb_pkg.sv"
`include "test.sv"
`include "tb_top.sv"
