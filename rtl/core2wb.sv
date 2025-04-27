/* Core to Wishbone memory interface converter */

module core2wb
  #(parameter pending = 16) // number of outstandig transactions
   (
`ifndef FORMAL
    core_if.slave core,
    wb_if.master  wb
`else
    core_if       core,
    wb_if         wb
`endif
    );

   logic signed [$clog2(pending):0] counts;

   assign
     core.gnt    = core.req & ~wb.stall,
     core.rvalid = wb.cyc & (wb.ack | wb.err),
     core.err    = wb.err,
     wb.stb      = core.req,
     wb.adr      = core.addr,
     wb.we       = core.we,
     wb.sel      = core.we ? core.be : '1;

`ifdef NO_MODPORT_EXPRESSIONS
   assign
     core.rdata = wb.dat_s,
     wb.dat_m   = core.wdata;
`else
   assign
     core.rdata  = wb.dat_i,
     wb.dat_o    = core.wdata;
`endif

   always_ff @(posedge core.clk or negedge core.rst_n)
     if (!core.rst_n)
       counts <= 0;
     else
       if (core.req && core.gnt)
         counts <= (wb.cyc && wb.ack) ? counts : counts + 1;
       else if (wb.cyc && wb.ack)
         counts <= counts - 1;

   assign wb.cyc = core.req || (counts > 0);
endmodule
