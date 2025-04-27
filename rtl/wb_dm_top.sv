/* RISC-V debug module with Wishbone interface */

module wb_dm_top
  #(parameter int                 NrHarts         = 1,
    parameter int                 BusWidth        = 32,
    parameter int unsigned        DmBaseAddress   = 'h1000, // default to non-zero page
    parameter logic [NrHarts-1:0] SelectableHarts = 1,      // Bitmask to select physically available harts for systems that don't use hart numbers in a contiguous fashion.
    parameter bit                 ReadByteEnable  = 1)      // toggle new behavior to drive master_be_o during a read
   (input  logic                        clk,                // clock
    input  logic                        rst_n,              // asynchronous reset active low, connect PoR here, not the system reset
    // Subsequent debug modules can be chained by setting the nextdm register value to the offset of
    // the next debug module. The RISC-V debug spec mandates that the first debug module located at
    // 0x0, and that the last debug module in the chain sets the nextdm register to 0x0. The nextdm
    // register is a word address and not a byte address. This value is passed in as a static signal
    // so that it becomes possible to assign this value with chiplet tie-offs or straps, if needed.
    input  logic [31:0]                 next_dm_addr,
    input  logic                        testmode,
    output logic                        ndmreset,           // non-debug module reset
    input  logic                        ndmreset_ack,       // non-debug module reset acknowledgement pulse
    output logic                        dmactive,           // debug module is active
    output logic [NrHarts-1:0]          debug_req,          // async debug request
    input  logic [NrHarts-1:0]          unavailable,        // communicate whether the hart is unavailable (e.g.: power down)
    input  dm::hartinfo_t [NrHarts-1:0] hartinfo,

    /* Wishbone interfaces */
    wb_if.slave                         wbs,
    wb_if.master                        wbm,

    /* Connection to DTM - compatible to RocketChip Debug Module */
    input  logic                        dmi_rst_n,     // Synchronous clear request from the DTM to clear the DMI response FIFO.
    input  logic                        dmi_req_valid,
    output logic                        dmi_req_ready,
    input  dm::dmi_req_t                dmi_req,

    output logic                        dmi_resp_valid,
    input  logic                        dmi_resp_ready,
    output dm::dmi_resp_t               dmi_resp);

   core_if slave_core  (.rst_n, .clk);
   core_if master_core (.rst_n, .clk);

   dm_top
     #(.NrHarts (NrHarts),
       .BusWidth(BusWidth),
       .SelectableHarts(SelectableHarts))
   inst_dm_top
     (.clk_i                (clk),
      .rst_ni               (rst_n),
      .next_dm_addr_i       (next_dm_addr),
      .testmode_i           (testmode),
      .ndmreset_o           (ndmreset),
      .ndmreset_ack_i       (ndmreset_ack),
      .dmactive_o           (dmactive),
      .debug_req_o          (debug_req),
      .unavailable_i        (unavailable),
      .hartinfo_i           (hartinfo),

      .slave_req_i          (slave_core.req),
      .slave_we_i           (slave_core.we),
      .slave_addr_i         (slave_core.addr),
      .slave_be_i           (slave_core.be),
      .slave_wdata_i        (slave_core.wdata),
      .slave_rdata_o        (slave_core.rdata),

      .master_req_o         (master_core.req),
      .master_add_o         (master_core.addr),
      .master_we_o          (master_core.we),
      .master_wdata_o       (master_core.wdata),
      .master_be_o          (master_core.be),
      .master_gnt_i         (master_core.gnt),
      .master_r_valid_i     (master_core.rvalid),
      .master_r_err_i       (master_core.err),
      .master_r_other_err_i (1'b0),
      .master_r_rdata_i     (master_core.rdata),

      .dmi_rst_ni           (dmi_rst_n),
      .dmi_req_valid_i      (dmi_req_valid),
      .dmi_req_ready_o      (dmi_req_ready),
      .dmi_req_i            (dmi_req),
      .dmi_resp_valid_o     (dmi_resp_valid),
      .dmi_resp_ready_i     (dmi_resp_ready),
      .dmi_resp_o           (dmi_resp));

   /* Wishbone */
   assign slave_core.gnt    = 1'b1;
   assign slave_core.rvalid = 1'b1;
   assign slave_core.err    = 1'b0;

   wb2core slave_core2wb
     (.core (slave_core),
      .wb   (wbs));

   core2wb master_core2wb
     (.core (master_core),
      .wb   (wbm));
endmodule
