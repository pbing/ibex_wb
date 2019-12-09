// **************************************************************
// ***                                                        ***
// *** 1RW RAM <Redundancy external FUSE> <Sleep>             ***
// *** TetraMAX Library                                       ***
// *** Copyright (c) MIE FUJITSU SEMICONDUCTOR Limited, 2015  ***
// *** All Rights Reserved. Licensed Library.                 ***
// ***                                                        ***
// **************************************************************
// 1RW-RAM [Redundancy # External FUSE][LargeScale][Sleep]<Standard>
// Verilog HDL TetraMAX Model.
//						LIB-cs251.common.bpf-0010
//						LIB-cs251.rpsqlpa.bpf-0001
// Rev. 0001    Jun 10,2015

`resetall
`timescale 1ps/1ps
`celldefine

module RAM16384X32 (A,
 I, IA, DM, CK, CE, WE, FO, SLP);

// `define BIT_RAM16384X32 32 // bit_disper
// `define WORD_RAM16384X32 16384 // word_disper
// `define LOG_WORD_RAM16384X32 16384 // logical word
// `define ADDRESS_RAM16384X32 14 // addres_num

input [31:0] I, DM;
input [13:0] IA;
input [5:0] FO;
input CK, CE, WE, SLP;
output [31:0] A;

or (iwen, CE, WE, ~SLP);
and (ren, ~CE, WE, SLP);

RAM16384X32_core i31 (A[31], I[31], IA, DM[31], CK, iwen, ren);
RAM16384X32_core i30 (A[30], I[30], IA, DM[30], CK, iwen, ren);
RAM16384X32_core i29 (A[29], I[29], IA, DM[29], CK, iwen, ren);
RAM16384X32_core i28 (A[28], I[28], IA, DM[28], CK, iwen, ren);
RAM16384X32_core i27 (A[27], I[27], IA, DM[27], CK, iwen, ren);
RAM16384X32_core i26 (A[26], I[26], IA, DM[26], CK, iwen, ren);
RAM16384X32_core i25 (A[25], I[25], IA, DM[25], CK, iwen, ren);
RAM16384X32_core i24 (A[24], I[24], IA, DM[24], CK, iwen, ren);
RAM16384X32_core i23 (A[23], I[23], IA, DM[23], CK, iwen, ren);
RAM16384X32_core i22 (A[22], I[22], IA, DM[22], CK, iwen, ren);
RAM16384X32_core i21 (A[21], I[21], IA, DM[21], CK, iwen, ren);
RAM16384X32_core i20 (A[20], I[20], IA, DM[20], CK, iwen, ren);
RAM16384X32_core i19 (A[19], I[19], IA, DM[19], CK, iwen, ren);
RAM16384X32_core i18 (A[18], I[18], IA, DM[18], CK, iwen, ren);
RAM16384X32_core i17 (A[17], I[17], IA, DM[17], CK, iwen, ren);
RAM16384X32_core i16 (A[16], I[16], IA, DM[16], CK, iwen, ren);
RAM16384X32_core i15 (A[15], I[15], IA, DM[15], CK, iwen, ren);
RAM16384X32_core i14 (A[14], I[14], IA, DM[14], CK, iwen, ren);
RAM16384X32_core i13 (A[13], I[13], IA, DM[13], CK, iwen, ren);
RAM16384X32_core i12 (A[12], I[12], IA, DM[12], CK, iwen, ren);
RAM16384X32_core i11 (A[11], I[11], IA, DM[11], CK, iwen, ren);
RAM16384X32_core i10 (A[10], I[10], IA, DM[10], CK, iwen, ren);
RAM16384X32_core i9 (A[9], I[9], IA, DM[9], CK, iwen, ren);
RAM16384X32_core i8 (A[8], I[8], IA, DM[8], CK, iwen, ren);
RAM16384X32_core i7 (A[7], I[7], IA, DM[7], CK, iwen, ren);
RAM16384X32_core i6 (A[6], I[6], IA, DM[6], CK, iwen, ren);
RAM16384X32_core i5 (A[5], I[5], IA, DM[5], CK, iwen, ren);
RAM16384X32_core i4 (A[4], I[4], IA, DM[4], CK, iwen, ren);
RAM16384X32_core i3 (A[3], I[3], IA, DM[3], CK, iwen, ren);
RAM16384X32_core i2 (A[2], I[2], IA, DM[2], CK, iwen, ren);
RAM16384X32_core i1 (A[1], I[1], IA, DM[1], CK, iwen, ren);
RAM16384X32_core i0 (A[0], I[0], IA, DM[0], CK, iwen, ren);
endmodule
`endcelldefine

`celldefine
module RAM16384X32_core (A,
 I, IA, DM, CK, iwen, ren);

input I, DM;
input [13:0] IA;
input CK, iwen, ren;
output A;

// 1RW PW RAM Core

reg [0:0] Mem[16383:0];
reg A;

nor (wen, iwen, DM);

always @(posedge CK) if (wen) begin
	Mem[IA] = I;
end

always @(posedge CK) if (ren) begin
	A = Mem[IA];
end

endmodule
`endcelldefine
