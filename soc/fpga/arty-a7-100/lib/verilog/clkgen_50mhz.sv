/* Simple simulation model for Verilator */

module clkgen_50mhz
  (output logic clk_out1,
   input  logic clk_in1);

   initial
     clk_out1 = 1'b0;

   always @(posedge clk_in1)
     clk_out1 <= ~clk_out1;
endmodule
