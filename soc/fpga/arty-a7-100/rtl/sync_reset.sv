/* Reset synchronizer */

module sync_reset
  #(parameter N = 2)
   (input  wire clk,
    input  wire ext_rst_n,
    output wire rst_n);

   logic [N-1:0] q;

   always_ff @(posedge clk or negedge ext_rst_n)
     if (!ext_rst_n)
       q <= '0;
     else
       q <= {q[N-2:0], 1'b1};

   assign rst_n = q[N-1];
endmodule
