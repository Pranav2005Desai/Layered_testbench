class monitor;
  virtual dff_intf       vif;
  mailbox #(transaction) mon2scb;

  function new(virtual dff_intf vif, mailbox #(transaction) mon2scb);
    this.vif     = vif;
    this.mon2scb = mon2scb;
  endfunction

  task run();
    transaction trans;
    forever begin
      @(posedge vif.clk);
      trans     = new();
      trans.rst = vif.rst;   // inputs seen at the clock edge
      trans.d   = vif.d;
      #1;
      trans.q   = vif.q;     // output after the edge
      mon2scb.put(trans);
    end
  endtask
endclass
