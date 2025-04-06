/* Wrapper around ZipCPU/wbxbar */

module  wb_interconnect_xbar
  #(parameter numm = 3,                      // number of masters
    parameter nums = 3,                      // number of slaves
    parameter [31:0] base_addr[nums] = '{0}, // base addresses of slaves
    parameter [31:0] size[nums]      = '{0}) // address size of slaves
   (wb_if.slave  wbm[numm],                  // Wishbone master interfaces
    wb_if.master wbs[nums]);                 // Wishbone slave interfaces

   import wb_pkg::*;

   localparam aw = $bits(adr_t);
   localparam dw = $bits(dat_t);
   localparam sw = $bits(sel_t);

   localparam [nums-1:0][aw-1:0] slave_addr = {base_addr[2], base_addr[1], base_addr[0]};
   //localparam [nums-1:0][aw-1:0] slave_mask = {32'hfffff000, 32'hffff0000, 32'hfffff000};
   localparam [nums-1:0][aw-1:0] slave_mask = {~(size[2]-1), ~(size[1]-1), ~(size[0]-1)};

   logic [numm-1:0]         wbm_cyc;
   logic [numm-1:0]         wbm_stb;
   logic [numm-1:0]         wbm_we;
   logic [numm-1:0][aw-1:0] wbm_adr;
   logic [numm-1:0][sw-1:0] wbm_sel;

   logic [numm-1:0]         wbm_stall;
   logic [numm-1:0]         wbm_ack;
   logic [numm-1:0]         wbm_err;

`ifdef NO_MODPORT_EXPRESSIONS
   logic [numm-1:0][dw-1:0] wbm_dat_m, wbm_dat_s;
`else
   logic [numm-1:0][dw-1:0] wbm_dat_i, wbm_dat_o;
`endif

   logic [nums-1:0]         wbs_cyc;
   logic [nums-1:0]         wbs_stb;
   logic [nums-1:0]         wbs_we;
   logic [nums-1:0][aw-1:0] wbs_adr;
   logic [nums-1:0][sw-1:0] wbs_sel;

   logic [nums-1:0]         wbs_stall;
   logic [nums-1:0]         wbs_ack;
   logic [nums-1:0]         wbs_err;

`ifdef NO_MODPORT_EXPRESSIONS
   logic [nums-1:0][dw-1:0] wbs_dat_s, wbs_dat_m;
`else
   logic [nums-1:0][dw-1:0] wbs_dat_i, wbs_dat_o;
`endif

   wbxbar
     #(.NM         (numm),
       .NS         (nums),
       .AW         (aw),
       .DW         (dw),
       .SLAVE_ADDR (slave_addr),
       .SLAVE_MASK (slave_mask))
   u_wbxbar
     (.i_clk    (wbm[0].clk),
      .i_reset  (wbm[0].rst),

      .i_mcyc   (wbm_cyc),
      .i_mstb   (wbm_stb),
      .i_mwe    (wbm_we),
      .i_maddr  (wbm_adr),
`ifdef NO_MODPORT_EXPRESSIONS
      .i_mdata  (wbm_dat_m),
`else
      .i_mdata  (wbm_dat_i),
`endif
      .i_msel   (wbm_sel),

      .o_mstall (wbm_stall),
      .o_mack   (wbm_ack),
`ifdef NO_MODPORT_EXPRESSIONS
      .o_mdata  (wbm_dat_s),
`else
      .o_mdata  (wbm_dat_o),
`endif
      .o_merr   (wbm_err),

      .o_scyc   (wbs_cyc),
      .o_sstb   (wbs_stb),
      .o_swe    (wbs_we),
      .o_saddr  (wbs_adr),
`ifdef NO_MODPORT_EXPRESSIONS
      .o_sdata  (wbs_dat_m),
`else
      .o_sdata  (wbs_dat_o),
`endif
      .o_ssel   (wbs_sel),

      .i_sstall (wbs_stall),
      .i_sack   (wbs_ack),
`ifdef NO_MODPORT_EXPRESSIONS
      .i_sdata  (wbs_dat_s),
`else
      .i_sdata  (wbs_dat_i),
`endif
      .i_serr   (wbs_err));

   for (genvar i = 0; i < numm; i++) begin
      assign
        wbm_cyc[i]   = wbm[i].cyc,
        wbm_stb[i]   = wbm[i].stb,
        wbm_we[i]    = wbm[i].we,
        wbm_adr[i]   = wbm[i].adr,
        wbm_sel[i]   = wbm[i].sel,

        wbm[i].stall = wbm_stall[i],
        wbm[i].ack   = wbm_ack[i],
        wbm[i].err   = wbm_err[i];

`ifdef NO_MODPORT_EXPRESSIONS
      assign
        wbm_dat_m[i] = wbm[i].dat_m,
        wbm[i].dat_s = wbm_dat_s[i];
`else
      assign
        wbm_dat_i[i] = wbm[i].dat_i,
        wbm[i].dat_o = wbm_dat_o[i];
`endif
   end

   for (genvar i = 0; i < nums; i++) begin
      assign
        wbs[i].cyc   = wbs_cyc[i],
        wbs[i].stb   = wbs_stb[i],
        wbs[i].we    = wbs_we[i],
        wbs[i].adr   = wbs_adr[i],
        wbs[i].sel   = wbs_sel[i],

        wbs_stall[i] = wbs[i].stall,
        wbs_ack[i]   = wbs[i].ack,
        wbs_err[i]   = wbs[i].err;

`ifdef NO_MODPORT_EXPRESSIONS
      assign
        wbs[i].dat_m = wbs_dat_m[i],
        wbs_dat_s[i] = wbs[i].dat_s;
`else
      assign
        wbs[i].dat_o = wbs_dat_o[i],
        wbs_dat_i[i] = wbs[i].dat_i;
`endif
   end
endmodule
