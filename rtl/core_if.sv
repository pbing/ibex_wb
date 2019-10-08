/* Core interface */

`default_nettype none

interface core_if;
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
     (output req,
      input  gnt,
      input  rvalid,
      output we,
      output be,
      output addr,
      output wdata,
      input  rdata,
      input  err);

   modport slave
     (input  req,
      output gnt,
      output rvalid,
      input  we,
      input  be,
      input  addr,
      input  wdata,
      output rdata,
      output err);
endinterface

`resetall
