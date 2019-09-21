/* Classic pipelined bus cycle Wishbone
 *
 * These modport expressions do not work with Design Compiler:
 *
 * modport master (.dat_i(dat_s), .dat_o(dat_m), ...);
 * modport slave  (.dat_i(dat_m), .dat_o(dat_s), ...);
 */

`default_nettype none

interface if_wb
  (input logic rst,
   input logic clk);

   typedef logic [31:0] adr_t;
   typedef logic [31:0] dat_t;
   typedef logic [3:0]  sel_t;

   logic ack;
   adr_t adr;
   logic cyc;
   logic stall;
   logic stb;
   logic we;
   sel_t sel;
   logic err;
   dat_t dat_m; // channel from master
   dat_t dat_s; // channel from slave

   modport master
     (input  clk,
      input  rst,
      input  ack,
      output adr,
      output cyc,
      input  stall,
      output stb,
      output we,
      output sel,
      input  err,
`ifdef NO_MODPORT_EXPRESSIONS
      input  dat_s,
      output dat_m
`else
      input  .dat_i(dat_s),
      output .dat_o(dat_m)
`endif
      );

   modport slave
     (input  clk,
      input  rst,
      output ack,
      input  adr,
      input  cyc,
      output stall,
      input  stb,
      input  we,
      input  sel,
      output err,
`ifdef NO_MODPORT_EXPRESSIONS
      input  dat_m,
      output dat_s
`else
      input  .dat_i(dat_m),
      output .dat_o(dat_s)
`endif
      );

   modport monitor
     (input  clk,
      input  rst,
      input  ack,
      input  adr,
      input  cyc,
      input  stall,
      input  stb,
      input  we,
      input  sel,
      input  err,
      input  dat_m,
      input  dat_s);
endinterface: if_wb

`resetall
