program test (mux_intf intf);
  import mux_tb_pkg::*;

  environment env;
  initial begin
    env = new(intf);
    env.gen.repeat_count = 20;
    env.run();
  end
endprogram
