/* Testbench */

`default_nettype none

module tb;
   timeunit 1ns / 1ps;

   const realtime tclk = 1s / 100.0e6; // System clock period
   const realtime ttck = 1s / 10.0e6;  // JTAG clock period

   localparam dm_base_addr  = 'h1A110000;

   typedef enum logic [4:0] {BYPASS0   = 'h0,
                             IDCODE    = 'h1,
                             DTMCSR    = 'h10,
                             DMIACCESS = 'h11,
                             BYPASS1   = 'h1f} ir_t;

   typedef struct packed {
      logic [31:18] zero1;
      logic         dmihardreset;
      logic         dmireset;
      logic         zero0;
      logic [14:12] idle;
      logic [11:10] dmistat;
      logic [9:4]   abits;
      logic [3:0]   version;
   } dtmcs_t;

   typedef struct packed {
      logic [6:0]  addr;
      logic [31:0] data;
      dm::dtm_op_e op;
   } dmi_req_t;

   typedef struct packed  {
      logic [6:0]  addr;
      logic [31:0] data;
      logic [1:0]  resp;
   } dmi_resp_t;

   bit        clk100mhz;
   bit  [3:0] sw;
   wire [3:0] led;
   bit  [3:0] btn;
   bit        ck_rst_n;
   bit        tck;
   bit        trst_n;
   bit        tms;
   bit        tdi;
   wire       tdo;

   logic [4:0]      ir_resp    = 5'h0;
   logic [31:0]     idcode     = 32'h0;
   dtmcs_t          dtmcs      = '0;
   dmi_req_t        dmi_req    = '0;
   dmi_resp_t       dmi_resp   = '0;
   dm::dmstatus_t   dmstatus   = '0;
   dm::hartinfo_t   hartinfo   = '0;
   dm::abstractcs_t abstractcs = '0;
   dm::dmcontrol_t  dmcontrol  = '0;
   logic [31:0]     data0      = '0;
   logic [31:0]     sbdata0    = '0;

`include "tasks.svh"

   glbl glbl();
   ibex_soc dut(.*);

   always #(tclk / 2) clk100mhz = ~clk100mhz;

   always #(ttck / 2) tck = ~tck;

