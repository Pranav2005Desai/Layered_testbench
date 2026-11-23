class scoreboard;
  mailbox #(transaction) mon2scb;
  int pass, fail;

  function new(mailbox #(transaction) mon2scb);
    this.mon2scb = mon2scb;
  endfunction

  // reference model
  function bit [7:0] ref_mux(transaction t);
    case (t.sel)
      2'd0: return t.a;
      2'd1: return t.b;
      2'd2: return t.c;
      2'd3: return t.d;
    endcase
  endfunction

  task run();
    transaction trans;
    bit [7:0]   expected;
    forever begin
      mon2scb.get(trans);
      expected = ref_mux(trans);
      if (trans.y === expected) begin
        pass++;
        trans.display("PASS");
      end
      else begin
        fail++;
        trans.display("FAIL");
        $error("Expected y=%0d, got y=%0d", expected, trans.y);
      end
    end
  endtask

  function void report();
    $display("--------------------------------------------");
    $display(" MUX 4x1 : %0d passed, %0d failed", pass, fail);
    $display(" %s", (fail == 0) ? "TEST PASSED" : "TEST FAILED");
    $display("--------------------------------------------");
  endfunction
endclass
