/* Testbecnh */

`default_nettype none

module tb;
   timeunit 1ns / 1ps;

   const realtime tclk = 1s / 100.0e6;

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
   bit          debug_req;
   bit          fetch_enable = 1'b1;
   wire         core_sleep;

   wb_if wbm[2](.*);
   wb_if wbs[1](.*);

   ibex_wb dut
     (.instr_wb (wbm[0]),
      .data_wb  (wbm[1]),
      .*);

   wb_interconnect_sharedbus 
     #(.nums      (1),
       .base_addr ({ram_base_addr}),
       .size      ({ram_size}) )
   wb_intercon
     (.*);

   spramx32 #(ram_size) ram (wbs);

`ifdef ASSERT_ON
   wb_checker wbm0_checker(wbm[0]);
   wb_checker wbm1_checker(wbm[1]);
   wb_checker wbs0_checker(wbs[0]);
`endif

   always #(tclk / 2) clk = ~clk;

   initial
     begin:main
        string filename;
        int    status;

        $timeformat(-9, 3, " ns");

        status = $value$plusargs("filename=%s", filename);
        assert(status) else $fatal("No memory file provided. Please use './simv '+filename=<file.vmem>");
        $readmemh(filename, tb.ram.mem);

        repeat (3) @(negedge clk);
        rst = 1'b0;

        repeat (350) @(negedge clk);
        $finish;
     end:main
endmodule

`resetall
