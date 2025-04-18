/* Simple Verilog model for Verilator */

module BSCANE2
  #(parameter DISABLE_JTAG = "FALSE",
    parameter integer JTAG_CHAIN = 1)
   (output logic CAPTURE,
    output logic DRCK,
    output logic RESET,
    output logic RUNTEST,
    output logic SEL,
    output logic SHIFT,
    output logic TCK,
    output logic TDI,
    output logic TMS,
    output logic UPDATE,
    input  logic TDO);

   assign
     CAPTURE = 1'b0,
     DRCK    = 1'b0,
     RESET   = 1'b0,
     RUNTEST = 1'b0,
     SEL     = 1'b0,
     SHIFT   = 1'b0,
     TCK     = 1'b0,
     TDI     = 1'b0,
     TMS     = 1'b0,
     UPDATE  = 1'b0;
endmodule
