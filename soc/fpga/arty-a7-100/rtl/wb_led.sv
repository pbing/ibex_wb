/* LED driver (only word access) */

module wb_led
  #(parameter N = 4)
   (output logic [N-1:0] led,
    wb_if.slave          wb);

   logic valid;
   logic select;

   always_ff @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       led <= '0;
     else
       if (valid && wb.we && select)
       `ifdef NO_MODPORT_EXPRESSIONS
         led <= wb.dat_m[N-1:0];
       `else
         led <= wb.dat_i[N-1:0];
       `endif

   /* Wishbone control */
   assign
     valid    = wb.cyc & wb.stb,
     select   = wb.adr[11:2] == 0,
     wb.stall = 1'b0,
     wb.err   = 1'b0;

   always_ff @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       wb.ack <= 1'b0;
     else
       wb.ack <= valid & ~wb.stall;
   
`ifdef NO_MODPORT_EXPRESSIONS
   assign wb.dat_s = {{(32 - N){1'b0}}, led};
`else
   assign wb.dat_o = {{(32 - N){1'b0}}, led};
`endif
endmodule
