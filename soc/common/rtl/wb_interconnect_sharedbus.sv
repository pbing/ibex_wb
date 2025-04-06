/* Wishbone interconnect (classic pipelined)
 *
 * Wishbone B4, section 8.10 "Shared Bus Example"
 */

module wb_interconnect_sharedbus
  #(parameter numm = 3,                      // number of masters
    parameter nums = 3,                      // number of slaves
    parameter [31:0] base_addr[nums] = '{0}, // base addresses of slaves
    parameter [31:0] size[nums]      = '{0}) // address size of slaves
   (wb_if.slave  wbm[numm],                  // Wishbone master interfaces
    wb_if.master wbs[nums]);                 // Wishbone slave interfaces
   logic             cyc, stb, we, ack, err, stall;
   logic [31:0]      adr;
   logic [3:0]       sel;
   logic [31:0]      dat_wr, dat_rd;
   logic [numm-1:0]  gnt, gnt1;
   logic [nums-1:0]  ss, ss1;

   /********************************************************************************
    * Use packed types because of this VCS error message:
    *
    * Error-[SV-TCF] Type checking failed
    * Reason of type check failure : Only constant index is supported here.
    ********************************************************************************/
   logic [numm-1:0]       wbm_cyc, wbm_stb, wbm_we, wbm_ack, wbm_err, wbm_stall;
   logic [numm-1:0][31:0] wbm_adr;
   logic [numm-1:0][3:0]  wbm_sel;

`ifdef NO_MODPORT_EXPRESSIONS
   logic [numm-1:0][31:0] wbm_dat_m, wbm_dat_s;
`else
   logic [numm-1:0][31:0] wbm_dat_i, wbm_dat_o;
`endif

   for (genvar i = 0; i < numm; i++) begin
      assign
        wbm_cyc[i]   = wbm[i].cyc,
        wbm_stb[i]   = wbm[i].stb,
        wbm_we[i]    = wbm[i].we,
        wbm[i].ack   = wbm_ack[i],
        wbm[i].err   = wbm_err[i],
        wbm[i].stall = wbm_stall[i],
        wbm_adr[i]   = wbm[i].adr,
        wbm_sel[i]   = wbm[i].sel;

      assign
      `ifdef NO_MODPORT_EXPRESSIONS
        wbm_dat_m[i] = wbm[i].dat_m,
        wbm[i].dat_s = wbm_dat_s[i];
      `else
        wbm_dat_i[i] = wbm[i].dat_i,
        wbm[i].dat_o = wbm_dat_o[i];
      `endif
   end

   logic [nums-1:0]       wbs_cyc, wbs_stb, wbs_we, wbs_ack, wbs_err, wbs_stall;
   logic [nums-1:0][31:0] wbs_adr;
   logic [nums-1:0][3:0]  wbs_sel;
`ifdef NO_MODPORT_EXPRESSIONS
   logic [nums-1:0][31:0] wbs_dat_s, wbs_dat_m;
`else
   logic [nums-1:0][31:0] wbs_dat_i, wbs_dat_o;
