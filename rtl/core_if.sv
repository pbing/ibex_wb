/* Core interface */

interface core_if
  (input logic clk,
   input logic rst_n);

   logic        req;
   logic        gnt;
   logic        rvalid;
   logic        we;
   logic [3:0]  be;
   logic [31:0] addr;
   logic [31:0] wdata;
   logic [31:0] rdata;
   logic        err;

   modport master
     (input  clk,
      input  rst_n,
      output req,
      input  gnt,
      input  rvalid,
      output we,
      output be,
      output addr,
      output wdata,
      input  rdata,
      input  err);

   modport slave
     (input  clk,
      input  rst_n,
      input  req,
      output gnt,
      output rvalid,
      input  we,
      input  be,
      input  addr,
      input  wdata,
      output rdata,
      output err);

   modport monitor
     (input  clk,
      input  rst_n,
      input  req,
      input  gnt,
      input  rvalid,
      input  we,
      input  be,
      input  addr,
      input  wdata,
      input  rdata,
      input  err);
endinterface
