class scoreboard;
  mailbox #(transaction) mon2scb;
  bit [WIDTH-1:0]        model_q[$];   // reference model
  int pass, fail;
  int n_writes, n_reads, n_full, n_empty, n_wr_on_full, n_rd_on_empty;

  function new(mailbox #(transaction) mon2scb);
    this.mon2scb = mon2scb;
  endfunction

  function void check(bit ok, transaction t, string msg);
    if (ok) pass++;
    else begin
      fail++;
      t.display("FAIL");
      $error("%s", msg);
    end
  endfunction

  task run();
    transaction     trans;
    bit             exp_full, exp_empty;
    bit [WIDTH-1:0] exp_dout;
    forever begin
      mon2scb.get(trans);

      // 1. flags must match the model's state before this edge
      exp_full  = (model_q.size() == DEPTH);
      exp_empty = (model_q.size() == 0);
      check(trans.full  == exp_full,  trans,
            $sformatf("full: expected %0b, got %0b",  exp_full,  trans.full));
      check(trans.empty == exp_empty, trans,
            $sformatf("empty: expected %0b, got %0b", exp_empty, trans.empty));

      // 2. read: pop from the model and compare dout
      if (trans.rd_en && !exp_empty) begin
        exp_dout = model_q.pop_front();
        n_reads++;
        check(trans.dout == exp_dout, trans,
              $sformatf("dout: expected %0d, got %0d", exp_dout, trans.dout));
      end

      // 3. write: push into the model
      if (trans.wr_en && !exp_full) begin
        model_q.push_back(trans.din);
        n_writes++;
      end

      // scenario counters
      if (exp_full)                   n_full++;
      if (exp_empty)                  n_empty++;
      if (trans.wr_en && exp_full)    n_wr_on_full++;
      if (trans.rd_en && exp_empty)   n_rd_on_empty++;

      trans.display("SCB");
    end
  endtask

  function void report();
    $display("--------------------------------------------");
    $display(" FIFO : %0d checks passed, %0d failed", pass, fail);
    $display("  writes=%0d reads=%0d", n_writes, n_reads);
    $display("  cycles full=%0d, empty=%0d", n_full, n_empty);
    $display("  write attempts when full=%0d, read attempts when empty=%0d",
             n_wr_on_full, n_rd_on_empty);
    $display(" %s", (fail == 0) ? "TEST PASSED" : "TEST FAILED");
    $display("--------------------------------------------");
  endfunction
endclass
