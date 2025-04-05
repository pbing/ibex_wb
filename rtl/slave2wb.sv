/* Converter between DM slave interface and Wishbone interface */

module slave2wb
  (core_if.master slave,
   wb_if.slave    wb);

   logic valid;

   assign
     valid       = wb.cyc & wb.stb,
     slave.req   = valid,
     slave.we    = wb.we,
     slave.addr  = wb.adr,
     slave.be    = wb.sel,
     wb.stall    = ~slave.gnt,
     wb.err      = slave.err;

`ifdef NO_MODPORT_EXPRESSIONS
   assign
     slave.wdata = wb.dat_m,
     wb.dat_s    = slave.rdata;
`else
   assign
     slave.wdata = wb.dat_i,
     wb.dat_o    = slave.rdata;
`endif

   always_ff @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       wb.ack <= 1'b0;
     else
       wb.ack <= valid & ~wb.stall;
endmodule
