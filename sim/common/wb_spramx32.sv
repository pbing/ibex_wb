/* Single port 32 bit RAM with Wishbone interface */

`default_nettype none

module wb_spramx32
  #(parameter size)
   (wb_if.slave wb);

   localparam addr_width = $clog2(size) - 2;

   logic [addr_width - 1:0] waddr;     // word address
   logic                    valid;
   logic [31:0]             ram_q;

   assign waddr = wb.adr[addr_width + 1 : 2];

   spramx32
     #(.size(size))
   spram
     (.clk  (wb.clk),
      .addr (waddr),
      .ce   (valid),
      .we   (wb.we),
      .d    (wb.dat_i),
      .q    (ram_q));

   /* Wishbone control */
   assign valid    = wb.cyc & wb.stb;
   assign wb.stall = 1'b0;
   assign wb.err   = 1'b0;

   always_ff @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       wb.ack <= 1'b0;
     else
       wb.ack <= valid & ~wb.stall;

   assign wb.dat_o = ram_q;
endmodule

`resetall
