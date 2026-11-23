class generator;
  transaction            trans;
  mailbox #(transaction) gen2drv;
  int                    repeat_count;
  event                  done;

  function new(mailbox #(transaction) gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task run();
    repeat (repeat_count) begin
      trans = new();
      if (!trans.randomize()) $fatal(1, "Generator: randomization failed");
      gen2drv.put(trans.copy());
    end
    -> done;
  endtask
endclass
