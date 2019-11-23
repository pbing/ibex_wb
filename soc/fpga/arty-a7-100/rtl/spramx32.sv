/* Single port 32 bit RAM */

`default_nettype none

module spramx32
  #(parameter size       = 'h80,
    parameter addr_width = $clog2(size) - 2)
   (input  wire                     clk,  // clock
    input  wire  [addr_width - 1:0] addr, // address
    input  wire                     ce,   // chip enable
    input  wire  [3:0]              we,   // write enables
    input  wire  [31:0]             d,    // data input
    output logic [31:0]             q);   // data output

   logic [7:0] mem0[size], mem1[size], mem2[size], mem3[size];

   always @(posedge clk)
     if (ce)
       begin
          if (we[0]) mem0[addr] <= d[7:0];
          if (we[1]) mem1[addr] <= d[15:8];
          if (we[2]) mem2[addr] <= d[23:16];
          if (we[3]) mem3[addr] <= d[31:24];
       end

   always_ff @(posedge clk)
     if (ce)
       q <= {mem3[addr],mem2[addr],mem1[addr],mem0[addr]};
endmodule

`resetall
