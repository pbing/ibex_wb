/* Reset synchronizer */

`default_nettype none

module sync_reset
  #(parameter n = 2)
   (input  wire clk,
    input  wire ext_rst_n,
    output wire rst_n);

   logic [1:n] q;

   always_ff @(posedge clk or negedge ext_rst_n)
     if (!ext_rst_n)
       q <= '0;
     else
       q <= {1'b1, q[$left(q):$right(q) - 1]};

   assign rst_n = q[$right(q)];
endmodule

`resetall
