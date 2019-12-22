/* Clock gating cell */

`default_nettype none

module prim_clock_gating
  (input  wire  clk_i,
   input  wire  en_i,
   input  wire  test_en_i,
   output logic clk_o);

   fpga_clock_gating cg(.inclk  (clk_i),
		        .ena    (en_i | test_en_i),
		        .outclk (clk_o));
endmodule

`resetall
