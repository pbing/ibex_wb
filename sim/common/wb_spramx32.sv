/* Single port 32 bit RAM with Wishbone interface */

`default_nettype none

module wb_spramx32
  #(parameter size = 'h80)
   (wb_if.slave wb);

   localparam addr_width = $clog2(size) - 2;

   logic                    valid;
   logic [addr_width - 1:0] ram_addr;     // RAM address
   logic                    ram_ce;
   logic [3:0]              ram_we;
   logic [31:0]             ram_d;
   logic [31:0]             ram_q;

   spramx32
     #(.size(size))
   spram
     (.clk  (wb.clk),
      .addr (ram_addr),
      .ce   (ram_ce),
      .we   (ram_we),
      .d    (ram_d),
      .q    (ram_q));

   assign ram_addr = wb.adr[addr_width + 1 : 2];
   assign ram_ce   = valid;
   assign ram_we   = {4{wb.we}} & wb.sel;
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
