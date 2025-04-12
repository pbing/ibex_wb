/* Clock and reset generator */

module crg
  (input  logic clk100m,
   input  logic ext_rst_n,
   output logic rst_n,
   output logic clk);

   BUFR
     #(.BUFR_DIVIDE("2"))
   clkdiv
     (.I   (clk100m),
      .O   (clk),
      .CE  (1'b1),
      .CLR (1'b0));

   sync_reset sync_reset
     (.clk,
      .ext_rst_n,
      .rst_n);
endmodule
