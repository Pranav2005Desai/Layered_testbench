class driver;
  virtual mux_intf       vif;
  mailbox #(transaction) gen2drv;
  int                    no_trans;

  function new(virtual mux_intf vif, mailbox #(transaction) gen2drv);
    this.vif     = vif;
    this.gen2drv = gen2drv;
  endfunction

  task reset();
    vif.a <= 0; vif.b <= 0; vif.c <= 0; vif.d <= 0; vif.sel <= 0;
    repeat (2) @(posedge vif.clk);
  endtask

  task run();
    transaction trans;
    forever begin
      gen2drv.get(trans);
      @(negedge vif.clk);
      vif.a   <= trans.a;
      vif.b   <= trans.b;
      vif.c   <= trans.c;
      vif.d   <= trans.d;
      vif.sel <= trans.sel;
      no_trans++;
    end
  endtask
endclass
