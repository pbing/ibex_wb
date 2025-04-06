/* Single port 32 bit RAM */

module spramx32
  #(parameter  size       = 'h80,
    localparam addr_width = $clog2(size) - 2)
   (input  logic                  clk,  // clock
    input  logic [addr_width-1:0] addr, // address
    input  logic                  ce,   // chip enable
    input  logic [3:0]            we,   // write enables
    input  logic [31:0]           d,    // data input
    output logic [31:0]           q);   // data output

   (* ram_style = "block" *) logic [31:0] mem[size >> 2];

   initial
     $readmemh("spramx32.vmem", mem);

   always @(posedge clk)
     if (ce)
       begin
          if (we[0]) mem[addr][7:0]   <= d[7:0];
          if (we[1]) mem[addr][15:8]  <= d[15:8];
          if (we[2]) mem[addr][23:16] <= d[23:16];
          if (we[3]) mem[addr][31:24] <= d[31:24];
       end

   always_ff @(posedge clk)
     if (ce)
       q <= mem[addr];
endmodule
