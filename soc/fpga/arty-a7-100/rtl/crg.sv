/* Clock and reset generator */

module crg
  (input  logic clk100m,
   input  logic ext_rst_n,
   output logic rst_n,
   output logic clk);

/* -----\/----- EXCLUDED -----\/-----
   BUFR
     #(.BUFR_DIVIDE("4"))
   clkdiv
     (.I   (clk100m),
      .O   (clk),
      .CE  (1'b1),
      .CLR (1'b0));
 -----/\----- EXCLUDED -----/\----- */
   assign clk = clk100m;

   sync_reset sync_reset
     (.clk       (clk),
      .ext_rst_n (ext_rst_n),
      .rst_n);
endmodule
