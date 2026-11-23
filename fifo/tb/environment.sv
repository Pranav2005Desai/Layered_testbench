class environment;
  generator  gen;
  driver     drv;
  monitor    mon;
  scoreboard scb;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) mon2scb;
  virtual fifo_intf      vif;

  function new(virtual fifo_intf vif);
    this.vif = vif;
    gen2drv  = new();
    mon2scb  = new();
    gen      = new(gen2drv);
    drv      = new(vif, gen2drv);
    mon      = new(vif, mon2scb);
    scb      = new(mon2scb);
  endfunction

  task run();
    drv.reset();
    fork
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_none
    wait (drv.no_trans == gen.total());  // all stimulus driven
    repeat (2) @(posedge vif.clk);       // let the last samples reach the scoreboard
    scb.report();
    $finish;
  endtask
endclass
