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
   (if_wb.master        wb,           // Wishbone interface

    output logic        instr_req,    // Request valid, must stay high until instr_gnt is high for one cycle
    input  logic        instr_gnt,    // The other side accepted the request. instr_req may be deasserted in the next cycle.
    input  logic        instr_rvalid, // instr_rdata holds valid data when instr_rvalid is high. This signal will be high for exactly one cycle per request.
    output logic [31:0] instr_addr,   // Address, word aligned
    input  logic [31:0] instr_rdata,  // Data read from memory
    input  logic        instr_err,    // Error response from the bus or the memory: request cannot be handled. High in case of an error.

    input  logic        test_en,      // Test input, enables clock

    input  logic [31:0] hart_id,      // Hart ID, usually static, can be read from Hardware Thread ID (mhartid) CSR
    input  logic [31:0] boot_addr,    // First program counter after reset = boot_addr + 0x80

                                      // Interrupt inputs
    input  logic        irq_software, // Connected to memory-mapped (inter-processor) interrupt register
    input  logic        irq_timer,    // Connected to timer module
    input  logic        irq_external, // Connected to platform-level interrupt controller
    input  logic [14:0] irq_fast,     // 15 fast, local interrupts
    input  logic        irq_nm,       // Non-maskable interrupt (NMI)

    input  logic        debug_req,    //Request to enter debug mode 

    input  logic        fetch_enable, // Enable the core, won’t fetch when 0
    output logic        core_sleep);  // Core in WFI with no outstanding data or instruction accesses.

   logic       clk;          // Clock signal
   logic       rst_n;        // Active-low asynchronous reset

   //   wire        instr_req;    // Request valid, must stay high until instr_gnt is high for one cycle
   //   wire        instr_gnt;    // The other side accepted the request. instr_req may be deasserted in the next cycle.
   //   wire        instr_rvalid; // instr_rdata holds valid data when instr_rvalid is high. This signal will be high for exactly one cycle per request.
   //   wire [31:0] instr_addr;   // Address, word aligned
   //   wire [31:0] instr_rdata;  // Data read from memory
   //   wire        instr_err;    // Error response from the bus or the memory: request cannot be handled. High in case of an error.

   wire        data_req;     // Request valid, must stay high until data_gnt is high for one cycle
   wire        data_gnt;     // The other side accepted the request. data_req may be deasserted in the next cycle.
   wire        data_rvalid;  // data_rdata holds valid data when data_rvalid is high.
   wire        data_we;      // Write Enable, high for writes, low for reads. Sent together with data_req
   wire [3:0]  data_be;      // Byte Enable. Is set for the bytes to write/read, sent together with data_req
   wire [31:0] data_addr;    // Address, word aligned
   wire [31:0] data_wdata;   // Data to be written to memory, sent together with data_req
   wire [31:0] data_rdata;   // Data read from memory
   wire        data_err;     // Error response from the bus or the memory: request cannot be handled. High in case of an error.

   ibex_core 
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
   logic data_req1;
   always_ff @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       data_req1 <= 1'b0;
     else
       data_req1 <= data_req;

   assign clk         =  wb.clk;
   assign rst_n       = ~wb.rst;
   assign data_gnt    = ~wb.stall;
   assign data_rvalid = wb.ack;
   assign data_err    = 1'b0;
   assign data_rdata  = wb.dat_i;
   assign wb.cyc      = data_req | data_req1;
   assign wb.stb      = data_req;
   assign wb.adr      = data_addr;
   assign wb.dat_o    = data_wdata;
   assign wb.we       = data_we;
   // FIXME wb.???    = wb.be;
endmodule

`resetall
