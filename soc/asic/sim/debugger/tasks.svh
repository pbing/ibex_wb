task jtag_test_logic_reset();
   tms = 1'b1;
   repeat(5) @(negedge tck);
endtask

task jtag_run_test_idle(input int unsigned n = 1);
   tms = 1'b0;
   repeat (n) @(negedge tck);
endtask

task jtag_ir(input ir_t x, output [4:0] resp);
   static const bit [1:4] tms1 = 4'b1100;
   static const bit [1:2] tms2 = 2'b10;

   foreach(tms1[i])
     begin
	tms <= tms1[i];
	@(negedge tck);
     end

   for(int i = 0; i < $bits(x); i++)
     begin
	if(i < $bits(x) - 1)
	  tms <= 1'b0;
	else
	  tms <= 1'b1;

	tdi <= x[i];

        @(posedge tck) resp[i] <= tdo;
	@(negedge tck);
     end

   foreach(tms2[i])
     begin
	tms <= tms2[i];
	@(negedge tck);
     end

   chk_ir_resp: assert (resp[1:0] == 2'b01);
endtask

task jtag_dr_idcode (input [31:0] x = '0, output [31:0] resp);
   static const bit [1:3] tms1 = 3'b100;
   static const bit [1:2] tms2 = 2'b10;

   foreach(tms1[i])
     begin
	tms <= tms1[i];
	@(negedge tck);
     end

   for(int i = 0; i < $bits(x); i++)
     begin
	if(i < $bits(x) - 1)
	  tms <= 1'b0;
	else
	  tms <= 1'b1;

	tdi <= x[i];

        @(posedge tck) resp[i] <= tdo;
	@(negedge tck);
     end

   foreach(tms2[i])
     begin
	tms <= tms2[i];
	@(negedge tck);
     end
endtask

task jtag_dr_dtmcs (input dtmcs_t x = '0, output dtmcs_t resp);
   static const bit [1:3] tms1 = 3'b100;
   static const bit [1:2] tms2 = 2'b10;

   foreach(tms1[i])
     begin
	tms <= tms1[i];
	@(negedge tck);
     end

   for(int i = 0; i < $bits(x); i++)
     begin
	if(i < $bits(x) - 1)
	  tms <= 1'b0;
	else
	  tms <= 1'b1;

	tdi <= x[i];

        @(posedge tck) resp[i] <= tdo;
	@(negedge tck);
     end

   foreach(tms2[i])
     begin
	tms <= tms2[i];
	@(negedge tck);
     end
endtask

task jtag_dr_dmi (input dmi_req_t x = '0, output dmi_resp_t resp);
   static const bit [1:3] tms1 = 3'b100;
   static const bit [1:2] tms2 = 2'b10;

   jtag_run_test_idle(4); // adjust for CPU clock

   foreach(tms1[i])
     begin
	tms <= tms1[i];
	@(negedge tck);
     end

   for(int i = 0; i < $bits(x); i++)
     begin
	if(i < $bits(x) - 1)
	  tms <= 1'b0;
	else
	  tms <= 1'b1;

	tdi <= x[i];

        @(posedge tck) resp[i] <= tdo;
	@(negedge tck);
     end

   foreach(tms2[i])
     begin
	tms <= tms2[i];
	@(negedge tck);
     end

   chk_dmi_resp: assert (resp.resp == 2'd0);
endtask

task ac_read_register (input bit [15:0] regno, output [31:0] data);
   var dm::ac_ar_cmd_t ac_ar_cmd;
   var dm::command_t   command;

   ac_ar_cmd       = '{transfer: 1'b1, write: 1'b0, regno: regno, default: '0};
   command.cmdtype = dm::AccessRegister;
   command.control = ac_ar_cmd;

   dmi_req.addr = dm::Command;
   dmi_req.op   = dm::DTM_WRITE;
   dmi_req.data = command;
   jtag_dr_dmi(dmi_req, dmi_resp);

   dmi_req.addr = dm::Data0;
   dmi_req.op   = dm::DTM_READ;
   dmi_req.data = '0;
   jtag_dr_dmi(dmi_req, dmi_resp);

   dmi_req = '0;
   jtag_dr_dmi(dmi_req, dmi_resp);
   data = dmi_resp.data;
endtask

task ac_write_register (input bit [15:0] regno, input [31:0] data);
   var dm::ac_ar_cmd_t ac_ar_cmd;
   var dm::command_t   command;

   ac_ar_cmd       = '{transfer: 1'b1, write: 1'b1, regno: regno, default: '0};
   command.cmdtype = dm::AccessRegister;
   command.control = ac_ar_cmd;

   dmi_req.addr = dm::Command;
   dmi_req.op   = dm::DTM_WRITE;
   dmi_req.data = command;
   jtag_dr_dmi(dmi_req, dmi_resp);

   dmi_req.addr = dm::Data0;
   dmi_req.op   = dm::DTM_WRITE;
   dmi_req.data = data;
   jtag_dr_dmi(dmi_req, dmi_resp);
endtask

task sb_read_memory32 (input bit [31:0] addr, output [31:0] sbdata);
   var dm::sbcs_t sbcs;

   sbcs         = '{sbreadonaddr: 1'b1, sbaccess: 2, default: '0};
   dmi_req.addr = dm::SBCS;
   dmi_req.op   = dm::DTM_WRITE;
   dmi_req.data = sbcs;
   jtag_dr_dmi(dmi_req, dmi_resp);

   dmi_req.addr = dm::SBAddress0;
   dmi_req.op   = dm::DTM_WRITE;
   dmi_req.data = addr;
   jtag_dr_dmi(dmi_req, dmi_resp);

   dmi_req.addr = dm::SBData0;
   dmi_req.op   = dm::DTM_READ;
   dmi_req.data = '0;
   jtag_dr_dmi(dmi_req, dmi_resp);

   dmi_req = '0;
   jtag_dr_dmi(dmi_req, dmi_resp);
   sbdata = dmi_resp.data;
endtask

task sb_write_memory32 (input bit [31:0] addr, input [31:0] sbdata);
   var dm::sbcs_t sbcs;

   sbcs         = '{sbaccess: 2, default: '0};
   dmi_req.addr = dm::SBCS;
   dmi_req.op   = dm::DTM_WRITE;
   dmi_req.data = sbcs;
   jtag_dr_dmi(dmi_req, dmi_resp);

   dmi_req.addr = dm::SBAddress0;
   dmi_req.op   = dm::DTM_WRITE;
   dmi_req.data = addr;
   jtag_dr_dmi(dmi_req, dmi_resp);

   dmi_req.addr = dm::SBData0;
   dmi_req.op   = dm::DTM_WRITE;
   dmi_req.data = sbdata;
   jtag_dr_dmi(dmi_req, dmi_resp);
endtask
