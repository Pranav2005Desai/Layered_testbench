class monitor;
  virtual fifo_intf      vif;
  mailbox #(transaction) mon2scb;

  function new(virtual fifo_intf vif, mailbox #(transaction) mon2scb);
    this.vif     = vif;
    this.mon2scb = mon2scb;
  endfunction

  task run();
    transaction trans;
    forever begin
      @(posedge vif.clk);
      trans       = new();
      trans.wr_en = vif.wr_en;   // inputs and flags seen at the clock edge
      trans.rd_en = vif.rd_en;
      trans.din   = vif.din;
      trans.full  = vif.full;
      trans.empty = vif.empty;
      #1;
      trans.dout  = vif.dout;    // read data after the edge
      mon2scb.put(trans);
    end
  endtask
endclass
