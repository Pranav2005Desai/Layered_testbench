program test (fifo_intf intf);
  import fifo_tb_pkg::*;

  environment env;
  initial begin
    env = new(intf);
    env.gen.repeat_count = 25;   // per phase -> 75 transactions
    env.run();
  end
endprogram
