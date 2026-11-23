class transaction;
  rand bit             wr_en;
  rand bit             rd_en;
  rand bit [WIDTH-1:0] din;
       bit [WIDTH-1:0] dout;
       bit             full, empty;

  // weights out of 10, set by the generator to steer the FIFO towards full or empty
  int wr_wt = 5;
  int rd_wt = 5;

  constraint c_wr { wr_en dist {1 := wr_wt, 0 := 10 - wr_wt}; }
  constraint c_rd { rd_en dist {1 := rd_wt, 0 := 10 - rd_wt}; }

  function void display(string name);
    $display("[%-10s] %4t wr=%0b rd=%0b din=%3d | dout=%3d full=%0b empty=%0b",
             name, $time, wr_en, rd_en, din, dout, full, empty);
  endfunction

  function transaction copy();
    copy = new();
    copy.wr_en = wr_en; copy.rd_en = rd_en; copy.din = din;
    copy.dout  = dout;  copy.full  = full;  copy.empty = empty;
  endfunction
endclass
