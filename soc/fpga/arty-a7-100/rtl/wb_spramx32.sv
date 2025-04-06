/* Single port 32 bit RAM with Wishbone interface */

module wb_spramx32
  #(parameter size = 'h80)
   (wb_if.slave wb);

   localparam addr_width = $clog2(size) - 2;

   logic                    valid;
   logic [addr_width - 1:0] ram_addr;     // RAM address
   logic                    ram_ce;
   logic [3:0]              ram_we;
   logic [31:0]             ram_data;
   logic [31:0]             ram_q;

   spramx32
     #(.size(size))
   spram
     (.clk  (wb.clk),
      .addr (ram_addr),
      .ce   (ram_ce),
      .we   (ram_we),
      .d    (ram_data),
      .q    (ram_q));

   assign
     ram_addr = wb.adr[addr_width+1:2],
     ram_ce   = valid,
     ram_we   = {4{wb.we}} & wb.sel,
`ifdef NO_MODPORT_EXPRESSIONS
     ram_data = wb.dat_m,
     wb.dat_s = ram_q;
`else
     ram_data = wb.dat_i,
     wb.dat_o = ram_q;
`endif

   /* Wishbone control */
   assign
     valid    = wb.cyc & wb.stb,
     wb.stall = 1'b0,
     wb.err   = 1'b0;

   always_ff @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       wb.ack <= 1'b0;
     else
       wb.ack <= valid & ~wb.stall;
endmodule
