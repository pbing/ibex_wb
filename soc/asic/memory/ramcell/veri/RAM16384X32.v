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


`resetall
`timescale 1ps/1ps
`celldefine
`ifdef verifault
	`suppress_faults
	`enable_portfaults
`endif
//`delay_mode_path

module RAM16384X32 (A,
 I, IA, DM, CK, CE, WE, FO, SLP);

`define BIT_RAM16384X32 32 // bit_disper
`define WORD_RAM16384X32 16384 // word_disper
// `define LOG_WORD_RAM16384X32 16384 // logical word
`define ADDRESS_RAM16384X32 14 // addres_num
`define BITNUM_RAM16384X32 5
`define FO_RAM16384X32 6 // fo_num
`ifdef FAST_FUNC
`ifdef del_hold_delay
`else
`define hold_delay 10
`endif
`endif

input [31 : 0] I, DM;
input [13 : 0] IA;
input [5 : 0] FO;
input CK, CE, WE, SLP;
output [31 : 0] A;

`ifdef FAST_FUNC
`else
reg
 notify_CKWL, notify_CKWH, notify_FO_CK_FO,
 notify_I31_CK_I31,
 notify_I30_CK_I30,
 notify_I29_CK_I29,
 notify_I28_CK_I28,
 notify_I27_CK_I27,
 notify_I26_CK_I26,
 notify_I25_CK_I25,
 notify_I24_CK_I24,
 notify_I23_CK_I23,
 notify_I22_CK_I22,
 notify_I21_CK_I21,
 notify_I20_CK_I20,
 notify_I19_CK_I19,
 notify_I18_CK_I18,
 notify_I17_CK_I17,
 notify_I16_CK_I16,
 notify_I15_CK_I15,
 notify_I14_CK_I14,
 notify_I13_CK_I13,
 notify_I12_CK_I12,
 notify_I11_CK_I11,
 notify_I10_CK_I10,
 notify_I9_CK_I9,
 notify_I8_CK_I8,
 notify_I7_CK_I7,
 notify_I6_CK_I6,
 notify_I5_CK_I5,
 notify_I4_CK_I4,
 notify_I3_CK_I3,
 notify_I2_CK_I2,
 notify_I1_CK_I1,
 notify_I0_CK_I0,
 notify_WE_CK_WE, notify_IA_CK_IA, notify_SLP;
`endif

