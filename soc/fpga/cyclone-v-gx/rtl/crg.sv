/* Clock and reset generator */

module crg
  (input  wire clk50m,
   input  wire ext_rst_n,
   output wire rst_n,
   output wire clk);

   assign clk = clk50m;

   sync_reset sync_reset
     (.clk (clk50m),
      .ext_rst_n,
      .rst_n);
endmodule
