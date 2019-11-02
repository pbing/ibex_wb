/* Testbench */

`default_nettype none

module tb;
   timeunit 1ns / 1ps;

   const realtime tclk = 1s / 100.0e6; // CPU clock period
   const realtime ttck = 1s / 10.0e6;  // JTAG clock period

   localparam dm_base_addr  = 'h1A110000;

   bit  clk;
   bit  rst_n;
   wire led;
   bit  trst_n;
   bit  tck;
   bit  tms;
   bit  tdi;
   wire tdo;
   wire tdo_oe;

`include "tasks.svh"

   logic [4:0]      ir_resp    = 5'h0;
   logic [31:0]     idcode     = 32'h0;
   dtmcs_t          dtmcs      = '0;
   dmi_req_t        dmi_req    = '0;
   dmi_resp_t       dmi_resp   = '0;
   dm::dmstatus_t   dmstatus   = '0;
   dm::hartinfo_t   hartinfo   = '0;
   dm::abstractcs_t abstractcs = '0;

   ibex_soc_example dut(.*);

   always #(tclk / 2) clk = ~clk;

   always #(ttck / 2) tck = ~tck;

   assign trst_n = rst_n;

   initial
     begin:main
        string filename;
        int    status;

        $timeformat(-9, 3, " ns");

        status = $value$plusargs("filename=%s", filename);
        chk_filename: assert (status) else $fatal("No memory file provided. Please use './simv '+filename=<file.vmem>");
        $readmemh(filename, tb.dut.wb_spram.spram.mem);

        repeat (3) @(negedge clk);
        rst_n = 1'b1;

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
        jtag_run_test_idle(3);
        jtag_dr_dmi(dmi_req, dmi_resp);

        /* check dmstatus */
        $display("%t check dmstatus", $realtime);
        dmstatus = dmi_resp.data;
        chk_dmstatus_authenticated   : assert (dmstatus.authenticated   == 1'b1);
        chk_dmstatus_authbusy        : assert (dmstatus.authbusy        == 1'b0);
        chk_dmstatus_hasresethaltreq : assert (dmstatus.hasresethaltreq == 1'b0);
        chk_dmstatus_confstrptrvalid : assert (dmstatus.devtreevalid    == 1'b0);
        chk_dmstatus_version         : assert (dmstatus.version         == dm::DbgVersion013);

        /* read abstractcs */
        $display("%t DMI read hartinfo", $realtime);
        dmi_req.addr = dm::AbstractCS;
        dmi_req.op   = dm::DTM_READ;
        dmi_req.data = 32'h0;
        jtag_run_test_idle(3);
        jtag_dr_dmi(dmi_req, dmi_resp);

        /* check hartinfo */
        $display("%t check hartinfo", $realtime);
        hartinfo = dmi_resp.data;
        chk_hartinfo_nscratch   : assert (hartinfo.nscratch   == 4'd2);
        chk_hartinfo_dataaccess : assert (hartinfo.dataaccess == 1'b1);
        chk_hartinfo_datasize   : assert (hartinfo.datasize   == dm::DataCount);
        chk_hartinfo_dataaddr   : assert (hartinfo.dataaddr   == dm::DataAddr);

        $display("%t DMI noop", $realtime);
        jtag_run_test_idle(3);
        jtag_dr_dmi('0, dmi_resp);

        /* check abstractcs */
        $display("%t check abstractcs", $realtime);
        abstractcs = dmi_resp.data;
        chk_abstractcs_progbufsize : assert (abstractcs.progbufsize == 5'd8);
        chk_abstractcs_busy        : assert (abstractcs.busy        == 1'b0);
        chk_abstractcs_cmderr      : assert (abstractcs.cmderr      == dm::CmdErrNone);
        chk_abstractcs_datacount   : assert (abstractcs.datacount   == dm::DataCount);

        repeat (10) @(negedge clk);
        $finish;
     end:main
endmodule

`resetall
