/* Ibex SOC example for simulation purposes */

`default_nettype none

module ibex_soc_example
  (input  wire clk,     // clock
   input  wire rst_n,   // reset (active low)

   input  wire trst_n,  // JTAG test reset (low active)
   input  wire tck,     // JTAG test clock
   input  wire tms,     // JTAG test mode select
   input  wire tdi,     // JTAG test data input
   output wire tdo,     // JTAG test data output
   output wire tdo_oe,  // JTAG test data output enable

   output wire led);    // LED

   localparam ram_base_addr = 'h00000000;
   localparam ram_size      = 'h10000;

   localparam led_base_addr = 'h10000000;
   localparam led_size      = 'h1000;

   localparam dm_base_addr  = 'h1A110000;
   localparam dm_size       = 'h1000;

   logic          rst;
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

   assign rst = ~rst_n;

   wb_if wbm[3](.*);
   wb_if wbs[3](.*);

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
      .dmi_rst_n (rst_n),
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

   wb_led wb_led(.wb(wbs[2]), .*);

`ifdef ASSERT_ON
   wb_checker wbm0_checker(wbm[0]);
   wb_checker wbm1_checker(wbm[1]);
   wb_checker wbm2_checker(wbm[2]);
   wb_checker wbs0_checker(wbs[0]);
   wb_checker wbs1_checker(wbs[1]);
   wb_checker wbs2_checker(wbs[2]);
`endif
endmodule

`resetall
