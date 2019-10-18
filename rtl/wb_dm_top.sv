/* RISC-V debug module with Wishbone interface */

`default_nettype none

module wb_dm_top
  #(parameter int                 NrHarts          = 1,
    parameter int                 BusWidth         = 32,
    parameter logic [NrHarts-1:0] SelectableHarts  = 1) // Bitmask to select physically available harts for systems that don't use hart numbers in a contiguous fashion.
   (input  wire                   clk,                  // clock
    input  wire                   rst_n,                // asynchronous reset active low, connect PoR here, not the system reset
    input  wire                   testmode,
    output logic                  ndmreset,             // non-debug module reset
    output logic                  dmactive,             // debug module is active
    output logic [NrHarts-1:0]    debug_req,            // async debug request
    input  wire  [NrHarts-1:0]    unavailable,          // communicate whether the hart is unavailable (e.g.: power down)
    dm::hartinfo_t [NrHarts-1:0]  hartinfo,

    /* Wishbone interfaces */
    wb_if.slave                   wbs,
    wb_if.master                  wbm,

    /* Connection to DTM - compatible to RocketChip Debug Module */
    input  wire                   dmi_rst_n,
    input  wire                   dmi_req_valid,
    output logic                  dmi_req_ready,
    input  dm::dmi_req_t          dmi_req,

    output logic                  dmi_resp_valid,
    input  wire                   dmi_resp_ready,
    output dm::dmi_resp_t         dmi_resp);

   logic                  slave_req;
   logic                  slave_we;
   logic [BusWidth-1:0]   slave_addr;
   logic [BusWidth/8-1:0] slave_be;
   logic [BusWidth-1:0]   slave_wdata;
   logic [BusWidth-1:0]   slave_rdata;

   core_if master_core(.*);

   dm_top
     #(.NrHarts (NrHarts),
       .BusWidth(BusWidth),
       .SelectableHarts(SelectableHarts))
   inst_dm_top
     (.clk_i            (clk),
      .rst_ni           (rst_n),
      .testmode_i       (testmode),
      .ndmreset_o       (ndmreset),
      .dmactive_o       (dmactive),
      .debug_req_o      (debug_req),
      .unavailable_i    (unavailable),
      .hartinfo_i       (hartinfo),

      .slave_req_i      (slave_req),
      .slave_we_i       (slave_we),
      .slave_addr_i     (slave_addr),
      .slave_be_i       (slave_be),
      .slave_wdata_i    (slave_wdata),
      .slave_rdata_o    (slave_rdata),

      .master_req_o     (master_core.req),
      .master_add_o     (master_core.addr),
      .master_we_o      (master_core.we),
      .master_wdata_o   (master_core.wdata),
      .master_be_o      (master_core.be),
      .master_gnt_i     (master_core.gnt),
      .master_r_valid_i (master_core.rvalid),
      .master_r_rdata_i (master_core.rdata),

      .dmi_rst_ni       (dmi_rst_n),
      .dmi_req_valid_i  (dmi_req_valid),
      .dmi_req_ready_o  (dmi_req_ready),
      .dmi_req_i        (dmi_req),
      .dmi_resp_valid_o (dmi_resp_valid),
      .dmi_resp_ready_i (dmi_resp_ready),
      .dmi_resp_o       (dmi_resp));

   /* Wishbone */
   assign slave_req   = wbs.stb;
   assign slave_we    = wbs.we;
   assign slave_addr  = wbs.adr;
   assign slave_be    = wbs.sel;
   assign slave_wdata = wbs.dat_i;
   assign wbs.dat_o   = slave_rdata;
   assign wbs.stall   = 1'b0;
   assign wbs.err     = 1'b0;

   always_ff @(posedge wbs.clk or posedge wbs.rst)
     if (wbs.rst)
       wbs.ack <= 1'b0;
     else
       wbs.ack <= wbs.cyc & wbs.stb;

   core2wb master_core2wb
     (.core (master_core),
      .wb   (wbm));
endmodule

`resetall