wire [`BIT_RAM16384X32 - 1 : 0] Buf_I, Buf_DM, Buf_A;
wire [`ADDRESS_RAM16384X32 - 1 : 0] Buf_IA;
wire [`FO_RAM16384X32 - 1 : 0] Buf_FO;

// Dummy Buffer for SDF Annotation
buf
`ifdef FAST_FUNC
`ifdef del_hold_delay
`else
#`hold_delay
`endif
`endif
 (Buf_CE, CE),
 (Buf_I[31], I[31]), (Buf_DM[31], DM[31]),
 (Buf_I[30], I[30]), (Buf_DM[30], DM[30]),
 (Buf_I[29], I[29]), (Buf_DM[29], DM[29]),
 (Buf_I[28], I[28]), (Buf_DM[28], DM[28]),
 (Buf_I[27], I[27]), (Buf_DM[27], DM[27]),
 (Buf_I[26], I[26]), (Buf_DM[26], DM[26]),
 (Buf_I[25], I[25]), (Buf_DM[25], DM[25]),
 (Buf_I[24], I[24]), (Buf_DM[24], DM[24]),
 (Buf_I[23], I[23]), (Buf_DM[23], DM[23]),
 (Buf_I[22], I[22]), (Buf_DM[22], DM[22]),
 (Buf_I[21], I[21]), (Buf_DM[21], DM[21]),
 (Buf_I[20], I[20]), (Buf_DM[20], DM[20]),
 (Buf_I[19], I[19]), (Buf_DM[19], DM[19]),
 (Buf_I[18], I[18]), (Buf_DM[18], DM[18]),
 (Buf_I[17], I[17]), (Buf_DM[17], DM[17]),
 (Buf_I[16], I[16]), (Buf_DM[16], DM[16]),
 (Buf_I[15], I[15]), (Buf_DM[15], DM[15]),
 (Buf_I[14], I[14]), (Buf_DM[14], DM[14]),
 (Buf_I[13], I[13]), (Buf_DM[13], DM[13]),
 (Buf_I[12], I[12]), (Buf_DM[12], DM[12]),
 (Buf_I[11], I[11]), (Buf_DM[11], DM[11]),
 (Buf_I[10], I[10]), (Buf_DM[10], DM[10]),
 (Buf_I[9], I[9]), (Buf_DM[9], DM[9]),
 (Buf_I[8], I[8]), (Buf_DM[8], DM[8]),
 (Buf_I[7], I[7]), (Buf_DM[7], DM[7]),
 (Buf_I[6], I[6]), (Buf_DM[6], DM[6]),
 (Buf_I[5], I[5]), (Buf_DM[5], DM[5]),
 (Buf_I[4], I[4]), (Buf_DM[4], DM[4]),
 (Buf_I[3], I[3]), (Buf_DM[3], DM[3]),
 (Buf_I[2], I[2]), (Buf_DM[2], DM[2]),
 (Buf_I[1], I[1]), (Buf_DM[1], DM[1]),
 (Buf_I[0], I[0]), (Buf_DM[0], DM[0]),
 (Buf_IA[13], IA[13]),
 (Buf_IA[12], IA[12]),
 (Buf_IA[11], IA[11]),
 (Buf_IA[10], IA[10]),
 (Buf_IA[9], IA[9]),
 (Buf_IA[8], IA[8]),
 (Buf_IA[7], IA[7]),
 (Buf_IA[6], IA[6]),
 (Buf_IA[5], IA[5]),
 (Buf_IA[4], IA[4]),
 (Buf_IA[3], IA[3]),
 (Buf_IA[2], IA[2]),
 (Buf_IA[1], IA[1]),
 (Buf_IA[0], IA[0]),
 (Buf_FO[5], FO[5]), 
 (Buf_FO[4], FO[4]), 
 (Buf_FO[3], FO[3]), 
 (Buf_FO[2], FO[2]), 
 (Buf_FO[1], FO[1]), 
 (Buf_FO[0], FO[0]), 
 (Buf_SLP, SLP),
 (Buf_WE, WE);
buf
 (A[31], Buf_A[31]),
 (A[30], Buf_A[30]),
 (A[29], Buf_A[29]),
 (A[28], Buf_A[28]),
 (A[27], Buf_A[27]),
 (A[26], Buf_A[26]),
 (A[25], Buf_A[25]),
 (A[24], Buf_A[24]),
 (A[23], Buf_A[23]),
 (A[22], Buf_A[22]),
 (A[21], Buf_A[21]),
 (A[20], Buf_A[20]),
 (A[19], Buf_A[19]),
 (A[18], Buf_A[18]),
 (A[17], Buf_A[17]),
 (A[16], Buf_A[16]),
 (A[15], Buf_A[15]),
 (A[14], Buf_A[14]),
 (A[13], Buf_A[13]),
 (A[12], Buf_A[12]),
 (A[11], Buf_A[11]),
 (A[10], Buf_A[10]),
 (A[9], Buf_A[9]),
 (A[8], Buf_A[8]),
 (A[7], Buf_A[7]),
 (A[6], Buf_A[6]),
 (A[5], Buf_A[5]),
 (A[4], Buf_A[4]),
 (A[3], Buf_A[3]),
 (A[2], Buf_A[2]),
 (A[1], Buf_A[1]),
 (A[0], Buf_A[0]),
 (Buf_CK, CK);

// Condition Signal For Timing Check
`ifdef FAST_FUNC
`ifdef same_time_check
wire FOe0;
not (CEe0, Buf_CE);
and
 (FOe0andCEe0andWEe0, FOe0andCEe0, ~Buf_WE),
 (FOe0andCEe0andWEe0andN_DM31e0, FOe0andCEe0andWEe0, ~Buf_DM[31]),
 (FOe0andCEe0andWEe0andN_DM30e0, FOe0andCEe0andWEe0, ~Buf_DM[30]),
 (FOe0andCEe0andWEe0andN_DM29e0, FOe0andCEe0andWEe0, ~Buf_DM[29]),
 (FOe0andCEe0andWEe0andN_DM28e0, FOe0andCEe0andWEe0, ~Buf_DM[28]),
 (FOe0andCEe0andWEe0andN_DM27e0, FOe0andCEe0andWEe0, ~Buf_DM[27]),
 (FOe0andCEe0andWEe0andN_DM26e0, FOe0andCEe0andWEe0, ~Buf_DM[26]),
 (FOe0andCEe0andWEe0andN_DM25e0, FOe0andCEe0andWEe0, ~Buf_DM[25]),
 (FOe0andCEe0andWEe0andN_DM24e0, FOe0andCEe0andWEe0, ~Buf_DM[24]),
 (FOe0andCEe0andWEe0andN_DM23e0, FOe0andCEe0andWEe0, ~Buf_DM[23]),
 (FOe0andCEe0andWEe0andN_DM22e0, FOe0andCEe0andWEe0, ~Buf_DM[22]),
 (FOe0andCEe0andWEe0andN_DM21e0, FOe0andCEe0andWEe0, ~Buf_DM[21]),
 (FOe0andCEe0andWEe0andN_DM20e0, FOe0andCEe0andWEe0, ~Buf_DM[20]),
 (FOe0andCEe0andWEe0andN_DM19e0, FOe0andCEe0andWEe0, ~Buf_DM[19]),
 (FOe0andCEe0andWEe0andN_DM18e0, FOe0andCEe0andWEe0, ~Buf_DM[18]),
 (FOe0andCEe0andWEe0andN_DM17e0, FOe0andCEe0andWEe0, ~Buf_DM[17]),
 (FOe0andCEe0andWEe0andN_DM16e0, FOe0andCEe0andWEe0, ~Buf_DM[16]),
 (FOe0andCEe0andWEe0andN_DM15e0, FOe0andCEe0andWEe0, ~Buf_DM[15]),
 (FOe0andCEe0andWEe0andN_DM14e0, FOe0andCEe0andWEe0, ~Buf_DM[14]),
 (FOe0andCEe0andWEe0andN_DM13e0, FOe0andCEe0andWEe0, ~Buf_DM[13]),
 (FOe0andCEe0andWEe0andN_DM12e0, FOe0andCEe0andWEe0, ~Buf_DM[12]),
 (FOe0andCEe0andWEe0andN_DM11e0, FOe0andCEe0andWEe0, ~Buf_DM[11]),
 (FOe0andCEe0andWEe0andN_DM10e0, FOe0andCEe0andWEe0, ~Buf_DM[10]),
 (FOe0andCEe0andWEe0andN_DM9e0, FOe0andCEe0andWEe0, ~Buf_DM[9]),
 (FOe0andCEe0andWEe0andN_DM8e0, FOe0andCEe0andWEe0, ~Buf_DM[8]),
 (FOe0andCEe0andWEe0andN_DM7e0, FOe0andCEe0andWEe0, ~Buf_DM[7]),
 (FOe0andCEe0andWEe0andN_DM6e0, FOe0andCEe0andWEe0, ~Buf_DM[6]),
 (FOe0andCEe0andWEe0andN_DM5e0, FOe0andCEe0andWEe0, ~Buf_DM[5]),
 (FOe0andCEe0andWEe0andN_DM4e0, FOe0andCEe0andWEe0, ~Buf_DM[4]),
 (FOe0andCEe0andWEe0andN_DM3e0, FOe0andCEe0andWEe0, ~Buf_DM[3]),
 (FOe0andCEe0andWEe0andN_DM2e0, FOe0andCEe0andWEe0, ~Buf_DM[2]),
 (FOe0andCEe0andWEe0andN_DM1e0, FOe0andCEe0andWEe0, ~Buf_DM[1]),
 (FOe0andCEe0andWEe0andN_DM0e0, FOe0andCEe0andWEe0, ~Buf_DM[0]),
 (FOe0andCEe0, FOe0, CEe0);
`endif
`else
wire #1 N_CEe0;
wire FOe0;
not (CEe0, Buf_CE);
and
 (FOe0andCEe0andWEe0, FOe0andCEe0, ~Buf_WE),
 (FOe0andCEe0andWEe0andN_DM31e0, FOe0andCEe0andWEe0, ~Buf_DM[31]),
 (FOe0andCEe0andWEe0andN_DM30e0, FOe0andCEe0andWEe0, ~Buf_DM[30]),
 (FOe0andCEe0andWEe0andN_DM29e0, FOe0andCEe0andWEe0, ~Buf_DM[29]),
 (FOe0andCEe0andWEe0andN_DM28e0, FOe0andCEe0andWEe0, ~Buf_DM[28]),
 (FOe0andCEe0andWEe0andN_DM27e0, FOe0andCEe0andWEe0, ~Buf_DM[27]),
 (FOe0andCEe0andWEe0andN_DM26e0, FOe0andCEe0andWEe0, ~Buf_DM[26]),
 (FOe0andCEe0andWEe0andN_DM25e0, FOe0andCEe0andWEe0, ~Buf_DM[25]),
 (FOe0andCEe0andWEe0andN_DM24e0, FOe0andCEe0andWEe0, ~Buf_DM[24]),
 (FOe0andCEe0andWEe0andN_DM23e0, FOe0andCEe0andWEe0, ~Buf_DM[23]),
 (FOe0andCEe0andWEe0andN_DM22e0, FOe0andCEe0andWEe0, ~Buf_DM[22]),
 (FOe0andCEe0andWEe0andN_DM21e0, FOe0andCEe0andWEe0, ~Buf_DM[21]),
 (FOe0andCEe0andWEe0andN_DM20e0, FOe0andCEe0andWEe0, ~Buf_DM[20]),
 (FOe0andCEe0andWEe0andN_DM19e0, FOe0andCEe0andWEe0, ~Buf_DM[19]),
 (FOe0andCEe0andWEe0andN_DM18e0, FOe0andCEe0andWEe0, ~Buf_DM[18]),
 (FOe0andCEe0andWEe0andN_DM17e0, FOe0andCEe0andWEe0, ~Buf_DM[17]),
 (FOe0andCEe0andWEe0andN_DM16e0, FOe0andCEe0andWEe0, ~Buf_DM[16]),
 (FOe0andCEe0andWEe0andN_DM15e0, FOe0andCEe0andWEe0, ~Buf_DM[15]),
 (FOe0andCEe0andWEe0andN_DM14e0, FOe0andCEe0andWEe0, ~Buf_DM[14]),
 (FOe0andCEe0andWEe0andN_DM13e0, FOe0andCEe0andWEe0, ~Buf_DM[13]),
 (FOe0andCEe0andWEe0andN_DM12e0, FOe0andCEe0andWEe0, ~Buf_DM[12]),
 (FOe0andCEe0andWEe0andN_DM11e0, FOe0andCEe0andWEe0, ~Buf_DM[11]),
 (FOe0andCEe0andWEe0andN_DM10e0, FOe0andCEe0andWEe0, ~Buf_DM[10]),
 (FOe0andCEe0andWEe0andN_DM9e0, FOe0andCEe0andWEe0, ~Buf_DM[9]),
 (FOe0andCEe0andWEe0andN_DM8e0, FOe0andCEe0andWEe0, ~Buf_DM[8]),
 (FOe0andCEe0andWEe0andN_DM7e0, FOe0andCEe0andWEe0, ~Buf_DM[7]),
 (FOe0andCEe0andWEe0andN_DM6e0, FOe0andCEe0andWEe0, ~Buf_DM[6]),
 (FOe0andCEe0andWEe0andN_DM5e0, FOe0andCEe0andWEe0, ~Buf_DM[5]),
 (FOe0andCEe0andWEe0andN_DM4e0, FOe0andCEe0andWEe0, ~Buf_DM[4]),
 (FOe0andCEe0andWEe0andN_DM3e0, FOe0andCEe0andWEe0, ~Buf_DM[3]),
 (FOe0andCEe0andWEe0andN_DM2e0, FOe0andCEe0andWEe0, ~Buf_DM[2]),
 (FOe0andCEe0andWEe0andN_DM1e0, FOe0andCEe0andWEe0, ~Buf_DM[1]),
 (FOe0andCEe0andWEe0andN_DM0e0, FOe0andCEe0andWEe0, ~Buf_DM[0]),
 (FOe0andCEe0, FOe0, CEe0),
 (FOe0andN_CEe0, FOe0, N_CEe0);
`ifdef pre_sdf
wire disable_tchk;

assign disable_tchk = 0;
`endif
`endif

specify
// Path Delay
`ifdef FAST_FUNC
(CK *> A) = (1, 1);
`ifdef same_time_check
`ifdef del_hold_delay
$hold (posedge CK &&& FOe0andCEe0, IA[13], 1);
$hold (posedge CK &&& FOe0andCEe0, IA[12], 1);
$hold (posedge CK &&& FOe0andCEe0, IA[11], 1);
$hold (posedge CK &&& FOe0andCEe0, IA[10], 1);
$hold (posedge CK &&& FOe0andCEe0, IA[9], 1);
$hold (posedge CK &&& FOe0andCEe0, IA[8], 1);
$hold (posedge CK &&& FOe0andCEe0, IA[7], 1);
$hold (posedge CK &&& FOe0andCEe0, IA[6], 1);
$hold (posedge CK &&& FOe0andCEe0, IA[5], 1);
$hold (posedge CK &&& FOe0andCEe0, IA[4], 1);
$hold (posedge CK &&& FOe0andCEe0, IA[3], 1);
$hold (posedge CK &&& FOe0andCEe0, IA[2], 1);
$hold (posedge CK &&& FOe0andCEe0, IA[1], 1);
$hold (posedge CK &&& FOe0andCEe0, IA[0], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM31e0, I[31], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM30e0, I[30], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM29e0, I[29], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM28e0, I[28], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM27e0, I[27], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM26e0, I[26], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM25e0, I[25], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM24e0, I[24], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM23e0, I[23], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM22e0, I[22], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM21e0, I[21], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM20e0, I[20], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM19e0, I[19], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM18e0, I[18], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM17e0, I[17], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM16e0, I[16], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM15e0, I[15], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM14e0, I[14], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM13e0, I[13], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM12e0, I[12], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM11e0, I[11], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM10e0, I[10], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM9e0, I[9], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM8e0, I[8], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM7e0, I[7], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM6e0, I[6], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM5e0, I[5], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM4e0, I[4], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM3e0, I[3], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM2e0, I[2], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM1e0, I[1], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM0e0, I[0], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[31], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[30], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[29], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[28], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[27], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[26], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[25], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[24], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[23], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[22], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[21], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[20], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[19], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[18], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[17], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[16], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[15], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[14], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[13], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[12], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[11], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[10], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[9], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[8], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[7], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[6], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[5], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[4], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[3], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[2], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[1], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, DM[0], 1);
$hold (posedge CK &&& FOe0andCEe0, WE, 1);
$hold (posedge CK &&& CEe0, FO[5], 1);
$hold (posedge CK &&& CEe0, FO[4], 1);
$hold (posedge CK &&& CEe0, FO[3], 1);
$hold (posedge CK &&& CEe0, FO[2], 1);
$hold (posedge CK &&& CEe0, FO[1], 1);
$hold (posedge CK &&& CEe0, FO[0], 1);
$hold (posedge CK, CE, 1);
`else
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[13], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[12], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[11], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[10], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[9], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[8], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[7], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[6], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[5], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[4], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[3], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[2], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[1], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_IA[0], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM31e0, Buf_I[31], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM30e0, Buf_I[30], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM29e0, Buf_I[29], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM28e0, Buf_I[28], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM27e0, Buf_I[27], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM26e0, Buf_I[26], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM25e0, Buf_I[25], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM24e0, Buf_I[24], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM23e0, Buf_I[23], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM22e0, Buf_I[22], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM21e0, Buf_I[21], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM20e0, Buf_I[20], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM19e0, Buf_I[19], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM18e0, Buf_I[18], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM17e0, Buf_I[17], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM16e0, Buf_I[16], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM15e0, Buf_I[15], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM14e0, Buf_I[14], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM13e0, Buf_I[13], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM12e0, Buf_I[12], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM11e0, Buf_I[11], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM10e0, Buf_I[10], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM9e0, Buf_I[9], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM8e0, Buf_I[8], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM7e0, Buf_I[7], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM6e0, Buf_I[6], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM5e0, Buf_I[5], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM4e0, Buf_I[4], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM3e0, Buf_I[3], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM2e0, Buf_I[2], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM1e0, Buf_I[1], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0andN_DM0e0, Buf_I[0], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[31], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[30], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[29], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[28], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[27], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[26], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[25], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[24], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[23], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[22], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[21], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[20], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[19], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[18], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[17], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[16], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[15], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[14], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[13], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[12], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[11], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[10], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[9], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[8], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[7], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[6], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[5], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[4], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[3], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[2], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[1], 1);
$hold (posedge CK &&& FOe0andCEe0andWEe0, Buf_DM[0], 1);
$hold (posedge CK &&& FOe0andCEe0, Buf_WE, 1);
$hold (posedge CK &&& CEe0, Buf_FO[5], 1);
$hold (posedge CK &&& CEe0, Buf_FO[4], 1);
$hold (posedge CK &&& CEe0, Buf_FO[3], 1);
$hold (posedge CK &&& CEe0, Buf_FO[2], 1);
$hold (posedge CK &&& CEe0, Buf_FO[1], 1);
$hold (posedge CK &&& CEe0, Buf_FO[0], 1);
$hold (posedge CK, Buf_CE, 1);
`endif
`endif
`else
specparam
tAAC = (1:1:1);

(posedge CK => (A[31] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[30] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[29] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[28] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[27] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[26] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[25] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[24] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[23] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[22] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[21] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[20] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[19] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[18] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[17] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[16] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[15] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[14] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[13] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[12] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[11] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[10] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[9] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[8] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[7] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[6] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[5] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[4] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[3] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[2] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[1] : 1'bx)) = (tAAC, tAAC);
(posedge CK => (A[0] : 1'bx)) = (tAAC, tAAC);
(FO[5] => A[31]) = (0, 0);
(FO[5] => A[30]) = (0, 0);
(FO[5] => A[29]) = (0, 0);
(FO[5] => A[28]) = (0, 0);
(FO[5] => A[27]) = (0, 0);
(FO[5] => A[26]) = (0, 0);
(FO[5] => A[25]) = (0, 0);
(FO[5] => A[24]) = (0, 0);
(FO[5] => A[23]) = (0, 0);
(FO[5] => A[22]) = (0, 0);
(FO[5] => A[21]) = (0, 0);
(FO[5] => A[20]) = (0, 0);
(FO[5] => A[19]) = (0, 0);
(FO[5] => A[18]) = (0, 0);
(FO[5] => A[17]) = (0, 0);
(FO[5] => A[16]) = (0, 0);
(FO[5] => A[15]) = (0, 0);
(FO[5] => A[14]) = (0, 0);
(FO[5] => A[13]) = (0, 0);
(FO[5] => A[12]) = (0, 0);
(FO[5] => A[11]) = (0, 0);
(FO[5] => A[10]) = (0, 0);
(FO[5] => A[9]) = (0, 0);
(FO[5] => A[8]) = (0, 0);
(FO[5] => A[7]) = (0, 0);
(FO[5] => A[6]) = (0, 0);
(FO[5] => A[5]) = (0, 0);
(FO[5] => A[4]) = (0, 0);
(FO[5] => A[3]) = (0, 0);
(FO[5] => A[2]) = (0, 0);
(FO[5] => A[1]) = (0, 0);
(FO[5] => A[0]) = (0, 0);
(FO[4] => A[31]) = (0, 0);
(FO[4] => A[30]) = (0, 0);
(FO[4] => A[29]) = (0, 0);
(FO[4] => A[28]) = (0, 0);
(FO[4] => A[27]) = (0, 0);
(FO[4] => A[26]) = (0, 0);
(FO[4] => A[25]) = (0, 0);
(FO[4] => A[24]) = (0, 0);
(FO[4] => A[23]) = (0, 0);
(FO[4] => A[22]) = (0, 0);
(FO[4] => A[21]) = (0, 0);
(FO[4] => A[20]) = (0, 0);
(FO[4] => A[19]) = (0, 0);
(FO[4] => A[18]) = (0, 0);
(FO[4] => A[17]) = (0, 0);
(FO[4] => A[16]) = (0, 0);
(FO[4] => A[15]) = (0, 0);
(FO[4] => A[14]) = (0, 0);
(FO[4] => A[13]) = (0, 0);
(FO[4] => A[12]) = (0, 0);
(FO[4] => A[11]) = (0, 0);
(FO[4] => A[10]) = (0, 0);
(FO[4] => A[9]) = (0, 0);
(FO[4] => A[8]) = (0, 0);
(FO[4] => A[7]) = (0, 0);
(FO[4] => A[6]) = (0, 0);
(FO[4] => A[5]) = (0, 0);
(FO[4] => A[4]) = (0, 0);
(FO[4] => A[3]) = (0, 0);
(FO[4] => A[2]) = (0, 0);
(FO[4] => A[1]) = (0, 0);
(FO[4] => A[0]) = (0, 0);
(FO[3] => A[31]) = (0, 0);
(FO[3] => A[30]) = (0, 0);
(FO[3] => A[29]) = (0, 0);
(FO[3] => A[28]) = (0, 0);
(FO[3] => A[27]) = (0, 0);
(FO[3] => A[26]) = (0, 0);
(FO[3] => A[25]) = (0, 0);
(FO[3] => A[24]) = (0, 0);
(FO[3] => A[23]) = (0, 0);
(FO[3] => A[22]) = (0, 0);
(FO[3] => A[21]) = (0, 0);
(FO[3] => A[20]) = (0, 0);
(FO[3] => A[19]) = (0, 0);
(FO[3] => A[18]) = (0, 0);
(FO[3] => A[17]) = (0, 0);
(FO[3] => A[16]) = (0, 0);
(FO[3] => A[15]) = (0, 0);
(FO[3] => A[14]) = (0, 0);
(FO[3] => A[13]) = (0, 0);
(FO[3] => A[12]) = (0, 0);
(FO[3] => A[11]) = (0, 0);
(FO[3] => A[10]) = (0, 0);
(FO[3] => A[9]) = (0, 0);
(FO[3] => A[8]) = (0, 0);
(FO[3] => A[7]) = (0, 0);
(FO[3] => A[6]) = (0, 0);
(FO[3] => A[5]) = (0, 0);
(FO[3] => A[4]) = (0, 0);
(FO[3] => A[3]) = (0, 0);
(FO[3] => A[2]) = (0, 0);
(FO[3] => A[1]) = (0, 0);
(FO[3] => A[0]) = (0, 0);
(FO[2] => A[31]) = (0, 0);
(FO[2] => A[30]) = (0, 0);
(FO[2] => A[29]) = (0, 0);
(FO[2] => A[28]) = (0, 0);
(FO[2] => A[27]) = (0, 0);
(FO[2] => A[26]) = (0, 0);
(FO[2] => A[25]) = (0, 0);
(FO[2] => A[24]) = (0, 0);
(FO[2] => A[23]) = (0, 0);
(FO[2] => A[22]) = (0, 0);
(FO[2] => A[21]) = (0, 0);
(FO[2] => A[20]) = (0, 0);
(FO[2] => A[19]) = (0, 0);
(FO[2] => A[18]) = (0, 0);
(FO[2] => A[17]) = (0, 0);
(FO[2] => A[16]) = (0, 0);
(FO[2] => A[15]) = (0, 0);
(FO[2] => A[14]) = (0, 0);
(FO[2] => A[13]) = (0, 0);
(FO[2] => A[12]) = (0, 0);
(FO[2] => A[11]) = (0, 0);
(FO[2] => A[10]) = (0, 0);
(FO[2] => A[9]) = (0, 0);
(FO[2] => A[8]) = (0, 0);
(FO[2] => A[7]) = (0, 0);
(FO[2] => A[6]) = (0, 0);
(FO[2] => A[5]) = (0, 0);
(FO[2] => A[4]) = (0, 0);
(FO[2] => A[3]) = (0, 0);
(FO[2] => A[2]) = (0, 0);
(FO[2] => A[1]) = (0, 0);
(FO[2] => A[0]) = (0, 0);
(FO[1] => A[31]) = (0, 0);
(FO[1] => A[30]) = (0, 0);
(FO[1] => A[29]) = (0, 0);
(FO[1] => A[28]) = (0, 0);
(FO[1] => A[27]) = (0, 0);
(FO[1] => A[26]) = (0, 0);
(FO[1] => A[25]) = (0, 0);
(FO[1] => A[24]) = (0, 0);
(FO[1] => A[23]) = (0, 0);
(FO[1] => A[22]) = (0, 0);
(FO[1] => A[21]) = (0, 0);
(FO[1] => A[20]) = (0, 0);
(FO[1] => A[19]) = (0, 0);
(FO[1] => A[18]) = (0, 0);
(FO[1] => A[17]) = (0, 0);
(FO[1] => A[16]) = (0, 0);
(FO[1] => A[15]) = (0, 0);
(FO[1] => A[14]) = (0, 0);
(FO[1] => A[13]) = (0, 0);
(FO[1] => A[12]) = (0, 0);
(FO[1] => A[11]) = (0, 0);
(FO[1] => A[10]) = (0, 0);
(FO[1] => A[9]) = (0, 0);
(FO[1] => A[8]) = (0, 0);
(FO[1] => A[7]) = (0, 0);
(FO[1] => A[6]) = (0, 0);
(FO[1] => A[5]) = (0, 0);
(FO[1] => A[4]) = (0, 0);
(FO[1] => A[3]) = (0, 0);
(FO[1] => A[2]) = (0, 0);
(FO[1] => A[1]) = (0, 0);
(FO[1] => A[0]) = (0, 0);
(FO[0] => A[31]) = (0, 0);
(FO[0] => A[30]) = (0, 0);
(FO[0] => A[29]) = (0, 0);
(FO[0] => A[28]) = (0, 0);
(FO[0] => A[27]) = (0, 0);
(FO[0] => A[26]) = (0, 0);
(FO[0] => A[25]) = (0, 0);
(FO[0] => A[24]) = (0, 0);
(FO[0] => A[23]) = (0, 0);
(FO[0] => A[22]) = (0, 0);
(FO[0] => A[21]) = (0, 0);
(FO[0] => A[20]) = (0, 0);
(FO[0] => A[19]) = (0, 0);
(FO[0] => A[18]) = (0, 0);
(FO[0] => A[17]) = (0, 0);
(FO[0] => A[16]) = (0, 0);
(FO[0] => A[15]) = (0, 0);
(FO[0] => A[14]) = (0, 0);
(FO[0] => A[13]) = (0, 0);
(FO[0] => A[12]) = (0, 0);
(FO[0] => A[11]) = (0, 0);
(FO[0] => A[10]) = (0, 0);
(FO[0] => A[9]) = (0, 0);
(FO[0] => A[8]) = (0, 0);
(FO[0] => A[7]) = (0, 0);
(FO[0] => A[6]) = (0, 0);
(FO[0] => A[5]) = (0, 0);
(FO[0] => A[4]) = (0, 0);
(FO[0] => A[3]) = (0, 0);
(FO[0] => A[2]) = (0, 0);
(FO[0] => A[1]) = (0, 0);
(FO[0] => A[0]) = (0, 0);

// Timing Check
specparam
tCY = (1:1:1),
tCWL = (1:1:1),
tCWH = (1:1:1),
tSA = (1:1:1),
tHA = (1:1:1),
tSI = (1:1:1),
tHI = (1:1:1),
tSW = (1:1:1),
tHW = (1:1:1),
tSDM = (1:1:1),
tHDM = (1:1:1),
tSFO = (1:1:1),
tHFO = (1:1:1),
tSCE = (1:1:1),
tHCE = (1:1:1),
tSLPL = (1:1:1),
tSLPH = (1:1:1),
tSSLP = (1:1:1),
tHSLP = (1:1:1);

`ifdef pre_sdf
$period (negedge CK &&& disable_tchk, tCY);
`endif
$period (posedge CK &&& FOe0andCEe0, tCY, notify_CKWH);
$width (negedge CK, tCWL, 0, notify_CKWL);
$width (posedge CK &&& FOe0andN_CEe0, tCWH, 0, notify_CKWH);
$width (negedge SLP, tSLPL, 0, notify_SLP);
$width (posedge SLP, tSLPH, 0, notify_SLP);
$setuphold (posedge CK &&& FOe0andCEe0, posedge SLP, tSSLP, tHSLP, notify_SLP);
$setuphold (posedge CK &&& FOe0andCEe0, negedge SLP, tSSLP, tHSLP, notify_SLP);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[13], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[13], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[12], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[12], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[11], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[11], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[10], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[10], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[9], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[9], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[8], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[8], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[7], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[7], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[6], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[6], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[5], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[5], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[4], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[4], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[3], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[3], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[2], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[2], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[1], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[1], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, posedge IA[0], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0, negedge IA[0], tSA, tHA, notify_IA_CK_IA);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM31e0, posedge I[31], tSI, tHI, notify_I31_CK_I31);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM31e0, negedge I[31], tSI, tHI, notify_I31_CK_I31);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM30e0, posedge I[30], tSI, tHI, notify_I30_CK_I30);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM30e0, negedge I[30], tSI, tHI, notify_I30_CK_I30);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM29e0, posedge I[29], tSI, tHI, notify_I29_CK_I29);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM29e0, negedge I[29], tSI, tHI, notify_I29_CK_I29);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM28e0, posedge I[28], tSI, tHI, notify_I28_CK_I28);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM28e0, negedge I[28], tSI, tHI, notify_I28_CK_I28);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM27e0, posedge I[27], tSI, tHI, notify_I27_CK_I27);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM27e0, negedge I[27], tSI, tHI, notify_I27_CK_I27);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM26e0, posedge I[26], tSI, tHI, notify_I26_CK_I26);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM26e0, negedge I[26], tSI, tHI, notify_I26_CK_I26);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM25e0, posedge I[25], tSI, tHI, notify_I25_CK_I25);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM25e0, negedge I[25], tSI, tHI, notify_I25_CK_I25);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM24e0, posedge I[24], tSI, tHI, notify_I24_CK_I24);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM24e0, negedge I[24], tSI, tHI, notify_I24_CK_I24);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM23e0, posedge I[23], tSI, tHI, notify_I23_CK_I23);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM23e0, negedge I[23], tSI, tHI, notify_I23_CK_I23);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM22e0, posedge I[22], tSI, tHI, notify_I22_CK_I22);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM22e0, negedge I[22], tSI, tHI, notify_I22_CK_I22);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM21e0, posedge I[21], tSI, tHI, notify_I21_CK_I21);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM21e0, negedge I[21], tSI, tHI, notify_I21_CK_I21);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM20e0, posedge I[20], tSI, tHI, notify_I20_CK_I20);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM20e0, negedge I[20], tSI, tHI, notify_I20_CK_I20);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM19e0, posedge I[19], tSI, tHI, notify_I19_CK_I19);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM19e0, negedge I[19], tSI, tHI, notify_I19_CK_I19);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM18e0, posedge I[18], tSI, tHI, notify_I18_CK_I18);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM18e0, negedge I[18], tSI, tHI, notify_I18_CK_I18);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM17e0, posedge I[17], tSI, tHI, notify_I17_CK_I17);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM17e0, negedge I[17], tSI, tHI, notify_I17_CK_I17);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM16e0, posedge I[16], tSI, tHI, notify_I16_CK_I16);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM16e0, negedge I[16], tSI, tHI, notify_I16_CK_I16);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM15e0, posedge I[15], tSI, tHI, notify_I15_CK_I15);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM15e0, negedge I[15], tSI, tHI, notify_I15_CK_I15);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM14e0, posedge I[14], tSI, tHI, notify_I14_CK_I14);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM14e0, negedge I[14], tSI, tHI, notify_I14_CK_I14);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM13e0, posedge I[13], tSI, tHI, notify_I13_CK_I13);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM13e0, negedge I[13], tSI, tHI, notify_I13_CK_I13);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM12e0, posedge I[12], tSI, tHI, notify_I12_CK_I12);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM12e0, negedge I[12], tSI, tHI, notify_I12_CK_I12);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM11e0, posedge I[11], tSI, tHI, notify_I11_CK_I11);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM11e0, negedge I[11], tSI, tHI, notify_I11_CK_I11);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM10e0, posedge I[10], tSI, tHI, notify_I10_CK_I10);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM10e0, negedge I[10], tSI, tHI, notify_I10_CK_I10);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM9e0, posedge I[9], tSI, tHI, notify_I9_CK_I9);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM9e0, negedge I[9], tSI, tHI, notify_I9_CK_I9);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM8e0, posedge I[8], tSI, tHI, notify_I8_CK_I8);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM8e0, negedge I[8], tSI, tHI, notify_I8_CK_I8);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM7e0, posedge I[7], tSI, tHI, notify_I7_CK_I7);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM7e0, negedge I[7], tSI, tHI, notify_I7_CK_I7);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM6e0, posedge I[6], tSI, tHI, notify_I6_CK_I6);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM6e0, negedge I[6], tSI, tHI, notify_I6_CK_I6);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM5e0, posedge I[5], tSI, tHI, notify_I5_CK_I5);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM5e0, negedge I[5], tSI, tHI, notify_I5_CK_I5);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM4e0, posedge I[4], tSI, tHI, notify_I4_CK_I4);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM4e0, negedge I[4], tSI, tHI, notify_I4_CK_I4);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM3e0, posedge I[3], tSI, tHI, notify_I3_CK_I3);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM3e0, negedge I[3], tSI, tHI, notify_I3_CK_I3);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM2e0, posedge I[2], tSI, tHI, notify_I2_CK_I2);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM2e0, negedge I[2], tSI, tHI, notify_I2_CK_I2);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM1e0, posedge I[1], tSI, tHI, notify_I1_CK_I1);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM1e0, negedge I[1], tSI, tHI, notify_I1_CK_I1);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM0e0, posedge I[0], tSI, tHI, notify_I0_CK_I0);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0andN_DM0e0, negedge I[0], tSI, tHI, notify_I0_CK_I0);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[31], tSDM, tHDM, notify_I31_CK_I31);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[31], tSDM, tHDM, notify_I31_CK_I31);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[30], tSDM, tHDM, notify_I30_CK_I30);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[30], tSDM, tHDM, notify_I30_CK_I30);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[29], tSDM, tHDM, notify_I29_CK_I29);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[29], tSDM, tHDM, notify_I29_CK_I29);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[28], tSDM, tHDM, notify_I28_CK_I28);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[28], tSDM, tHDM, notify_I28_CK_I28);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[27], tSDM, tHDM, notify_I27_CK_I27);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[27], tSDM, tHDM, notify_I27_CK_I27);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[26], tSDM, tHDM, notify_I26_CK_I26);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[26], tSDM, tHDM, notify_I26_CK_I26);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[25], tSDM, tHDM, notify_I25_CK_I25);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[25], tSDM, tHDM, notify_I25_CK_I25);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[24], tSDM, tHDM, notify_I24_CK_I24);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[24], tSDM, tHDM, notify_I24_CK_I24);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[23], tSDM, tHDM, notify_I23_CK_I23);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[23], tSDM, tHDM, notify_I23_CK_I23);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[22], tSDM, tHDM, notify_I22_CK_I22);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[22], tSDM, tHDM, notify_I22_CK_I22);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[21], tSDM, tHDM, notify_I21_CK_I21);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[21], tSDM, tHDM, notify_I21_CK_I21);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[20], tSDM, tHDM, notify_I20_CK_I20);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[20], tSDM, tHDM, notify_I20_CK_I20);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[19], tSDM, tHDM, notify_I19_CK_I19);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[19], tSDM, tHDM, notify_I19_CK_I19);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[18], tSDM, tHDM, notify_I18_CK_I18);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[18], tSDM, tHDM, notify_I18_CK_I18);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[17], tSDM, tHDM, notify_I17_CK_I17);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[17], tSDM, tHDM, notify_I17_CK_I17);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[16], tSDM, tHDM, notify_I16_CK_I16);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[16], tSDM, tHDM, notify_I16_CK_I16);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[15], tSDM, tHDM, notify_I15_CK_I15);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[15], tSDM, tHDM, notify_I15_CK_I15);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[14], tSDM, tHDM, notify_I14_CK_I14);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[14], tSDM, tHDM, notify_I14_CK_I14);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[13], tSDM, tHDM, notify_I13_CK_I13);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[13], tSDM, tHDM, notify_I13_CK_I13);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[12], tSDM, tHDM, notify_I12_CK_I12);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[12], tSDM, tHDM, notify_I12_CK_I12);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[11], tSDM, tHDM, notify_I11_CK_I11);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[11], tSDM, tHDM, notify_I11_CK_I11);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[10], tSDM, tHDM, notify_I10_CK_I10);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[10], tSDM, tHDM, notify_I10_CK_I10);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[9], tSDM, tHDM, notify_I9_CK_I9);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[9], tSDM, tHDM, notify_I9_CK_I9);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[8], tSDM, tHDM, notify_I8_CK_I8);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[8], tSDM, tHDM, notify_I8_CK_I8);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[7], tSDM, tHDM, notify_I7_CK_I7);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[7], tSDM, tHDM, notify_I7_CK_I7);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[6], tSDM, tHDM, notify_I6_CK_I6);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[6], tSDM, tHDM, notify_I6_CK_I6);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[5], tSDM, tHDM, notify_I5_CK_I5);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[5], tSDM, tHDM, notify_I5_CK_I5);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[4], tSDM, tHDM, notify_I4_CK_I4);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[4], tSDM, tHDM, notify_I4_CK_I4);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[3], tSDM, tHDM, notify_I3_CK_I3);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[3], tSDM, tHDM, notify_I3_CK_I3);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[2], tSDM, tHDM, notify_I2_CK_I2);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[2], tSDM, tHDM, notify_I2_CK_I2);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[1], tSDM, tHDM, notify_I1_CK_I1);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[1], tSDM, tHDM, notify_I1_CK_I1);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, posedge DM[0], tSDM, tHDM, notify_I0_CK_I0);
$setuphold (posedge CK &&& FOe0andCEe0andWEe0, negedge DM[0], tSDM, tHDM, notify_I0_CK_I0);
$setuphold (posedge CK &&& FOe0andCEe0, posedge WE, tSW, tHW, notify_WE_CK_WE);
$setuphold (posedge CK &&& FOe0andCEe0, negedge WE, tSW, tHW, notify_WE_CK_WE);
$setuphold (posedge CK &&& CEe0, posedge FO[5], tSFO, tHFO, notify_FO_CK_FO);
$setuphold (posedge CK &&& CEe0, negedge FO[5], tSFO, tHFO, notify_FO_CK_FO);
$setuphold (posedge CK &&& CEe0, posedge FO[4], tSFO, tHFO, notify_FO_CK_FO);
$setuphold (posedge CK &&& CEe0, negedge FO[4], tSFO, tHFO, notify_FO_CK_FO);
$setuphold (posedge CK &&& CEe0, posedge FO[3], tSFO, tHFO, notify_FO_CK_FO);
$setuphold (posedge CK &&& CEe0, negedge FO[3], tSFO, tHFO, notify_FO_CK_FO);
$setuphold (posedge CK &&& CEe0, posedge FO[2], tSFO, tHFO, notify_FO_CK_FO);
$setuphold (posedge CK &&& CEe0, negedge FO[2], tSFO, tHFO, notify_FO_CK_FO);
$setuphold (posedge CK &&& CEe0, posedge FO[1], tSFO, tHFO, notify_FO_CK_FO);
$setuphold (posedge CK &&& CEe0, negedge FO[1], tSFO, tHFO, notify_FO_CK_FO);
$setuphold (posedge CK &&& CEe0, posedge FO[0], tSFO, tHFO, notify_FO_CK_FO);
$setuphold (posedge CK &&& CEe0, negedge FO[0], tSFO, tHFO, notify_FO_CK_FO);
$setuphold (posedge CK, posedge CE, tSCE, tHCE, notify_CKWH);
$setuphold (posedge CK, negedge CE, tSCE, tHCE, notify_CKWH);
`endif

`ifdef finfo
specparam
AREA$ = 1.15363e+07;
`endif

endspecify

// 1RW PW RAM Core

reg [`BIT_RAM16384X32 - 1 : 0] Mem[`WORD_RAM16384X32 - 1 : 0];
reg [`BIT_RAM16384X32 - 1 : 0] Reg_A, Reg_Mem;
`ifdef FAST_FUNC
`else
reg [`ADDRESS_RAM16384X32 - 1 : 0] Pre_IA;
`endif
reg [`BITNUM_RAM16384X32 : 0] Reg_Bit;
reg [`ADDRESS_RAM16384X32 : 0] Address;
reg [1 : 0] Pre_CE;
reg Flag_Msg_FO;
reg
`ifdef FAST_FUNC
`else
 Pre_WE,
`endif
 Pre_CK, Flag_Mem_X, N_CE;
wire Flag_FO;

initial begin
	`ifdef mem_load
	$display ("\t======================================");
	$display ("\t=    Don't use this option           =");
	$display ("\t=          ( +define+mem_load )      =");
	$display ("\t=    in Final Simulation.            =");
	$display ("\t======================================\n");
	$readmemh ("RAM16384X32.pat_ve", Mem, 0, `WORD_RAM16384X32 - 1);
	`endif
	Flag_Mem_X = 1;
	Flag_Msg_FO = 0;
end

initial begin
        wait  (Buf_CK == 1 && Pre_CK == 0 && Buf_CE == 0) begin
                if (Buf_SLP === 1'bx) begin
                        `ifdef no_macro_msg
                        `else
                        $display("\tError! Invalid CK Active on SLEEP Mode\n\tin %m\n\t(edge[01] CK && SLP: %0t);\n", $time);
                        `endif
                        Reg_A = `BIT_RAM16384X32'bx;
                        if (Flag_Mem_X == 1) begin
                                Mem_X;
                        end
                end
        end
end

`ifdef FAST_FUNC
`else

always @(notify_SLP) begin
#0      Reg_A = `BIT_RAM16384X32'bx;
        if (Flag_Mem_X == 1) begin
                Mem_X;
        end
end

always @(notify_CKWL) begin
#0	if (!(Buf_CE === 1 && Pre_CE[1] === 1)) begin
		Reg_A = `BIT_RAM16384X32'bx;
		if (Flag_Mem_X == 1) begin
			Mem_X;
		end
	end
end

always @(notify_CKWH) begin
#0	Reg_A = `BIT_RAM16384X32'bx;
	if (Flag_Mem_X == 1) begin
		Mem_X;
	end
end

always @(notify_FO_CK_FO) begin
#0	Reg_A = `BIT_RAM16384X32'bx;
	if (Flag_Mem_X == 1) begin
		Mem_X;
	end
end

always @(notify_WE_CK_WE) begin
#0	Reg_A = `BIT_RAM16384X32'bx;
	Mem[Pre_IA] = `BIT_RAM16384X32'bx;
end

always @(notify_IA_CK_IA) begin
#0	if (Pre_WE !== 0) begin
		Reg_A = `BIT_RAM16384X32'bx;
	end
	if (Flag_Mem_X == 1) begin
		Mem_X;
	end
end

always @(notify_I31_CK_I31) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[31] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I30_CK_I30) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[30] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I29_CK_I29) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[29] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I28_CK_I28) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[28] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I27_CK_I27) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[27] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I26_CK_I26) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[26] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I25_CK_I25) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[25] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I24_CK_I24) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[24] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I23_CK_I23) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[23] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I22_CK_I22) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[22] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I21_CK_I21) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[21] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I20_CK_I20) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[20] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I19_CK_I19) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[19] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I18_CK_I18) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[18] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I17_CK_I17) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[17] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I16_CK_I16) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[16] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I15_CK_I15) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[15] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I14_CK_I14) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[14] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I13_CK_I13) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[13] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I12_CK_I12) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[12] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I11_CK_I11) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[11] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I10_CK_I10) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[10] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I9_CK_I9) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[9] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I8_CK_I8) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[8] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I7_CK_I7) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[7] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I6_CK_I6) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[6] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I5_CK_I5) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[5] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I4_CK_I4) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[4] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I3_CK_I3) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[3] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I2_CK_I2) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[2] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I1_CK_I1) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[1] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

