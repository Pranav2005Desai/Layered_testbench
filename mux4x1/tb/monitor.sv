class monitor;
  virtual mux_intf       vif;
  mailbox #(transaction) mon2scb;

  function new(virtual mux_intf vif, mailbox #(transaction) mon2scb);
    this.vif     = vif;
    this.mon2scb = mon2scb;
  endfunction

  task run();
    transaction trans;
    forever begin
      @(posedge vif.clk);
      trans     = new();
      trans.a   = vif.a;
      trans.b   = vif.b;
      trans.c   = vif.c;
      trans.d   = vif.d;
      trans.sel = vif.sel;
      trans.y   = vif.y;
      mon2scb.put(trans);
    end
  endtask
endclass
