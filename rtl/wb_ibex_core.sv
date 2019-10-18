/* RISC-V Ibex core with Wishbone B4 interface */

`default_nettype none

module wb_ibex_core
  #(parameter bit          PMPEnable        = 0,            // Enable PMP support
    parameter int unsigned PMPGranularity   = 0,            // Minimum granularity of PMP address matching
    parameter int unsigned PMPNumRegions    = 4,            // Number implemented PMP regions (ignored if PMPEnable == 0)
    parameter int unsigned MHPMCounterNum   = 0,            // Number of performance monitor event counters
    parameter int unsigned MHPMCounterWidth = 40,           // Bit width of performance monitor event counters
    parameter bit          RV32E            = 0,            // RV32E mode enable (16 integer registers only)
    parameter bit          RV32M            = 1,            // M(ultiply) extension enable
    parameter int unsigned DmHaltAddr       = 32'h1A110800, // Address to jump to when entering debug mode
    parameter int unsigned DmExceptionAddr  = 32'h1A110808) // Address to jump to when an exception occurs while in debug mode
   (input  wire         clk,                                // Clock signal
    input  wire         rst_n,                              // Active-low asynchronous reset
    wb_if.master        instr_wb,                           // Wishbone interface for instruction memory
    wb_if.master        data_wb,                            // Wishbone interface for data memory

    input  wire         test_en,                            // Test input, enables clock

    input  wire  [31:0] hart_id,                            // Hart ID, usually static, can be read from Hardware Thread ID (mhartid) CSR
    input  wire  [31:0] boot_addr,                          // First program counter after reset = boot_addr + 0x80

    input  wire         irq_software,                       // Connected to memory-mapped (inter-processor) interrupt register
    input  wire         irq_timer,                          // Connected to timer module
    input  wire         irq_external,                       // Connected to platform-level interrupt controller
    input  wire  [14:0] irq_fast,                           // 15 fast, local interrupts
    input  wire         irq_nm,                             // Non-maskable interrupt (NMI)

    input  wire         debug_req,                          // Request to enter debug mode

    input  wire         fetch_enable,                       // Enable the core, won't fetch when 0
    output logic        core_sleep);                        // Core in WFI with no outstanding data or instruction accesses.

   core_if instr_core(.*);
   core_if data_core(.*);

`ifdef USE_TRACER
   ibex_core_tracing
`else
     ibex_core
`endif
       #(.PMPEnable        (PMPEnable),
         .PMPGranularity   (PMPGranularity),
         .PMPNumRegions    (PMPNumRegions),
         .MHPMCounterNum   (MHPMCounterNum),
         .MHPMCounterWidth (MHPMCounterWidth),
         .RV32E            (RV32E),
         .RV32M            (RV32M),
         .DmHaltAddr       (DmHaltAddr),
         .DmExceptionAddr  (DmExceptionAddr))
   inst_ibex_core
     (.clk_i          (clk),
      .rst_ni         (rst_n),

      .test_en_i      (test_en),
      .hart_id_i      (hart_id),
      .boot_addr_i    (boot_addr),

      .instr_req_o    (instr_core.req),    // Request valid, must stay high until instr_gnt is high for one cycle
      .instr_gnt_i    (instr_core.gnt),    // The other side accepted the request. instr_req may be deasserted in the next cycle.
      .instr_rvalid_i (instr_core.rvalid), // instr_rdata holds valid data when instr_rvalid is high. This signal will be high for exactly one cycle per request.
      .instr_addr_o   (instr_core.addr),   // Address, word aligned
      .instr_rdata_i  (instr_core.rdata),  // Data read from memory
      .instr_err_i    (instr_core.err),    // Error response from the bus or the memory: request cannot be handled. High in case of an error.

      .data_req_o     (data_core.req),     // Request valid, must stay high until data_gnt is high for one cycle
      .data_gnt_i     (data_core.gnt),     // The other side accepted the request. data_req may be deasserted in the next cycle.
      .data_rvalid_i  (data_core.rvalid),  // data_rdata holds valid data when data_rvalid is high.
      .data_we_o      (data_core.we),      // Write Enable, high for writes, low for reads. Sent together with data_req
      .data_be_o      (data_core.be),      // Byte Enable. Is set for the bytes to write/read, sent together with data_req
      .data_addr_o    (data_core.addr),    // Address, word aligned
      .data_wdata_o   (data_core.wdata),   // Data to be written to memory, sent together with data_req
      .data_rdata_i   (data_core.rdata),   // Data read from memory
      .data_err_i     (data_core.err),     // Error response from the bus or the memory: request cannot be handled. High in case of an error.

      .irq_software_i (irq_software),
      .irq_timer_i    (irq_timer),
      .irq_external_i (irq_external),
      .irq_fast_i     (irq_fast),
      .irq_nm_i       (irq_nm),

      .debug_req_i    (debug_req),

      .fetch_enable_i (fetch_enable),
      .core_sleep_o   (core_sleep));

   /* Wishbone */
   assign instr_core.we    = 1'b0;
   assign instr_core.be    = '0;
   assign instr_core.wdata = '0;

   core2wb instr_core2wb
     (.core (instr_core),
      .wb   (instr_wb));

   core2wb data_core2wb
     (.core (data_core),
      .wb   (data_wb));
endmodule

`resetall
