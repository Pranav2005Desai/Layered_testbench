// Synchronous FIFO
// - write when wr_en && !full, read when rd_en && !empty (both allowed in the same cycle)
// - dout is registered: data appears on the clock edge after rd_en
// - DEPTH must be a power of 2 (pointers wrap naturally)
module fifo #(
  parameter int WIDTH = 8,
  parameter int DEPTH = 8
) (
  input  logic             clk,
  input  logic             rst,      // asynchronous, active high
  input  logic             wr_en,
  input  logic             rd_en,
  input  logic [WIDTH-1:0] din,
  output logic [WIDTH-1:0] dout,
  output logic             full,
  output logic             empty
);
  localparam int AW = $clog2(DEPTH);

  logic [WIDTH-1:0] mem [DEPTH];
  logic [AW-1:0]    wr_ptr, rd_ptr;
  logic [AW:0]      count;

  wire do_write = wr_en && !full;
  wire do_read  = rd_en && !empty;

  assign full  = (count == DEPTH);
  assign empty = (count == 0);

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      wr_ptr <= '0;
      rd_ptr <= '0;
      count  <= '0;
      dout   <= '0;
    end
    else begin
      if (do_write) begin
        mem[wr_ptr] <= din;
        wr_ptr      <= wr_ptr + 1'b1;
      end
      if (do_read) begin
        dout   <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1'b1;
      end
      case ({do_write, do_read})
        2'b10:   count <= count + 1'b1;
        2'b01:   count <= count - 1'b1;
        default: count <= count;          // no op, or read + write together
      endcase
    end
  end
endmodule
