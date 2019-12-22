/* Clock and reset generator */

`default_nettype none

module crg
  (input  wire clk50m,
   input  wire ext_rst_n,
   output wire rst_n,
   output wire clk);

   assign clk = clk50m;

   sync_reset sync_reset
     (.clk       (clk),
      .ext_rst_n (ext_rst_n),
      .rst_n);
endmodule

`resetall
