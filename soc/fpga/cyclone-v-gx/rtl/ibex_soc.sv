/* SoC Toplevel */

//`define ENABLE_DDR2LP
//`define ENABLE_HSMC_XCVR
//`define ENABLE_SMA
//`define ENABLE_REFCLK
`define ENABLE_GPIO

module ibex_soc
  (/* ADC 1.2 V */
   output wire        ADC_CONVST,
   output wire        ADC_SCK,
   output wire        ADC_SDI,
   input  wire        ADC_SDO,

   /* AUD 2.5 V */
   input  wire        AUD_ADCDAT,
   inout  wire        AUD_ADCLRCK,
   inout  wire        AUD_BCLK,
   output wire        AUD_DACDAT,
   inout  wire        AUD_DACLRCK,
   output wire        AUD_XCK,

   /* CLOCK  */
   input  wire        CLOCK_125_p,    // LVDS
   input  wire        CLOCK_50_B5B,   // 3.3-V LVTTL
   input  wire        CLOCK_50_B6A,
   input  wire        CLOCK_50_B7A,   // 2.5 V
   input  wire        CLOCK_50_B8A,

   /* CPU  */
   input  wire        CPU_RESET_n,    // 3.3V LVTTL

`ifdef ENABLE_DDR2LP
   /* DDR2LP 1.2-V HSUL */
   output wire [9:0]  DDR2LP_CA,
   output wire [1:0]  DDR2LP_CKE,
   output wire        DDR2LP_CK_n,    // DIFFERENTIAL 1.2-V HSUL
   output wire        DDR2LP_CK_p,    // DIFFERENTIAL 1.2-V HSUL
   output wire [1:0]  DDR2LP_CS_n,
   output wire [3:0]  DDR2LP_DM,
   inout  wire [31:0] DDR2LP_DQ,
   inout  wire [3:0]  DDR2LP_DQS_n,   // DIFFERENTIAL 1.2-V HSUL
   inout  wire [3:0]  DDR2LP_DQS_p,   // DIFFERENTIAL 1.2-V HSUL
   input  wire        DDR2LP_OCT_RZQ, // 1.2 V
`endif /*ENABLE_DDR2LP*/

`ifdef ENABLE_GPIO
   /* GPIO 3.3-V LVTTL */
   inout  wire [35:0] GPIO,
`else	
   /* HEX 1.2 V */
   output wire [6:0]  HEX2,
   output wire [6:0]  HEX3,		
`endif /*ENABLE_GPIO*/

   /* HDMI  */
   output wire        HDMI_TX_CLK,
   output wire [23:0] HDMI_TX_D,
   output wire        HDMI_TX_DE,
   output wire        HDMI_TX_HS,
   input  wire        HDMI_TX_INT,
   output wire        HDMI_TX_VS,

   /* HEX */
   output wire [6:0]  HEX0,
   output wire [6:0]  HEX1,

   /* HSMC 2.5 V */
   input  wire        HSMC_CLKIN0,
   input  wire [2:1]  HSMC_CLKIN_n,
   input  wire [2:1]  HSMC_CLKIN_p,
   output wire        HSMC_CLKOUT0,
   output wire [2:1]  HSMC_CLKOUT_n,
   output wire [2:1]  HSMC_CLKOUT_p,
   inout  wire [3:0]  HSMC_D,
`ifdef ENABLE_HSMC_XCVR		
   input  wire [3:0]  HSMC_GXB_RX_p,  //  1.5-V PCML
   output wire [3:0]  HSMC_GXB_TX_p,  //  1.5-V PCML
`endif /*ENABLE_HSMC_XCVR*/		
   inout  wire [16:0] HSMC_RX_n,
   inout  wire [16:0] HSMC_RX_p,
   inout  wire [16:0] HSMC_TX_n,
   inout  wire [16:0] HSMC_TX_p,


   /* I2C 2.5 V */
   output wire        I2C_SCL,
   inout  wire        I2C_SDA,

   /* KEY 1.2 V */
   input  wire [3:0]  KEY,

   /* LEDG 2.5 V */
   output wire [7:0]  LEDG,

   /* LEDR 2.5 V */
   output wire [9:0]  LEDR,

`ifdef ENABLE_REFCLK
   /* REFCLK 1.5-V PCML */
   input  wire        REFCLK_p0,
   input  wire        REFCLK_p1,
`endif /*ENABLE_REFCLK*/

   /* SD 3.3-V LVTTL */
   output wire        SD_CLK,
   inout  wire        SD_CMD,
   inout  wire [3:0]  SD_DAT,