always @(notify_I0_CK_I0) begin
#0	Reg_Mem = Mem[Pre_IA];
	Reg_Mem[0] = 1'bx;
	Mem[Pre_IA] = Reg_Mem;
end

`endif

assign
`ifdef FAST_FUNC
`ifdef same_time_check
	FOe0 = ~Flag_FO,
`endif
`else
	N_CEe0 = ~N_CE,
	FOe0 = ~Flag_FO,
`endif
	Flag_FO = |Buf_FO ,
	Buf_A = Reg_A;

////////  FO Operation ////////////////////////////////////////////////////////////////
always @(Flag_FO) begin
#0	if (Flag_FO == 0 && Flag_Msg_FO == 0) begin
	`ifdef no_macro_msg
	`else
		$display("\tFuse Signal Fixed!\n\tin %m\n\t(FO: %0t);\n", $time);
	`endif
		Flag_Msg_FO = 1;
	end
end

////////  SLP Operation ////////////////////////////////////////////////////////////////
always @(Buf_SLP) begin
	if (Buf_SLP == 0) begin
		if (!(Buf_CK === 1'b0 || (N_CE === 1'b1 && Buf_CE === 1'b1 ))) begin
	       	`ifdef no_macro_msg
	       	`else
	       		$display("\tError! SLEEP Mode Entry Violation\n\tin %m\n\t(SLP: %0t);\n", $time);
	       	`endif
	               	Reg_A =  `BIT_RAM16384X32'bx;
               		if (Flag_Mem_X == 1) begin
                		Mem_X;
	       		end
		end
	end
        else if (Buf_SLP === 1'bx) begin
	`ifdef no_macro_msg
	`else
		$display("\tError! Invalid SLP Signal Detected\n\tin %m\n\t(SLP: %0t);\n", $time);
       	`endif
                Reg_A =  `BIT_RAM16384X32'bx;
       	        if (Flag_Mem_X == 1) begin
			Mem_X;
		end
        end
end

////////  CE Operation ////////////////////////////////////////////////////////////////
always @(Buf_CE) begin
	if (Buf_CK == 0) begin
		N_CE = Buf_CE;
	end
	if (Buf_CK === 1'bx && Buf_CE !== 1) begin
		if (Buf_SLP == 0) begin
		`ifdef no_macro_msg
		`else
			$display("\tError! Invalid CK Active on SLEEP Mode\n\tin %m\n\t(CK: %0t);\n", $time);
		`endif
		end
	`ifdef no_macro_msg
	`else
		$display("\tError! Invalid Clock Signal Detected\n\tin %m\n\t(CK: %0t);\n", $time);
	`endif
		Reg_A = `BIT_RAM16384X32'bx;
		if (Flag_Mem_X == 1) begin
			Mem_X;
		end
	end
