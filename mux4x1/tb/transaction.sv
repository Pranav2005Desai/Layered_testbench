class transaction;
  rand bit [7:0] a, b, c, d;
  rand bit [1:0] sel;
       bit [7:0] y;

  // keep the four inputs different so a wrong select is always caught
  constraint c_unique { a != b; a != c; a != d; b != c; b != d; c != d; }

  function void display(string name);
    $display("[%-10s] sel=%0d a=%3d b=%3d c=%3d d=%3d | y=%3d",
             name, sel, a, b, c, d, y);
  endfunction

  function transaction copy();
    copy = new();
    copy.a = a; copy.b = b; copy.c = c; copy.d = d;
    copy.sel = sel; copy.y = y;
  endfunction
endclass
