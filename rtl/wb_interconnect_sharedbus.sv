/* Wishbone interconnect (classic pipelined)
 *
 * Wishbone B4, section 8.10 "Shared Bus Example"
 */

`default_nettype none

module wb_interconnect_sharedbus
  #(parameter numm = 2,        // number of masters
    parameter nums = 2,        // number of slaves
    parameter base_addr[nums], // base addresses of slaves
    parameter size[nums])      // address size of slaves
   (if_wb.slave  wbm[numm],    // Wishbone master interfaces
    if_wb.master wbs[nums]);   // Wishbone slave interfaces
   logic               clk, rst, cyc, stb, we, ack, err, stall;
   logic [numm - 1:0]  gnt;
   logic [nums - 1:0]  ss, ss1;
   logic [31:0]        adr;
   logic [3:0]         sel;
   logic [31:0]        wbm_dat_o, wbs_dat_o;

   /* slave address select */
   for (int i; i < nums; i++)
     ss[i] = (adr >= base_addr[i]) && (adr < base_addr[i] + size[i]);

   always_ff @(posedge wbs[0].clk or posedge wbs[0].rst)
     if (rst)
       ss1 <= '0;
     else
       ss1 <= ss;
   
   /* priority arbiter */
   always_comb
     for (int i = 0; i < numm; i++)
       begin
          gnt[i] = 1'b0;
          if (wbm[i].cyc)
            begin
               gnt[i] = 1'b1;
               break;
            end
       end

   /* shared bus signals */
   always_comb
     begin
        cyc    = 1'b0;
        adr    = '0;
        stb    = 1'b0;
        we     = 1'b0;
        sel    = '0;
        dat_wr = '0;
        for (int i = 0; i < numm; i++)
          begin
             cyc |= wbm[i].cyc;
             if (gnt[i])
               begin
                  adr    = wbm[i].adr;
                  stb    = wbm[i].stb;
                  we     = wbm[i].we;
                  sel    = wbm[i].sel;
                  dat_wr = wbm[i].dat_wr;
               end
          end
     end

   always_comb
     begin
        ack    = 1'b0;
        err    = 1'b0;
        stall  = 1'b0;
        dat_rd = '0;
        for (int i = 0; i < nums; i++)
          begin
             ack   |= wbs[i].ack;
             err   |= wbs[i].err;
             stall |= wbs[i].stall;
             if (ss1[i])
               dat_rd = wbs[i].dat_i;
          end
     end

   /* interconnect */
   always_comb
     begin
        for (int i = 0; i < numm; i++)
          begin
             wbm[i].ack   = 1'b0;
             wbm[i].err   = 1'b0;
             wbm[i].stall = 1'b0;
             wbm[i].dat_o = '0;
             if (gnt[i])
               begin
                  wbm[i].ack   = ack;
                  wbm[i].err   = err;
                  wbm[i].stall = stall;
                  wbm[i].dat_o = dat_rd;
               end
          end
     end

   always_comb
     for (int i = 0; i < nums; i++)
       begin
          wbs[i].cyc   = cyc;
          wbs[i].adr   = '0;
          wbs[i].stb   = 1'b0;
          wbs[i].we    = we;
          wbs[i].sel   = '0;
          wbs[i].dat_o = '0;
          if (ss[i])
            begin
               wbs[i].adr   = adr;
               wbs[i].stb   = cyc & stb;
               wbs[i].sel   = sel;
               wbs[i].dat_o = dat_wr;
            end
       end
endmodule

`resetall
