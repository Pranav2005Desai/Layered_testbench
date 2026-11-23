program test (dff_intf intf);
  import dff_tb_pkg::*;

  environment env;
  initial begin
    env = new(intf);
    env.gen.repeat_count = 30;
    env.run();
  end
endprogram
