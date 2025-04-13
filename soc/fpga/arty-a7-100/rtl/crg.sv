/* Clock and reset generator */

module crg
  (input  logic clk100m,
   input  logic ext_rst_n,
   output logic rst_n,
   output logic clk);

   clkgen_50mhz u_glk_gen
     (.clk_out1 (clk),
      .clk_in1  (clk100m));

   sync_reset sync_reset
     (.clk,
      .ext_rst_n,
      .rst_n);
endmodule
