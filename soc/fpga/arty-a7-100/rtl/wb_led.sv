/* LED driver (only word access) */

`default_nettype none

module wb_led
  (output logic [3:0] led,
   wb_if.slave        wb);

   logic valid;
   logic select;

   always @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       led <= '0;
     else
       if (valid && wb.we && select)
         led <= wb.dat_i[3:0];

   /* Wishbone control */
   assign valid    = wb.cyc & wb.stb;
   assign select   = wb.adr[11:2] == 0;
   assign wb.stall = 1'b0;
   assign wb.err   = 1'b0;

   always_ff @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       wb.ack <= 1'b0;
     else
       wb.ack <= valid & ~wb.stall;

   assign wb.dat_o = {28'h00000000,led};
endmodule

`resetall
