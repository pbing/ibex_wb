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

task jtag_test_logic_reset();
   tms = 1'b1;
   repeat(5) @(negedge tck);
endtask

task jtag_run_test_idle(input int unsigned n = 1);
   tms = 1'b0;
   repeat (n) @(negedge tck);
endtask

task jtag_ir(input ir_t x, output [4:0] resp);
   const bit [1:4] tms1 = 4'b1100;
   const bit [1:2] tms2 = 2'b10;

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
   const bit [1:3] tms1 = 3'b100;
   const bit [1:2] tms2 = 2'b10;

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
   const bit [1:3] tms1 = 3'b100;
   const bit [1:2] tms2 = 2'b10;

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
   const bit [1:3] tms1 = 3'b100;
   const bit [1:2] tms2 = 2'b10;

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
