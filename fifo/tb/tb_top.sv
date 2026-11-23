module tb_top;
  import fifo_params_pkg::*;

  logic clk = 0;
  always #5 clk = ~clk;

  fifo_intf intf (clk);
  test      t1   (intf);

  fifo #(.WIDTH(WIDTH), .DEPTH(DEPTH)) dut (
    .clk  (clk),
    .rst  (intf.rst),
    .wr_en(intf.wr_en),
    .rd_en(intf.rd_en),
    .din  (intf.din),
    .dout (intf.dout),
    .full (intf.full),
    .empty(intf.empty)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
