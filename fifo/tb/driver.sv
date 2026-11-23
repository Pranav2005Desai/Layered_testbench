class driver;
  virtual fifo_intf      vif;
  mailbox #(transaction) gen2drv;
  int                    no_trans;

  function new(virtual fifo_intf vif, mailbox #(transaction) gen2drv);
    this.vif     = vif;
    this.gen2drv = gen2drv;
  endfunction

  task reset();
    vif.rst   <= 1;
    vif.wr_en <= 0;
    vif.rd_en <= 0;
    vif.din   <= 0;
    repeat (2) @(posedge vif.clk);
    @(negedge vif.clk);
    vif.rst   <= 0;
  endtask

  task run();
    transaction trans;
    forever begin
      gen2drv.get(trans);
      @(negedge vif.clk);
      vif.wr_en <= trans.wr_en;
      vif.rd_en <= trans.rd_en;
      vif.din   <= trans.din;
      no_trans++;
    end
  endtask
endclass
