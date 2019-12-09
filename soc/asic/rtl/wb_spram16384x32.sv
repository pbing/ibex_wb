/* 16384 x 32 bit single port SRAM with Wishbone interface */

`default_nettype none

module wb_spram16384x32
  (wb_if.slave wb);

   localparam addr_width = 14;

   logic                    valid;
   logic [addr_width - 1:0] ram_addr; // RAM address
   logic                    ram_ce;   // RAM chip enable (low active)
   logic                    ram_we;   // RAM write enable (low active)
   logic [31:0]             ram_dm;   // RAM write data mask (low active)
   logic [31:0]             ram_d;    // RAM write data
   logic [31:0]             ram_q;    // RAM read data

   RAM16384X32 spram
     (.A   (ram_q),
      .I   (ram_d),
      .IA  (ram_addr),
      .DM  (ram_dm),
      .CK  (wb.clk),
      .CE  (ram_ce),
      .WE  (ram_we),
      .FO  ('0),
      .SLP (1'b1));

   assign ram_addr      = wb.adr[addr_width + 1 : 2];
   assign ram_ce        = ~valid;
   assign ram_we        = ~(valid & wb.we);
   assign ram_dm[7:0]   = {8{~wb.sel[0]}};
   assign ram_dm[15:8]  = {8{~wb.sel[1]}};
   assign ram_dm[23:16] = {8{~wb.sel[2]}};
   assign ram_dm[31:24] = {8{~wb.sel[3]}};
   assign ram_d         = wb.dat_i;
   assign wb.dat_o      = ram_q;

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
