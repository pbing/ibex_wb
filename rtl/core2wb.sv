/* Converter between Ibex core interface and Wishbone interface */

module core2wb
  #(parameter pending = 16) // number of outstandig transactions
   (core_if.slave core,
    wb_if.master  wb);

   logic [$clog2(pending)-1:0] counts;

   assign
     core.gnt    = core.req & ~wb.stall,
     core.rvalid = wb.ack,
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

   always_ff @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       counts <= 0;
     else
       if (core.gnt && !wb.ack)
         counts <= counts + 1;
       else if (!core.gnt && wb.ack)
         counts <= counts - 1;

   assign wb.cyc = core.req || (counts != 0);
endmodule
