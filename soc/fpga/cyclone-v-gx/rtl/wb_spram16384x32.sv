/* Single port 32 bit RAM with Wishbone interface */

module wb_spram16384x32
  (wb_if.slave wb);

   localparam AWIDTH = $clog2(16384);

   logic                valid;
   logic [AWIDTH - 1:0] ram_addr;     // RAM address
   logic                ram_rden;
   logic                ram_wren;
   logic [31:0]         ram_data;
   logic [31:0]         ram_q;

   spram16384x32 spram
     (.address (ram_addr),
      .byteena (wb.sel),
      .clock   (wb.clk),
      .data    (ram_data),
      .rden    (ram_rden),
      .wren    (ram_wren),
      .q       (ram_q));

   assign
     ram_addr = wb.adr[AWIDTH+1 : 2],
     ram_rden   = valid & ~wb.we,
     ram_wren   = valid & wb.we,
   `ifdef NO_MODPORT_EXPRESSIONS
     ram_data   = wb.dat_m,
     wb.dat_s   = ram_q;
   `else
     ram_data   = wb.dat_i,
     wb.dat_o   = ram_q;
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
