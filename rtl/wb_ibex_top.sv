/* RISC-V Ibex core with Wishbone B4 interface */

module wb_ibex_top
  import ibex_pkg::*;
   #(parameter bit                          PMPEnable                    = 1'b0,
     parameter int unsigned                 PMPGranularity               = 0,
     parameter int unsigned                 PMPNumRegions                = 4,
     parameter int unsigned                 MHPMCounterNum               = 0,
     parameter int unsigned                 MHPMCounterWidth             = 40,
     parameter ibex_pkg::pmp_cfg_t          PMPRstCfg[16]                = ibex_pkg::PmpCfgRst,
     parameter logic [33:0]                 PMPRstAddr[16]               = ibex_pkg::PmpAddrRst,
     parameter ibex_pkg::pmp_mseccfg_t      PMPRstMsecCfg                = ibex_pkg::PmpMseccfgRst,
     parameter bit                          RV32E                        = 1'b0,
     parameter rv32m_e                      RV32M                        = RV32MFast,
     parameter rv32b_e                      RV32B                        = RV32BNone,
     parameter regfile_e                    RegFile                      = RegFileFF,
     parameter bit                          BranchTargetALU              = 1'b0,
     parameter bit                          WritebackStage               = 1'b0,
     parameter bit                          ICache                       = 1'b0,
     parameter bit                          ICacheECC                    = 1'b0,
     parameter bit                          BranchPredictor              = 1'b0,
     parameter bit                          DbgTriggerEn                 = 1'b1,
     parameter int unsigned                 DbgHwBreakNum                = 1,
     parameter bit                          SecureIbex                   = 1'b0,
     parameter bit                          ICacheScramble               = 1'b0,
     parameter int unsigned                 ICacheScrNumPrinceRoundsHalf = 2,
     parameter lfsr_seed_t                  RndCnstLfsrSeed              = RndCnstLfsrSeedDefault,
     parameter lfsr_perm_t                  RndCnstLfsrPerm              = RndCnstLfsrPermDefault,
     parameter int unsigned                 DmBaseAddr                   = 32'h1A110000,
     parameter int unsigned                 DmAddrMask                   = 32'h00000FFF,
     parameter int unsigned                 DmHaltAddr                   = 32'h1A110800,
     parameter int unsigned                 DmExceptionAddr              = 32'h1A110808,
     /* Default seed and nonce for scrambling */
     parameter logic [SCRAMBLE_KEY_W-1:0]   RndCnstIbexKey               = RndCnstIbexKeyDefault,
     parameter logic [SCRAMBLE_NONCE_W-1:0] RndCnstIbexNonce             = RndCnstIbexNonceDefault)
   (input  logic                         clk,          // Clock signal
    input  logic                         rst_n,        // Active-low asynchronous reset
    wb_if.master                         instr_wb,     // Wishbone interface for instruction memory
    wb_if.master                         data_wb,      // Wishbone interface for data memory

    input  logic                         test_en,      // Test input, enables clock
    input  prim_ram_1p_pkg::ram_1p_cfg_t ram_cfg,

    input  logic [31:0]                  hart_id,      // Hart ID, usually static, can be read from Hardware Thread ID (mhartid) CSR
    input  logic [31:0]                  boot_addr,    // First program counter after reset = boot_addr + 0x80

    /* Interrupt inputs */
    input  logic                         irq_software, // Connected to memory-mapped (inter-processor) interrupt register
    input  logic                         irq_timer,    // Connected to timer module
    input  logic                         irq_external, // Connected to platform-level interrupt controller
    input  logic [14:0]                  irq_fast,     // 15 fast, local interrupts
    input  logic                         irq_nm,       // Non-maskable interrupt (NMI)

    /* Scrambling Interface */
    input  logic                         scramble_key_valid,
    input  logic [SCRAMBLE_KEY_W-1:0]    scramble_key,
    input  logic [SCRAMBLE_NONCE_W-1:0]  scramble_nonce,
    output logic                         scramble_req,

    /* Debug Interface */
    input  logic                         debug_req,
    output crash_dump_t                  crash_dump,
    output logic                         double_fault_seen,

    /* RISC-V Formal Interface */
`ifdef RVFI
    output logic                         rvfi_valid,
    output logic [63:0]                  rvfi_order,
    output logic [31:0]                  rvfi_insn,
    output logic                         rvfi_trap,
    output logic                         rvfi_halt,
    output logic                         rvfi_intr,
    output logic [ 1:0]                  rvfi_mode,
    output logic [ 1:0]                  rvfi_ixl,
    output logic [ 4:0]                  rvfi_rs1_addr,
    output logic [ 4:0]                  rvfi_rs2_addr,
    output logic [ 4:0]                  rvfi_rs3_addr,
    output logic [31:0]                  rvfi_rs1_rdata,
    output logic [31:0]                  rvfi_rs2_rdata,
    output logic [31:0]                  rvfi_rs3_rdata,
    output logic [ 4:0]                  rvfi_rd_addr,
    output logic [31:0]                  rvfi_rd_wdata,
    output logic [31:0]                  rvfi_pc_rdata,
    output logic [31:0]                  rvfi_pc_wdata,
    output logic [31:0]                  rvfi_mem_addr,
    output logic [ 3:0]                  rvfi_mem_rmask,
    output logic [ 3:0]                  rvfi_mem_wmask,
    output logic [31:0]                  rvfi_mem_rdata,
    output logic [31:0]                  rvfi_mem_wdata,
    output logic [31:0]                  rvfi_ext_pre_mip,
    output logic [31:0]                  rvfi_ext_post_mip,
    output logic                         rvfi_ext_nmi,
    output logic                         rvfi_ext_nmi_int,
    output logic                         rvfi_ext_debug_req,
    output logic                         rvfi_ext_debug_mode,
    output logic                         rvfi_ext_rf_wr_suppress,
    output logic [63:0]                  rvfi_ext_mcycle,
    output logic [31:0]                  rvfi_ext_mhpmcounters [10],
    output logic [31:0]                  rvfi_ext_mhpmcountersh [10],
    output logic                         rvfi_ext_ic_scr_key_valid,
    output logic                         rvfi_ext_irq_valid,
`endif

    /* CPU Control Signals */
    input  ibex_mubi_t                   fetch_enable,
    output logic                         alert_minor,
    output logic                         alert_major_internal,
    output logic                         alert_major_bus,
    output logic                         core_sleep,

    /* DFT bypass controls */
    input logic                          scan_rst_n);

   core_if instr_core (.rst_n, .clk);
   core_if data_core  (.rst_n, .clk);

