/* Testbench */

`default_nettype none

module tb;
   timeunit 1ns / 1ps;

   const realtime tclk = 1s / 100.0e6;

   parameter int                 NrHarts          = 1;
   parameter int                 BusWidth         = 32;
   parameter logic [NrHarts-1:0] SelectableHarts  = 1;

   localparam ram_base_addr = 'h00000000;
   localparam ram_size      = 'h10000;

   bit          clk;
   bit          rst = 1'b1;

   bit          test_en;
   bit  [31:0]  hart_id;
   bit  [31:0]  boot_addr;
   bit          irq_software;
   bit          irq_timer;
   bit          irq_external;
   bit  [14:0]  irq_fast;
   bit          irq_nm;
   bit          fetch_enable = 1'b1;
   wire         core_sleep;

   wire                         ndmreset;
   wire                         dmactive;
   wire [NrHarts-1:0]           debug_req;
   bit  [NrHarts-1:0]           unavailable;
   dm::hartinfo_t [NrHarts-1:0] hartinfo = dm::hartinfo_t'('0);
   bit                          dmi_req_valid;
   wire                         dmi_req_ready;
   dm::dmi_req_t                dmi_req = dm::dmi_req_t'('0);
   wire                         dmi_resp_valid;
   bit                          dmi_resp_ready;
   dm::dmi_resp_t               dmi_resp;

   wb_if wbm[3](.*);
   wb_if wbs[2](.*);

   wb_ibex_core dut
     (.rst_n     (~rst),
      .instr_wb  (wbm[1]),
      .data_wb   (wbm[2]),
      .debug_req (debug_req[0]),
      .*);

   wb_dm_top wb_dm
     (.rst_n     (~rst),
      .testmode  (test_en),
      .wbm       (wbm[0]),
      .wbs       (wbs[0]),
      .dmi_rst_n (~rst),
      .*);

   wb_interconnect_sharedbus
     #(.numm      (3),
       .nums      (2),
       .base_addr ({0, ram_base_addr}), // FIXME
       .size      ({0, ram_size}) ) // FIXME
   wb_intercon
     (.*);

   wb_spramx32 #(ram_size) wb_spram(.wb(wbs[1]));

   wb_checker wbm0_checker(wbm[0]);
   wb_checker wbm1_checker(wbm[1]);
   wb_checker wbm2_checker(wbm[2]);
   wb_checker wbs0_checker(wbs[0]);
   wb_checker wbs1_checker(wbs[1]);

   always #(tclk / 2) clk = ~clk;

   initial
     begin:main
        string filename;
        int    status;

        $timeformat(-9, 3, " ns");

        status = $value$plusargs("filename=%s", filename);
        assert(status) else $fatal("No memory file provided. Please use './simv '+filename=<file.vmem>");
        $readmemh(filename, tb.wb_spram.spram.mem);

        repeat (3) @(negedge clk);
        rst = 1'b0;

        repeat (350) @(negedge clk);
        $finish;
     end:main
endmodule

`resetall