`ifdef ENABLE_SMA
   /* SMA 1.5-V PCML */
   input  wire        SMA_GXB_RX_p,
   output wire        SMA_GXB_TX_p,
`endif /*ENABLE_SMA*/

   /* SRAM 3.3-V LVTTL */
   output wire [17:0] SRAM_A,
   output wire        SRAM_CE_n,
   inout  wire [15:0] SRAM_D,
   output wire        SRAM_LB_n,
   output wire        SRAM_OE_n,
   output wire        SRAM_UB_n,
   output wire        SRAM_WE_n,

   /* SW 1.2 V */
   input  wire [9:0]  SW,

   /* UART 2.5 V */
   input  wire        UART_RX,
   output wire        UART_TX);

   import ibex_pkg::*;
   
   localparam [31:0] ram_base_addr = 32'h00000000;
   localparam [31:0] ram_size      = 32'h10000;

   localparam [31:0] led_base_addr = 32'h10000000;
   localparam [31:0] led_size      = 32'h1000;

   localparam [31:0] dm_base_addr  = 32'h1A110000;
   localparam [31:0] dm_size       = 32'h1000;

   logic          clk;
   logic          rst, rst_n;

   logic          debug_req;
   dm::hartinfo_t hartinfo = '{zero1: 0,
                               nscratch: 2,   // Debug module needs at least two scratch regs
                               zero0: 0,
                               dataaccess: 1, // data registers are memory mapped in the debugger
                               datasize: dm::DataCount,
                               dataaddr: dm::DataAddr};

   logic          dmi_rst_n;
   logic          dmi_req_valid;
   logic          dmi_req_ready;
   dm::dmi_req_t  dmi_req;

   logic          dmi_resp_valid;
   logic          dmi_resp_ready;
   dm::dmi_resp_t dmi_resp;

   logic          tck;
   logic          trst_n;
   logic          tms;
   logic          tdi;
   logic          tdo;
   logic          tdo_oe;

   assign rst      = ~rst_n;
   assign tck      = GPIO[2];
   assign trst_n   = GPIO[20] | 1'b1; // not connected
   assign tms      = GPIO[1];
   assign tdi      = GPIO[0];
   assign GPIO[19] = tdo_oe ? tdo : 1'bz;

   wb_if wbm[3] (.rst, .clk);
   wb_if wbs[3] (.rst, .clk);

   crg u_crg
     (.clk50m    (CLOCK_50_B5B),
      .ext_rst_n (CPU_RESET_n),
      .rst_n,
      .clk);

   wb_ibex_top
     #(.RegFile (RegFileFPGA))
   u_wb_ibex_top
     (.clk,
      .rst_n,
      .instr_wb             (wbm[2]),
      .data_wb              (wbm[1]),

      .test_en              (1'b0),
      .ram_cfg              ('0),

      .hart_id              (32'h00000000),
      .boot_addr            (32'h00000000),

      .irq_software         (1'b0),
      .irq_timer            (1'b0),
      .irq_external         (1'b0),
      .irq_fast             (15'h0000),
      .irq_nm               (1'b0),

      .scramble_key_valid   (1'b0),
      .scramble_key         ('0),
      .scramble_nonce       ('0),
      .scramble_req         (),

      .debug_req,
      .crash_dump           (),
      .double_fault_seen    (),

      .fetch_enable         ('1),
      .alert_minor          (),
      .alert_major_internal (),
      .alert_major_bus      (),
      .core_sleep           (),
      
      .scan_rst_n           (1'b0));

   wb_dm_top u_wb_dm_top
     (.clk,
      .rst_n,

      .next_dm_addr (32'h00000000),
      .testmode     (1'b0),
      .ndmreset     (),
      .ndmreset_ack (1'b0),
      .dmactive     (),
      .debug_req,
      .unavailable  ('0),
      .hartinfo,

      .wbs          (wbs[0]),
      .wbm          (wbm[0]),

      .dmi_rst_n,
      .dmi_req_valid,
      .dmi_req_ready,
      .dmi_req,

      .dmi_resp_valid,
      .dmi_resp_ready,
      .dmi_resp);

   dmi_jtag u_dmi_jtag
     (.clk_i            (clk),
      .rst_ni           (rst_n),
      .testmode_i       (1'b0),

      .dmi_rst_no       (dmi_rst_n),
      .dmi_req_o        (dmi_req),
      .dmi_req_valid_o  (dmi_req_valid),
      .dmi_req_ready_i  (dmi_req_ready),
      
      .dmi_resp_i       (dmi_resp),
      .dmi_resp_ready_o (dmi_resp_ready),
      .dmi_resp_valid_i (dmi_resp_valid),
      
      .tck_i            (tck),
      .tms_i            (tms),
      .trst_ni          (trst_n),
      .td_i             (tdi),
      .td_o             (tdo),
      .tdo_oe_o         (tdo_oe));

   //wb_interconnect_sharedbus
   wb_interconnect_xbar
     #(.numm      (3),
       .nums      (3),
       .base_addr ('{dm_base_addr, ram_base_addr, led_base_addr}),
       .size      ('{dm_size, ram_size, led_size}))
   u_wb_interconnect
     (.wbm, .wbs);

    wb_spram16384x32 u_wb_spram (.wb(wbs[1]));

   wb_led
     #(.N (4))
   u_wb_ledg
     (.wb  (wbs[2]),
      .led (LEDG[3:0]));
endmodule
