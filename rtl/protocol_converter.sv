/* Protocol converter between Ibex interface and Wishbone interface */

`default_nettype none

module protocol_converter
  (/* Ibex memory interface */
   input  logic        req,
   output logic        gnt,
   output logic        rvalid,
   input  logic        we,
   input  logic [3:0]  be,
   input  logic [31:0] addr,
   input  logic [31:0] wdata,
   output logic [31:0] rdata,
   output logic        err,

   /* Wishbone interface */
   wb_if.master        wb);

   assign gnt      = req & ~wb.stall;
   assign rvalid   = wb.ack;
   assign err      = wb.err;
   assign rdata    = wb.dat_i;
   assign wb.stb   = req;
   assign wb.adr   = addr;
   assign wb.dat_o = wdata;
   assign wb.we    = we;
   assign wb.sel   = be;

   always_ff @(posedge wb.clk or posedge wb.rst or posedge req)
     if (wb.rst)
       wb.cyc <= 1'b0;
     else if (req)
       wb.cyc <= 1'b1;
     else if (wb.ack)
       wb.cyc <= 1'b0;   
endmodule

`resetall
