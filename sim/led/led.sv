/* LED driver (only word access) */

`default_nettype none

module led
  (output logic led,
   wb_if.slave  wb);

   logic valid;

   always @(posedge wb.clk)
     if (valid && wb.we)
       led <= wb.dat_i[0];

   /* Wishbone control */
   assign valid    = wb.cyc & wb.stb;
   assign wb.stall = 1'b0;
   assign wb.err   = 1'b0;

   always_ff @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       wb.ack <= 1'b0;
     else
       wb.ack <= valid & ~wb.stall;

   assign wb.dat_o = {31'h00000000,led};
endmodule

`resetall
