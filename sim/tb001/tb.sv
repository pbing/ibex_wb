/* Testbecnh */

`default_nettype none

module tb;
   timeunit 1ns / 1ps;

   const realtime tclk = 1s / 100.0e6;

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
   bit          debug_req;
   bit          fetch_enable = 1'b1;
   wire         core_sleep;

   if_wb wbm[1:0](.*);
   if_wb wbs[1:0](.*);

   ibex_wb dut
     (.instr_wb (wbm[0]),
      .data_wb  (wbm[1]),
      .*);

   instr_mem rom(wbs[0]);
   data_mem ram(wbs[1]);

`ifdef ASSERT_ON
   wb_checker wbm0_checker(wbm[0]);
   wb_checker wbm1_checker(wbm[1]);
   wb_checker wb0_checker(wbm[0]);
   wb_checker wbm1_checker(wbm[1]);
`endif

   always #(tclk / 2) clk = ~clk;

   initial
     begin:main
        $timeformat(-9, 3, " ns");
        $readmemh("instr_mem.vmem", tb.rom.mem);

        repeat (3) @(negedge clk);
        rst = 1'b0;

        repeat (350) @(negedge clk);
        $finish;
     end:main
endmodule

`resetall
