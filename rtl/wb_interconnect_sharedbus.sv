/* Wishbone interconnect (classic pipelined)
 *
 * Wishbone B4, section 8.10 "Shared Bus Example"
 */

`default_nettype none

module wb_interconnect_sharedbus
  (if_wb.slave  wbm[2],  // 0:CPU data, 1:CPU instructions
   if_wb.master wbs[2]); // 0:ROM, 1:RAM
   logic        clk, rst, cyc, stb, we, ack, err, stall;
   logic [3:0]  sel;
   logic [1:0]  gnt;
   logic [1:0]  ss, ss1;
   logic [31:0] adr;
   logic [31:0] wbm_dat_o, wbs_dat_o;

   assign clk = wbm[0].clk;
   assign rst = wbm[0].rst;

   /* priority arbiter */
   assign gnt[0] = wbm[0].cyc;
   assign gnt[1] = !wbm[0].cyc & wbm[1].cyc;

   /* slave address select */
   assign ss[0] = (adr[31:14] == 32'h00000000 >> 14) | // ROM: 0x00000000...0x0000c000
                  (adr[31:14] == 32'h00004000 >> 14) | // ROM: 0x00004000...0x00007fff
                  (adr[31:14] == 32'h00008000 >> 14);  // ROM: 0x00008000...0x0000bfff
   assign ss[1] = (adr[31:14] == 32'h0000c000 >> 14);  // RAM: 0x0000c000...0x0000ffff

   always_ff @(posedge clk or posedge rst)
     if (rst)
       ss1 <= '0;
     else
       ss1 <= ss;
   
   /* shared bus signals */
   assign adr    = (wbm[0].adr & {32{gnt[0]}}) | (wbm[1].adr & {32{gnt[1]}});
   assign cyc    = wbm[0].cyc | wbm[1].cyc;
   assign stb    = (wbm[0].stb & gnt[0]) | (wbm[1].stb & gnt[1]);
   assign we     = (wbm[0].we & gnt[0]) | (wbm[1].we & gnt[1]);
   assign sel    = (wbm[0].sel & {4{gnt[0]}}) | (wbm[1].sel & {4{gnt[1]}});
   assign dat_wr = (wbm[0].dat_i & {32{gnt[0]}}) | (wbm[1].dat_i & {32{gnt[1]}});
   assign ack    = wbs[0].ack | wbs[1].ack;
   assign err    = wbs[0].err | wbs[1].err;
   assign stall  = wbs[0].stall | wbs[1].stall;
   assign dat_rd = (wbs[0].dat_i & {32{ss1[0]}}) | (wbs[1].dat_i & {32{ss1[1]}});

   /* interconnect */
   assign wbm[0].ack   = ack & gnt[0];
   assign wbm[0].err   = err & gnt[0];
   assign wbm[0].stall = (stall & gnt[0]) | (wbm[0].cyc & ~gnt[0]);
   assign wbm[0].dat_o = dat_rd;

   assign wbm[1].ack   = ack & gnt[1];
   assign wbm[1].err   = err & gnt[1];
   assign wbm[1].stall = (stall & gnt[1]) | (wbm[1].cyc & ~gnt[1]);
   assign wbm[1].dat_o = dat_rd;

   assign wbs[0].adr   = adr;
   assign wbs[0].cyc   = cyc;
   assign wbs[0].stb   = cyc & stb & ss[0];
   assign wbs[0].we    = we;
   assign wbs[0].sel   = sel;
   assign wbs[0].dat_o = dat_wr;

   assign wbs[1].adr   = adr;
   assign wbs[1].cyc   = cyc;
   assign wbs[1].stb   = cyc & stb & ss[1];
   assign wbs[1].we    = we;
   assign wbs[1].sel   = sel;
   assign wbs[1].dat_o = dat_wr;
endmodule

`resetall
