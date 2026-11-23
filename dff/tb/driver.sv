class driver;
  virtual dff_intf       vif;
  mailbox #(transaction) gen2drv;
  int                    no_trans;

  function new(virtual dff_intf vif, mailbox #(transaction) gen2drv);
    this.vif     = vif;
    this.gen2drv = gen2drv;
  endfunction

  // apply reset for two clocks before the test starts
  task reset();
    vif.rst <= 1;
    vif.d   <= 0;
    repeat (2) @(posedge vif.clk);
    @(negedge vif.clk);
    vif.rst <= 0;
  endtask

  task run();
    transaction trans;
    forever begin
      gen2drv.get(trans);
      @(negedge vif.clk);
      vif.rst <= trans.rst;
      vif.d   <= trans.d;
      no_trans++;
    end
  endtask
endclass
