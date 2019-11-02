/* Converter between DM slave interface and Wishbone interface */

`default_nettype none

module slave2wb
  (core_if.master slave,
   wb_if.slave    wb);

   assign slave.req   = wbs.stb;
   assign slave.we    = wbs.we;
   assign slave.addr  = wbs.adr;
   assign slave.be    = wbs.sel;
   assign slave.wdata = wbs.dat_i;
   assign wbs.dat_o   = slave.rdata;
   assign wbs.stall   = 1'b0;
   assign wbs.err     = 1'b0;

   always_ff @(posedge wbs.clk or posedge wbs.rst)
     if (wbs.rst)
       wbs.ack <= 1'b0;
     else
       wbs.ack <= wbs.cyc & wbs.stb;
endmodule

`resetall
