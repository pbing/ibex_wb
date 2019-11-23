`default_nettype none

module ibex_soc
  (input  wire       CLK100MHZ,

   input  wire  [3:0] sw,
   output logic [3:0] led,
   input  wire  [3:0] btn,

   input  wire        ck_rst_n,

   inout  wire        ck_io0,
   inout  wire        ck_io1,
   inout  wire        ck_io2,
   inout  wire        ck_io3,
   inout  wire        ck_io4,
   inout  wire        ck_io5,
   inout  wire        ck_io6,
   inout  wire        ck_io7,
   inout  wire        ck_io8,
   inout  wire        ck_io9,
   inout  wire        ck_io10,
   inout  wire        ck_io11,
   inout  wire        ck_io12,
   inout  wire        ck_io13,

   inout  wire  [7:0] jd);

   localparam ram_base_addr = 'h00000000;
   localparam ram_size      = 'h10000;

   localparam led_base_addr = 'h10000000;
   localparam led_size      = 'h1000;

   localparam dm_base_addr  = 'h1A110000;
   localparam dm_size       = 'h1000;

   logic          clk;
   logic          rst, rst_n;
   logic          core_sleep;
   logic          ndmreset;
   logic          dmactive;
   logic          debug_req;
   logic          unavailable = 1'b0;
   dm::hartinfo_t hartinfo = '{zero1: 0,
                               nscratch: 2,
                               zero0: 0,
                               dataaccess: 1,
                               datasize: dm::DataCount,
                               dataaddr: dm::DataAddr};
   logic          dmi_rst_n;
   logic          dmi_req_valid;
   logic          dmi_req_ready;
   dm::dmi_req_t  dmi_req;
   logic          dmi_resp_valid;
   logic          dmi_resp_ready;
   dm::dmi_resp_t dmi_resp;

   logic tck, trst_n, tms, tdi, tdo, tdo_oe;

   assign rst = rst_n;

   /* https://www.digikey.com/eewiki/display/LOGIC/Digilent+Arty+A7+with+Xilinx+Artix-7+Implementing+SiFive+FE310+RISC-V */
   assign jd[0]  = tdo_oe ? tdo : 1'bz;
   assign trst_n = jd[1];
   assign tck    = jd[2];
   assign tdi    = jd[4];
   assign tms    = jd[5];

   wb_if wbm[3](.*);
   wb_if wbs[3](.*);

   crg crg
     (.clk100m   (CLK100MHZ),
      .ext_rst_n (ck_rst_n),
      .rst_n,
      .clk);

   wb_ibex_core wb_ibex_core
     (.instr_wb     (wbm[1]),
      .data_wb      (wbm[2]),
      .test_en      (1'b0),
      .hart_id      (32'h0),
      .boot_addr    (32'h0),
      .irq_software (1'b0),
      .irq_timer    (1'b0),
      .irq_external (1'b0),
      .irq_fast     (15'b0),
      .irq_nm       (1'b0),
      .fetch_enable (1'b1),
      .*);

   wb_dm_top wb_dm
     (.testmode  (1'b0),
      .wbm       (wbm[0]),
      .wbs       (wbs[0]),
      .dmi_rst_n (dmi_rst_n),
      .*);

   dmi_jtag dmi
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

   wb_interconnect_sharedbus
     #(.numm      (3),
       .nums      (3),
       .base_addr ({dm_base_addr, ram_base_addr, led_base_addr}),
       .size      ({dm_size, ram_size, led_size}))
   wb_intercon
     (.*);

   wb_spramx32 #(ram_size) wb_spram(.wb(wbs[1]));

   wb_led wb_led
     (.wb(wbs[2]),
      .*);
endmodule

`resetall
