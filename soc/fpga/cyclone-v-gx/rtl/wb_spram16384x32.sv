/* Single port 32 bit RAM with Wishbone interface */

`default_nettype none

module wb_spram16384x32
  (wb_if.slave wb);

   localparam size       = 'h10000;
   localparam addr_width = $clog2(size) - 2;

   logic                    valid;
   logic [addr_width - 1:0] ram_addr;     // RAM address
   logic                    ram_ce;
   logic [31:0]             ram_d;
   logic [31:0]             ram_q;

   spram16384x32 spram
     (.address (ram_addr),
      .byteena (wb.sel),
      .clock   (wb.clk),
      .data    (ram_d),
      .rden    (ram_ce),
      .wren    (wb.we),
      .q       (ram_q));

   assign ram_addr = wb.adr[addr_width + 1 : 2];
   assign ram_ce   = valid;
   assign ram_d    = wb.dat_i;
   assign wb.dat_o = ram_q;

   /* Wishbone control */
   assign valid    = wb.cyc & wb.stb;
   assign wb.stall = 1'b0;
   assign wb.err   = 1'b0;

   always_ff @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       wb.ack <= 1'b0;
     else
       wb.ack <= valid & ~wb.stall;
endmodule

`resetall