`ifdef USE_TRACER
   ibex_top_tracing
`else
     ibex_top
`endif
       #(.PMPEnable                    (PMPEnable),
         .PMPGranularity               (PMPGranularity),
         .PMPNumRegions                (PMPNumRegions),
         .MHPMCounterNum               (MHPMCounterNum),
         .MHPMCounterWidth             (MHPMCounterWidth),
`ifndef USE_TRACER
         .PMPRstCfg                    (PMPRstCfg),
         .PMPRstAddr                   (PMPRstAddr),
         .PMPRstMsecCfg                (PMPRstMsecCfg),
`endif
         .RV32E                        (RV32E),
         .RV32M                        (RV32M),
         .RV32B                        (RV32B),
         .RegFile                      (RegFile),
         .BranchTargetALU              (BranchTargetALU),
         .WritebackStage               (WritebackStage),
         .ICache                       (ICache),
         .ICacheECC                    (ICacheECC),
         .BranchPredictor              (BranchPredictor),
         .DbgTriggerEn                 (DbgTriggerEn),
         .DbgHwBreakNum                (DbgHwBreakNum),
         .SecureIbex                   (SecureIbex),
         .ICacheScramble               (ICacheScramble),
`ifndef USE_TRACER
         .ICacheScrNumPrinceRoundsHalf (ICacheScrNumPrinceRoundsHalf),
`endif
         .RndCnstLfsrSeed              (RndCnstLfsrSeed),
         .RndCnstLfsrPerm              (RndCnstLfsrPerm),
         .DmBaseAddr                   (DmBaseAddr),
         .DmAddrMask                   (DmAddrMask),
         .DmHaltAddr                   (DmHaltAddr),
         .DmExceptionAddr              (DmExceptionAddr))
   inst_ibex_top
     (.clk_i                  (clk),
      .rst_ni                 (rst_n),

      .test_en_i              (test_en),
      .ram_cfg_i              (ram_cfg),

      .hart_id_i              (hart_id),
      .boot_addr_i            (boot_addr),

      .instr_req_o            (instr_core.req),    // Request valid, must stay high until instr_gnt is high for one cycle
      .instr_gnt_i            (instr_core.gnt),    // The other side accepted the request. instr_req may be deasserted in the next cycle.
      .instr_rvalid_i         (instr_core.rvalid), // instr_rdata holds valid data when instr_rvalid is high. This signal will be high for exactly one cycle per request.
      .instr_addr_o           (instr_core.addr),   // Address, word aligned
      .instr_rdata_i          (instr_core.rdata),  // Data read from memory
      .instr_rdata_intg_i     ('0),
      .instr_err_i            (instr_core.err),    // Error response from the bus or the memory: request cannot be handled. High in case of an error.

      .data_req_o             (data_core.req),     // Request valid, must stay high until data_gnt is high for one cycle
      .data_gnt_i             (data_core.gnt),     // The other side accepted the request. data_req may be deasserted in the next cycle.
      .data_rvalid_i          (data_core.rvalid),  // data_rdata holds valid data when data_rvalid is high.
      .data_we_o              (data_core.we),      // Write Enable, high for writes, low for reads. Sent together with data_req
      .data_be_o              (data_core.be),      // Byte Enable. Is set for the bytes to write/read, sent together with data_req
      .data_addr_o            (data_core.addr),    // Address, word aligned
      .data_wdata_o           (data_core.wdata),   // Data to be written to memory, sent together with data_req
      .data_wdata_intg_o      (),
      .data_rdata_i           (data_core.rdata),   // Data read from memory
      .data_rdata_intg_i      ('0),
      .data_err_i             (data_core.err),     // Error response from the bus or the memory: request cannot be handled. High in case of an error.

      .irq_software_i         (irq_software),
      .irq_timer_i            (irq_timer),
      .irq_external_i         (irq_external),
      .irq_fast_i             (irq_fast),
      .irq_nm_i               (irq_nm),

      .scramble_key_valid_i   (scramble_key_valid),
      .scramble_key_i         (scramble_key),
      .scramble_nonce_i       (scramble_nonce),
      .scramble_req_o         (scramble_req),

      .debug_req_i            (debug_req),
      .crash_dump_o           (crash_dump),
      .double_fault_seen_o    (double_fault_seen),

      .fetch_enable_i         (fetch_enable),
      .alert_minor_o          (alert_minor),
      .alert_major_internal_o (alert_major_internal),
      .alert_major_bus_o      (alert_major_bus),
      .core_sleep_o           (core_sleep)
`ifndef USE_TRACER
      , .scan_rst_ni          (scan_rst_n)
`endif
);

   /* Wishbone */
   assign
     instr_core.we    = 1'b0,
     instr_core.be    = '0,
     instr_core.wdata = '0;

   core2wb instr_core2wb
     (.core (instr_core),
      .wb   (instr_wb));

   core2wb data_core2wb
     (.core (data_core),
      .wb   (data_wb));
endmodule
