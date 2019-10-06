/* Wishbone interconnect (classic pipelined)
 *
 * Wishbone B4, section 8.10 "Shared Bus Example"
 */

`default_nettype none

module wb_interconnect_sharedbus
  #(parameter numm = 2,               // number of masters
    parameter nums,                   // number of slaves
    parameter [31:0] base_addr[nums], // base addresses of slaves
    parameter [31:0] size[nums])      // address size of slaves
   (wb_if.slave  wbm[numm],           // Wishbone master interfaces
    wb_if.master wbs[nums]);          // Wishbone slave interfaces
   logic               cyc, stb, we, ack, err, stall;
   logic [31:0]        adr;
   logic [3:0]         sel;
   logic [31:0]        dat_wr, dat_rd;
   logic [numm - 1:0]  gnt;
   logic [nums - 1:0]  ss, ss1;

   /********************************************************************************
    * Use packed types because of this VCS error message:
    *
    * Error-[SV-TCF] Type checking failed
    * Reason of type check failure : Only constant index is supported here.
    ********************************************************************************/
   logic [numm - 1:0]       wbm_cyc, wbm_stb, wbm_we, wbm_ack, wbm_err, wbm_stall;
   logic [numm - 1:0][31:0] wbm_adr;
   logic [numm - 1:0][3:0]  wbm_sel;
   logic [numm - 1:0][31:0] wbm_dat_i, wbm_dat_o;

   for (genvar i = 0; i < numm; i++)
     begin
        assign wbm_cyc[i]   = wbm[i].cyc;
        assign wbm_stb[i]   = wbm[i].stb;
        assign wbm_we[i]    = wbm[i].we;
        assign wbm[i].ack   = wbm_ack[i];
        assign wbm[i].err   = wbm_err[i];
        assign wbm[i].stall = wbm_stall[i];
        assign wbm_adr[i]   = wbm[i].adr;
        assign wbm_sel[i]   = wbm[i].sel;
        assign wbm_dat_i[i] = wbm[i].dat_i;
        assign wbm[i].dat_o = wbm_dat_o[i];
     end

   logic [nums - 1:0]       wbs_cyc, wbs_stb, wbs_we, wbs_ack, wbs_err, wbs_stall;
   logic [nums - 1:0][31:0] wbs_adr;
   logic [nums - 1:0][3:0]  wbs_sel;
   logic [nums - 1:0][31:0] wbs_dat_i, wbs_dat_o;

   for (genvar i = 0; i < nums; i++)
     begin
        assign wbs[i].cyc   =    wbs_cyc[i]; 
        assign wbs[i].stb   =    wbs_stb[i]; 
        assign wbs[i].we    =     wbs_we[i]; 
        assign wbs_ack[i]   =    wbs[i].ack; 
        assign wbs_err[i]   =    wbs[i].err; 
        assign wbs_stall[i] =  wbs[i].stall; 
        assign wbs[i].adr   =    wbs_adr[i]; 
        assign wbs[i].sel   =    wbs_sel[i]; 
        assign wbs[i].dat_o =  wbs_dat_o[i]; 
        assign wbs_dat_i[i] =  wbs[i].dat_i; 
     end

   /********************************************************************************/

   /* slave address select */
   always_comb
     for (int i = 0; i < nums; i++)
       ss[i] = (adr >= base_addr[i]) && (adr < base_addr[i] + size[i]);

   always_ff @(posedge wbs[0].clk or posedge wbs[0].rst)
     if (wbs[0].rst)
       ss1 <= '0;
     else
       ss1 <= ss;
   
   /* priority arbiter */
   always_comb
     begin
        gnt = '0;
        for (int i = 0; i < numm; i++)
          if (wbm_cyc[i])
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
             cyc |= wbm_cyc[i];
             if (gnt[i])
               begin
                  adr    = wbm_adr[i];
                  stb    = wbm_stb[i];
                  we     = wbm_we[i];
                  sel    = wbm_sel[i];
                  dat_wr = wbm_dat_i[i];
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
             ack   |= wbs_ack[i];
             err   |= wbs_err[i];
             stall |= wbs_stall[i];
             if (ss1[i])
               dat_rd = wbs_dat_i[i];
          end
     end

   /* interconnect */
   always_comb
     begin
        for (int i = 0; i < numm; i++)
          begin
             wbm_ack[i]   = 1'b0;
             wbm_err[i]   = 1'b0;
             wbm_stall[i] = 1'b1; // FIXME
             wbm_dat_o[i] = '0;
             if (gnt[i])
               begin
                  wbm_ack[i]   = ack;
                  wbm_err[i]   = err;
                  wbm_stall[i] = stall;
                  wbm_dat_o[i] = dat_rd;
               end
          end
     end

   always_comb
     for (int i = 0; i < nums; i++)
       begin
          wbs_cyc[i]   = cyc;
          wbs_adr[i]   = '0;
          wbs_stb[i]   = 1'b0;
          wbs_we[i]    = we;
          wbs_sel[i]   = '0;
          wbs_dat_o[i] = '0;
          if (ss[i])
            begin
               wbs_adr[i]   = adr;
               wbs_stb[i]   = cyc & stb;
               wbs_sel[i]   = sel;
               wbs_dat_o[i] = dat_wr;
            end
       end

`ifndef SYNTHESIS
   gnt_onehot0: assert property(@(posedge wbm[0].clk) disable iff(wbm[0].rst) $onehot0(gnt));
`endif
endmodule

`resetall