`endif

   for (genvar i = 0; i < nums; i++) begin
      assign
        wbs[i].cyc   =  wbs_cyc[i],
        wbs[i].stb   =  wbs_stb[i],
        wbs[i].we    =  wbs_we[i],
        wbs_ack[i]   =  wbs[i].ack,
        wbs_err[i]   =  wbs[i].err,
        wbs_stall[i] =  wbs[i].stall,
        wbs[i].adr   =  wbs_adr[i],
        wbs[i].sel   =  wbs_sel[i];

      assign
      `ifdef NO_MODPORT_EXPRESSIONS
        wbs[i].dat_m =  wbs_dat_m[i],
        wbs_dat_s[i] =  wbs[i].dat_s;
      `else
        wbs[i].dat_o =  wbs_dat_o[i],
        wbs_dat_i[i] =  wbs[i].dat_i;
      `endif
   end

   /********************************************************************************/

   /* slave address select */
   always_comb
     for (int i = 0; i < nums; i++)
       ss[i] = (adr >= base_addr[i]) && (adr < base_addr[i] + size[i]);

   /* Assume, that the response is exactly on cycle after request. */
   always_ff @(posedge wbs[0].clk or posedge wbs[0].rst)
     if (wbs[0].rst)
       ss1 <= '0;
     else
       if (cyc && stb)
         ss1 <= ss;

   /* priority arbiter */
   always_comb begin
      gnt = '0;
      for (int i = 0; i < numm; i++)
        if (wbm_cyc[i]) begin
           gnt[i] = 1'b1;
           break;
        end
   end

   /* Assume, that the response is exactly on cycle after request. */
   always_ff @(posedge wbm[0].clk or posedge wbm[0].rst)
     if (wbm[0].rst)
       gnt1 <= '0;
     else
       if (cyc && stb)
         gnt1 <= gnt;

   /* shared bus signals */
   always_comb begin
      cyc    = 1'b0;
      adr    = '0;
      stb    = 1'b0;
      we     = 1'b0;
      sel    = '0;
      dat_wr = '0;
      for (int i = 0; i < numm; i++) begin
         cyc |= wbm_cyc[i];
         if (gnt[i]) begin
            adr    = wbm_adr[i];
            stb    = wbm_stb[i];
            we     = wbm_we[i];
            sel    = wbm_sel[i];
         `ifdef NO_MODPORT_EXPRESSIONS
            dat_wr = wbm_dat_m[i];
         `else
            dat_wr = wbm_dat_i[i];
         `endif
         end
      end
   end

   always_comb begin
      ack    = 1'b0;
      err    = 1'b0;
      stall  = 1'b0;
      dat_rd = '0;
      for (int i = 0; i < nums; i++) begin
         ack   |= wbs_ack[i];
         err   |= wbs_err[i];
         stall |= wbs_stall[i];
         if (ss1[i])
         `ifdef NO_MODPORT_EXPRESSIONS
           dat_rd = wbs_dat_s[i];
         `else
           dat_rd = wbs_dat_i[i];
         `endif
      end
   end

   /* interconnect */

   /* STALL must respond immediately. */
   always_comb begin
      for (int i = 0; i < numm; i++) begin
         wbm_stall[i] = 1'b1;
         if (gnt[i])
           wbm_stall[i] = stall;
      end
   end

   /* Response signals are one cycle delayed. */
   always_comb begin
      for (int i = 0; i < numm; i++) begin
         wbm_ack[i]   = 1'b0;
         wbm_err[i]   = 1'b0;
      `ifdef NO_MODPORT_EXPRESSIONS
         wbm_dat_s[i] = '0;
      `else
         wbm_dat_o[i] = '0;
      `endif
         if (gnt1[i]) begin
            wbm_ack[i]   = ack;
            wbm_err[i]   = err;
         `ifdef NO_MODPORT_EXPRESSIONS
            wbm_dat_s[i] = dat_rd;
         `else
            wbm_dat_o[i] = dat_rd;
         `endif
         end
      end
   end

   always_comb
     for (int i = 0; i < nums; i++) begin
        wbs_cyc[i]   = cyc;
        wbs_adr[i]   = '0;
        wbs_stb[i]   = 1'b0;
        wbs_we[i]    = we;
        wbs_sel[i]   = '0;
     `ifdef NO_MODPORT_EXPRESSIONS
        wbs_dat_m[i] = '0;
     `else
        wbs_dat_o[i] = '0;
     `endif
        if (ss[i]) begin
           wbs_adr[i]   = adr;
           wbs_stb[i]   = cyc & stb;
           wbs_sel[i]   = sel;
        `ifdef NO_MODPORT_EXPRESSIONS
           wbs_dat_m[i] = dat_wr;
        `else
           wbs_dat_o[i] = dat_wr;
        `endif
        end
     end
endmodule