`ifdef ASSERT_ON
   bind dut wb_checker wbm0_checker(wbm[0]);
   bind dut wb_checker wbm1_checker(wbm[1]);
   bind dut wb_checker wbs0_checker(wbs[0]);
   bind dut wb_checker wbs1_checker(wbs[1]);
`endif

   initial
     begin:main
        string filename;
        int    status;

        $timeformat(-9, 3, " ns");

        status = $value$plusargs("filename=%s", filename);
        chk_filename: assert (status) else $fatal(1, "No memory file provided. Please use './simv '+filename=<file.vmem>");
        $readmemh(filename, tb.dut.wb_spram.spram.mem);

        repeat (3) @(negedge clk100mhz);
        ck_rst_n = 1'b1;

        repeat (3) @(negedge tck);
        trst_n = 1'b1;

        /* JTAG IDCODE */
        jtag_test_logic_reset();
        jtag_run_test_idle();
        jtag_dr_idcode('0, idcode);
        chk_idcode: assert (idcode == 32'h00000001);

        /* read DTM Control and Status */
        jtag_ir(DTMCSR, ir_resp);
        jtag_dr_dtmcs('0, dtmcs);
        chk_dtmcs_idle    : assert (dtmcs.idle    == 3'd1); // Enter Run-Test/Idle and leave it immediately.
        chk_dtmcs_dmistat : assert (dtmcs.dmistat == 2'd0); // No error.
        chk_dtmcs_abits   : assert (dtmcs.abits   == 6'd7); // The size of address in dmi.
        chk_dtmcs_version : assert (dtmcs.version == 4'd1); // Version described in spec version 0.13.

        /* access DMI */
        jtag_ir(DMIACCESS, ir_resp);

        /* read dmstatus */
        $display("%t DMI read dmstatus", $realtime);
        dmi_req.addr = dm::DMStatus;
        dmi_req.op   = dm::DTM_READ;
        dmi_req.data = 32'h0;
        jtag_dr_dmi(dmi_req, dmi_resp);

        /* read hartinfo */
        $display("%t DMI read hartinfo", $realtime);
        dmi_req.addr = dm::Hartinfo;
        dmi_req.op   = dm::DTM_READ;
        dmi_req.data = 32'h0;
        jtag_dr_dmi(dmi_req, dmi_resp);

        /* check dmstatus */
        $display("%t DMI check dmstatus", $realtime);
        dmstatus = dmi_resp.data;
        chk_dmstatus_authenticated   : assert (dmstatus.authenticated   == 1'b1);
        chk_dmstatus_authbusy        : assert (dmstatus.authbusy        == 1'b0);
        chk_dmstatus_hasresethaltreq : assert (dmstatus.hasresethaltreq == 1'b0);
        chk_dmstatus_confstrptrvalid : assert (dmstatus.devtreevalid    == 1'b0);
        chk_dmstatus_version         : assert (dmstatus.version         == dm::DbgVersion013);

        /* read abstractcs */
        $display("%t DMI read abstractcs", $realtime);
        dmi_req.addr = dm::AbstractCS;
        dmi_req.op   = dm::DTM_READ;
        dmi_req.data = 32'h0;
        jtag_dr_dmi(dmi_req, dmi_resp);

        /* check hartinfo */
        $display("%t DMI check hartinfo", $realtime);
        hartinfo = dmi_resp.data;
        chk_hartinfo_nscratch   : assert (hartinfo.nscratch   == 4'd2);
        chk_hartinfo_dataaccess : assert (hartinfo.dataaccess == 1'b1);
        chk_hartinfo_datasize   : assert (hartinfo.datasize   == dm::DataCount);
        chk_hartinfo_dataaddr   : assert (hartinfo.dataaddr   == dm::DataAddr);

        /* write dmcontrol */
        $display("%t DMI write dmcontrol", $realtime);
        dmcontrol.dmactive  = 1'b1;
        dmi_req.addr        = dm::DMControl;
        dmi_req.op          = dm::DTM_WRITE;
        dmi_req.data        = dmcontrol;
        jtag_dr_dmi(dmi_req, dmi_resp);

        /* check abstractcs */
        $display("%t DMI check abstractcs", $realtime);
        abstractcs = dmi_resp.data;
        chk_abstractcs_progbufsize : assert (abstractcs.progbufsize == 5'd8);
        chk_abstractcs_busy        : assert (abstractcs.busy        == 1'b0);
        chk_abstractcs_cmderr      : assert (abstractcs.cmderr      == dm::CmdErrNone);
        chk_abstractcs_datacount   : assert (abstractcs.datacount   == dm::DataCount);

        /* after dmcontrol.dmactive=1 we can halt the hart */
        $display("%t DMI write dmcontrol", $realtime);
        dmcontrol.haltreq = 1'b1;
        dmi_req.addr      = dm::DMControl;
        dmi_req.op        = dm::DTM_WRITE;
        dmi_req.data      = dmcontrol;
        jtag_dr_dmi(dmi_req, dmi_resp);

        /* read dmcontrol */
        $display("%t DMI read dmcontrol", $realtime);
        dmi_req.addr = dm::DMControl;
        dmi_req.op   = dm::DTM_READ;
        dmi_req.data = '0;
        jtag_dr_dmi(dmi_req, dmi_resp);
        chk_debug_req: assert (tb.dut.wb_ibex_core.debug_req == 1'b1);
        $display("%t Hart is halted", $realtime);

        /* check dmcontrol */
        $display("%t DMI check dmcontrol", $realtime);
        dmcontrol = dmi_resp.data;
        chk_dmcontrol_1: assert (dmcontrol.dmactive == 1'b1);
        chk_dmcontrol_2: assert (dmcontrol.haltreq == 1'b1);

        /* read register x13 with abstract command */
        $display("%t AC read register", $realtime);
        ac_read_register(16'h100d, data0);
        chk_data0_1: assert (data0 == 32'd55); // result of fib(10)

        /* write to address 0x3000 */
        $display("%t SB write memory", $realtime);
        sb_write_memory32(32'h3000, 32'h12345678);

        /* read from address 0x3000 */
        $display("%t SB read memory", $realtime);
        sb_read_memory32(32'h3000, sbdata0);
        chk_sbdata0_1: assert (sbdata0 == 32'h12345678);

        #100ns $finish;
     end:main
endmodule

`resetall
