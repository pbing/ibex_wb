/* Testbench */

`default_nettype none

module tb;
   timeunit 1ns / 1ps;

   const realtime tclk = 1s / 100.0e6; // CPU clock period
   const realtime ttck = 1s / 10.0e6;  // JTAG clock period

   bit  clk;
   bit  rst_n;
   wire led;
   bit  trst_n;
   bit  tck;
   bit  tms;
   bit  tdi;
   wire tdo;
   wire tdo_oe;

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
        assert(status) else $fatal(1, "No memory file provided. Please use './simv '+filename=<file.vmem>");
        $readmemh(filename, tb.dut.wb_spram.spram.mem);

        repeat (3) @(negedge clk);
        rst_n = 1'b1;

        repeat (350) @(negedge clk);
        $finish;
     end:main
endmodule

`resetall
