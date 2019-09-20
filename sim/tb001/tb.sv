/* Testbecnh */

`default_nettype none

module tb;
   timeunit 1ns / 1ps;

   const realtime tclk = 1s / 100.0e6;

   bit          clk;
   bit          rst = 1'b1;

   wire         instr_req;
   wire         instr_gnt;
   wire         instr_rvalid;
   wire  [31:0] instr_addr;
   wire  [31:0] instr_rdata;
   wire         instr_err;

   bit          test_en;
   bit  [31:0]  hart_id;
   bit  [31:0]  boot_addr;
   bit          irq_software;
   bit          irq_timer;
   bit          irq_external;
   bit  [14:0]  irq_fast;
   bit          irq_nm;
   bit          debug_req;
   bit          fetch_enable = 1'b1;
   wire         core_sleep;

   if_wb wb(.*);
   ibex_wb dut(.*);

   instr_mem rom
     (.*,
      .req    (instr_req),
      .gnt    (instr_gnt),
      .rvalid (instr_rvalid),
      .addr   (instr_addr),
      .rdata  (instr_rdata),
      .err    (instr_err));

   data_mem ram(.*);

`ifdef ASSERT_ON
   wb_checker wb_checker(wb);
`endif

   always #(tclk / 2) clk = ~clk;

   initial
     begin:main
        $timeformat(-9, 3, " ns");
        $readmemh("instr_mem.vmem", tb.rom.mem);

        repeat (3) @(negedge clk);
        rst = 1'b0;

        repeat (30) @(negedge clk);
        $finish;
     end:main
endmodule

`resetall
