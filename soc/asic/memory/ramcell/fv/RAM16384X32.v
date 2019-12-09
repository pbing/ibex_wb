// ****************************************************************
// ***                                                          ***
// ***   MIE FUJITSU SEMICONDUCTOR CS251 Series                 ***
// ***   1RW RAM with SLP Simulation Library                    ***
// ***   Copyright (c) MIE FUJITSU SEMICONDUCTOR Limited, 2017  ***
// ***   All Rights Reserved. Licensed Library.                 ***
// ***                                                          ***
// ****************************************************************
// 1RW-RAM [Redundancy # External FUSE][LargeScale][Sleep]<Standard> 
// Verilog HDL Gate Simulation Model.
//                                              LIB-cs251.common.bpf-0010
//                                              LIB-cs251.rpsqlpa.bpf-0001
// Rev. 0003    Apr 26,2017
// Rev. 0002    Oct 22,2013
// Rev. 0001    Apr 16,2012
module RAM16384X32 (A,
 I, IA, DM, CK, CE, WE, FO, SLP);
input [31 : 0] I, DM;
input [13 : 0] IA;
input [5 : 0] FO;
input CK, CE, WE, SLP;
output [31 : 0] A;
endmodule
