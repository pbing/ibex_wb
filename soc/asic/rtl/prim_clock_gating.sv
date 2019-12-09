/* ASIC implementation */

module prim_clock_gating 
  (input        clk_i,
   input        en_i,
   input        test_en_i,
   output logic clk_o);

SCC2CKGTDSDLANDYECLXH1 u_clock_gating
     (.CLK  (clk_i),
      .CEN  (en_i),
      .SMC  (test_en_i),
      .GCLK (clk_o));
endmodule
