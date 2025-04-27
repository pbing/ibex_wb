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

   logic resp;

   assign
     core.req  = wb.cyc & wb.stb,
     core.we   = wb.we,
     core.addr = wb.adr,
     core.be   = wb.sel,
     wb.stall  = ~core.gnt,
     wb.ack    = resp & wb.cyc & core.rvalid & ~core.err,
     wb.err    = resp & wb.cyc & core.rvalid & core.err;

`ifdef NO_MODPORT_EXPRESSIONS
   assign
     core.wdata = wb.dat_m,
     wb.dat_s   = core.rdata;
`else
   assign
     core.wdata = wb.dat_i,
     wb.dat_o   = core.rdata;
`endif

   always_ff @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       resp <= 1'b0;
     else
       resp <= wb.cyc & wb.stb & ~wb.stall;
endmodule
