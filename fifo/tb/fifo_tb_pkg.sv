// All testbench classes, compiled together as one package
package fifo_tb_pkg;
  import fifo_params_pkg::*;
  `include "transaction.sv"
  `include "generator.sv"
  `include "driver.sv"
  `include "monitor.sv"
  `include "scoreboard.sv"
  `include "environment.sv"
endpackage
