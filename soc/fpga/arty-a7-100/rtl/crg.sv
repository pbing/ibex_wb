/* Clock and reset generator */

`default_nettype none

module crg
  (input  wire clk100m,
   input  wire ext_rst_n,
   output wire rst_n,
   output wire clk);

   BUFR
     #(.BUFR_DIVIDE("4"))
   clkdiv
     (.I   (clk100m),
      .O   (clk),
      .CE  (1'b1),
      .CLR (1'b0));

   sync_reset sync_reset
     (.clk       (clk),
      .ext_rst_n (ext_rst_n),
      .rst_n);
endmodule

`resetall
