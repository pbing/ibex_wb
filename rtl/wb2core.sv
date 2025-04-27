/* Wishbone to core memory interface converter */

module wb2core
  (
`ifndef FORMAL
   core_if.master core,
   wb_if.slave    wb
`else
   core_if        core,
   wb_if          wb
`endif
   );

   assign
     core.req  = wb.cyc & wb.stb,
     core.we   = wb.we,
     core.addr = wb.adr,
     core.be   = wb.sel,
     wb.stall  = ~core.gnt,
     wb.ack    = wb.cyc & core.rvalid & ~core.err,
     wb.err    = wb.cyc & core.rvalid & core.err;

`ifdef NO_MODPORT_EXPRESSIONS
   assign
     core.wdata = wb.dat_m,
     wb.dat_s   = core.rdata;
`else
   assign
     core.wdata = wb.dat_i,
     wb.dat_o   = core.rdata;
`endif
endmodule
