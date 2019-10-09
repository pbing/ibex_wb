/* Converter between Ibex core interface and Wishbone interface */

`default_nettype none

module core2wb
  (core_if.slave core,
   wb_if.master  wb);

   assign core.gnt    = core.req & ~wb.stall;
   assign core.rvalid = wb.ack;
   assign core.err    = wb.err;
   assign core.rdata  = wb.dat_i;
   assign wb.stb      = core.req;
   assign wb.adr      = core.addr;
   assign wb.dat_o    = core.wdata;
   assign wb.we       = core.we;
   assign wb.sel      = core.be;

   always_ff @(posedge wb.clk or posedge wb.rst or posedge core.req)
     if (wb.rst)
       wb.cyc <= 1'b0;
     else if (core.req)
       wb.cyc <= 1'b1;
     else if (wb.ack)
       wb.cyc <= 1'b0;   
endmodule

`resetall
