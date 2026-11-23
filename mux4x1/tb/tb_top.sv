module tb_top;
  logic clk = 0;
  always #5 clk = ~clk;

  mux_intf intf (clk);
  test     t1   (intf);

  mux4x1 dut (
    .a(intf.a), .b(intf.b), .c(intf.c), .d(intf.d),
    .sel(intf.sel), .y(intf.y)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
