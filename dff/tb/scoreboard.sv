class scoreboard;
  mailbox #(transaction) mon2scb;
  int pass, fail;

  function new(mailbox #(transaction) mon2scb);
    this.mon2scb = mon2scb;
  endfunction

  // reference model: next q after a clock edge
  function bit ref_dff(transaction t);
    return t.rst ? 1'b0 : t.d;
  endfunction

  task run();
    transaction trans;
    bit         expected;
    forever begin
      mon2scb.get(trans);
      expected = ref_dff(trans);
      if (trans.q === expected) begin
        pass++;
        trans.display("PASS");
      end
      else begin
        fail++;
        trans.display("FAIL");
        $error("Expected q=%0b, got q=%0b", expected, trans.q);
      end
    end
  endtask

  function void report();
    $display("--------------------------------------------");
    $display(" DFF : %0d passed, %0d failed", pass, fail);
    $display(" %s", (fail == 0) ? "TEST PASSED" : "TEST FAILED");
    $display("--------------------------------------------");
  endfunction
endclass
