// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module prim_clock_gating
  (input  wire  clk_i,
   input  wire  en_i,
   input  wire  test_en_i,
   output logic clk_o);

   BUFGCE
     #(.SIM_DEVICE("7SERIES"))
   u_clock_gating
     (.I  (clk_i),
      .CE (en_i | test_en_i),
      .O  (clk_o));

endmodule

`resetall
