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

   core_if slave_core(.*);
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

      .slave_req_i      (slave_core.req),
      .slave_we_i       (slave_core.we),
      .slave_addr_i     (slave_core.addr),
      .slave_be_i       (slave_core.be),
      .slave_wdata_i    (slave_core.wdata),
      .slave_rdata_o    (slave_core.rdata),

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
   slave2wb slave_core2wb
     (.slave (slave_core),
      .wb    (wbs));

   core2wb master_core2wb
     (.core (master_core),
      .wb   (wbm));
endmodule

`resetall
