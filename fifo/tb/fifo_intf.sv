interface fifo_intf (input logic clk);
  import fifo_params_pkg::*;
  logic             rst;
  logic             wr_en, rd_en;
  logic [WIDTH-1:0] din, dout;
  logic             full, empty;
endinterface
