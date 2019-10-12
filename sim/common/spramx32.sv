/* Single port 32 bit RAM */

`default_nettype none

module spramx32
  #(parameter size,
    parameter addr_width = $clog2(size) - 2)
   (input  logic                    clk,  // clock
    input  logic [addr_width - 1:0] addr, // address
    input  logic                    ce,   // chip enable
    input  logic                    we,   // write enable
    input  logic [31:0]             d,    // data input
    output logic [31:0]             q);   // data output

   logic [31:0] mem[size];

   always @(posedge clk)
     if (ce && we)
       mem[addr] <= d;

   always_ff @(posedge clk)
     if (ce)
       q <= mem[addr];
endmodule

`resetall
