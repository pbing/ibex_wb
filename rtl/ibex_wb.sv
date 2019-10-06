/* RISC-V Ibex core with Wishbone B4 interface */

`default_nettype none

module ibex_wb
  #(parameter bit          PMPEnable        = 0,            // Enable PMP support
    parameter int unsigned PMPGranularity   = 0,            // Minimum granularity of PMP address matching
    parameter int unsigned PMPNumRegions    = 4,            // Number implemented PMP regions (ignored if PMPEnable == 0)
    parameter int unsigned MHPMCounterNum   = 0,            // Number of performance monitor event counters
    parameter int unsigned MHPMCounterWidth = 40,           // Bit width of performance monitor event counters
    parameter bit          RV32E            = 0,            // RV32E mode enable (16 integer registers only)
    parameter bit          RV32M            = 1,            // M(ultiply) extension enable
    parameter int unsigned DmHaltAddr       = 32'h1A110800, // Address to jump to when entering debug mode
    parameter int unsigned DmExceptionAddr  = 32'h1A110808) // Address to jump to when an exception occurs while in debug mode
   (wb_if.master        instr_wb,     // Wishbone interface for instruction memory
    wb_if.master        data_wb,      // Wishbone interface for data memory

    input  logic        test_en,      // Test input, enables clock

    input  logic [31:0] hart_id,      // Hart ID, usually static, can be read from Hardware Thread ID (mhartid) CSR
    input  logic [31:0] boot_addr,    // First program counter after reset = boot_addr + 0x80

    input  logic        irq_software, // Connected to memory-mapped (inter-processor) interrupt register
    input  logic        irq_timer,    // Connected to timer module
    input  logic        irq_external, // Connected to platform-level interrupt controller
    input  logic [14:0] irq_fast,     // 15 fast, local interrupts
    input  logic        irq_nm,       // Non-maskable interrupt (NMI)

    input  logic        debug_req,    // Request to enter debug mode 

    input  logic        fetch_enable, // Enable the core, won’t fetch when 0
    output logic        core_sleep);  // Core in WFI with no outstanding data or instruction accesses.

   logic       clk;          // Clock signal
   logic       rst_n;        // Active-low asynchronous reset

   wire        instr_req;    // Request valid, must stay high until instr_gnt is high for one cycle
   wire        instr_gnt;    // The other side accepted the request. instr_req may be deasserted in the next cycle.
   wire        instr_rvalid; // instr_rdata holds valid data when instr_rvalid is high. This signal will be high for exactly one cycle per request.
   wire [31:0] instr_addr;   // Address, word aligned
   wire [31:0] instr_rdata;  // Data read from memory
   wire        instr_err;    // Error response from the bus or the memory: request cannot be handled. High in case of an error.

   wire        data_req;     // Request valid, must stay high until data_gnt is high for one cycle
   wire        data_gnt;     // The other side accepted the request. data_req may be deasserted in the next cycle.
   wire        data_rvalid;  // data_rdata holds valid data when data_rvalid is high.
   wire        data_we;      // Write Enable, high for writes, low for reads. Sent together with data_req
   wire [3:0]  data_be;      // Byte Enable. Is set for the bytes to write/read, sent together with data_req
   wire [31:0] data_addr;    // Address, word aligned
   wire [31:0] data_wdata;   // Data to be written to memory, sent together with data_req
   wire [31:0] data_rdata;   // Data read from memory
   wire        data_err;     // Error response from the bus or the memory: request cannot be handled. High in case of an error.

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

      .instr_req_o    (instr_req),
      .instr_gnt_i    (instr_gnt),
      .instr_rvalid_i (instr_rvalid),
      .instr_addr_o   (instr_addr),
      .instr_rdata_i  (instr_rdata),
      .instr_err_i    (instr_err),

      .data_req_o     (data_req),
      .data_gnt_i     (data_gnt),
      .data_rvalid_i  (data_rvalid),
      .data_we_o      (data_we),
      .data_be_o      (data_be),
      .data_addr_o    (data_addr),
      .data_wdata_o   (data_wdata),
      .data_rdata_i   (data_rdata),
      .data_err_i     (data_err),

      .irq_software_i (irq_software),
      .irq_timer_i    (irq_timer),
      .irq_external_i (irq_external),
      .irq_fast_i     (irq_fast),
      .irq_nm_i       (irq_nm),

      .debug_req_i    (debug_req),

      .fetch_enable_i (fetch_enable),
      .core_sleep_o   (core_sleep));

   /* Wishbone */
   assign clk   =  instr_wb.clk;
   assign rst_n = ~instr_wb.rst;

   protocol_converter instr_protocol_converter
     (.req    (instr_req),
      .gnt    (instr_gnt),
      .rvalid (instr_rvalid),
      .we     (1'b0),
      .be     (4'b1111),
      .addr   (instr_addr),
      .wdata  (32'h0),
      .rdata  (instr_rdata),
      .err    (instr_err),
      .wb     (instr_wb));

   protocol_converter data_protocol_converter
     (.req    (data_req),
      .gnt    (data_gnt),
      .rvalid (data_rvalid),
      .we     (data_we),
      .be     (data_be),
      .addr   (data_addr),
      .wdata  (data_wdata),
      .rdata  (data_rdata),
      .err    (data_err),
      .wb     (data_wb));
endmodule

`resetall
