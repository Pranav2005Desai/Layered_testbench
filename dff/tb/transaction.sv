class transaction;
  rand bit rst;
  rand bit d;
       bit q;

  // reset only occasionally so q actually follows d most of the time
  constraint c_rst { rst dist {1 := 1, 0 := 9}; }

  function void display(string name);
    $display("[%-10s] %4t rst=%0b d=%0b | q=%0b", name, $time, rst, d, q);
  endfunction

  function transaction copy();
    copy = new();
    copy.rst = rst; copy.d = d; copy.q = q;
  endfunction
endclass
