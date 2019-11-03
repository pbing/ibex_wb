/* Converter between DM slave interface and Wishbone interface */

`default_nettype none

module slave2wb
  (core_if.master slave,
   wb_if.slave    wb);

   assign slave.req   = wb.stb;
   assign slave.we    = wb.we;
   assign slave.addr  = wb.adr;
   assign slave.be    = wb.sel;
   assign slave.wdata = wb.dat_i;
   assign wb.dat_o   = slave.rdata;
   assign wb.stall   = 1'b0;
   assign wb.err     = 1'b0;

   always_ff @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       wb.ack <= 1'b0;
     else
       wb.ack <= wb.cyc & wb.stb;
endmodule

`resetall
