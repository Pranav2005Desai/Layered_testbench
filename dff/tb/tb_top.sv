module tb_top;
  logic clk = 0;
  always #5 clk = ~clk;

  dff_intf intf (clk);
  test     t1   (intf);

  dff dut (
    .clk(clk), .rst(intf.rst), .d(intf.d), .q(intf.q)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