end

////////  CK Operation ////////////////////////////////////////////////////////////////
always @(Buf_CK) begin
#0	if (Buf_CK == 1 && Pre_CK == 0) begin
		if (Buf_CE == 0) begin
			if (Flag_FO == 0) begin
				if (Buf_SLP == 1) begin
					if (^Buf_IA !== 1'bx) begin
						if (Buf_WE == 0) begin
							if (Buf_DM == 0) begin
								Mem[Buf_IA] = Buf_I;
								Flag_Mem_X = 1;
							end
							else if (&Buf_DM !== 1) begin
								Reg_Mem = Mem[Buf_IA];
								for (Reg_Bit = 0; Reg_Bit < `BIT_RAM16384X32; Reg_Bit = Reg_Bit + 1) begin
									if (Buf_DM[Reg_Bit] == 0) begin
										Reg_Mem[Reg_Bit] = Buf_I[Reg_Bit];
									end
									else if (Buf_DM[Reg_Bit] === 1'bx) begin
									`ifdef no_macro_msg
									`else
										$display("\tError! Invalid Data Write Mask Signal Detected\n\tin %m\n\t(edge[01] CK && DM[%0d]: %0t);\n", Reg_Bit, $time);
									`endif
										Reg_Mem[Reg_Bit] = 1'bx;
									end
								end
								Mem[Buf_IA] = Reg_Mem;
								Flag_Mem_X = 1;
							end
						end
						else if (Buf_WE == 1) begin
							Reg_A = Mem[Buf_IA];
						end
						else begin
						`ifdef no_macro_msg
						`else
							$display("\tError! Invalid Write Enable Signal Detected\n\tin %m\n\t(edge[01] CK && WE: %0t);\n", $time);
						`endif
							Mem[Buf_IA] = `BIT_RAM16384X32'bx;
							Reg_A = `BIT_RAM16384X32'bx;
						end
					`ifdef FAST_FUNC
					`else
						Pre_WE = Buf_WE;
					`endif
					end
					else begin
					`ifdef no_macro_msg
					`else
						$display("\tError! Invalid Address Signal Detected\n\tin %m\n\t(edge[01] CK && IA: %0t);\n", $time);
					`endif
						if (Buf_WE !== 0) begin
							Reg_A = `BIT_RAM16384X32'bx;
						end
						if (Flag_Mem_X == 1) begin
							Mem_X;
						end
					end
				`ifdef FAST_FUNC
				`else
					Pre_IA = Buf_IA;
				`endif
				end
				else if (Buf_SLP == 0) begin
				`ifdef no_macro_msg
				`else
					$display("\tError! Invalid CK Active on SLEEP Mode\n\tin %m\n\t(edge[01] CK && SLP: %0t);\n", $time);
				`endif
					Reg_A = `BIT_RAM16384X32'bx;
					if (Flag_Mem_X == 1) begin
						Mem_X;
					end        
				end
			end
			else begin
				if (Flag_Msg_FO == 1) begin
				`ifdef no_macro_msg
				`else
					$display("\tError! Invalid Fuse Signal Detected\n\tin %m\n\t(FO: %0t);\n", $time);
				`endif
					Reg_A = `BIT_RAM16384X32'bx;
					if (Flag_Mem_X == 1) begin
						Mem_X;
					end
					Flag_Msg_FO = 0;
				end
			end
		end
		else if (Buf_CE === 1'bx) begin
			if (Buf_SLP == 0) begin
			`ifdef no_macro_msg
			`else
				$display("\tError! Invalid CK Active on SLEEP Mode\n\tin %m\n\t(edge[01] CK && SLP: %0t);\n", $time);
			`endif
			end
		`ifdef no_macro_msg
		`else
			$display("\tError! Invalid Chip Enable Signal Detected\n\tin %m\n\t(edge[01] CK && CE: %0t);\n", $time);
		`endif
			Reg_A = `BIT_RAM16384X32'bx;
			if (Flag_Mem_X == 1) begin
				Mem_X;
			end
		`ifdef FAST_FUNC
		`else
			Pre_IA = `ADDRESS_RAM16384X32'bx;
		`endif
		end
		Pre_CE = {Pre_CE[0], Buf_CE};
	end
	else if (Buf_CK == 1 && Pre_CK === 1'bx) begin
		Pre_CE = {Pre_CE[0], Buf_CE};
	end
	else if (Buf_CK == 0) begin
		N_CE = Buf_CE;
	end
	else if (Buf_CK === 1'bx) begin
		if (!(Buf_CE === 1 && (Pre_CE[0] === 1 || Pre_CK === 0))) begin
			if (Buf_SLP == 0) begin
			`ifdef no_macro_msg
			`else
				$display("\tError! Invalid CK Active on SLEEP Mode\n\tin %m\n\t(edge[01] CK && SLP: %0t);\n", $time);
			`endif
			end
		`ifdef no_macro_msg
		`else
			$display("\tError! Invalid Clock Signal Detected\n\tin %m\n\t(CK: %0t);\n", $time);
		`endif
			Reg_A = `BIT_RAM16384X32'bx;
			if (Flag_Mem_X == 1) begin
				Mem_X;
			end
		`ifdef FAST_FUNC
		`else
			Pre_IA = `ADDRESS_RAM16384X32'bx;
		`endif
		end
		if (Pre_CK == 0) begin
			Pre_CE = {Pre_CE[0], Buf_CE};
		end
	end
	Pre_CK = Buf_CK;
end

task Mem_X;
begin
	for (Address = 0; Address < `WORD_RAM16384X32; Address = Address + 1) begin
		Mem[Address] = `BIT_RAM16384X32'bx;
	end
	Flag_Mem_X = 0;
end
endtask

endmodule
`ifdef verifault
	`nosuppress_faults
	`disable_portfaults
`endif
`endcelldefine
