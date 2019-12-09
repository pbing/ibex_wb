// Cadence(R) Modus(TM) DFT Software Solution, Version 18.12-s002_1, built Dec 04 2018 (linux26_64)
// build_memory_model version: March 25, 2013
// Intended for use with Modus and Diagnostics
// Cadence Design Systems, Inc.
// Created on: Fri Dec  6 08:22:13 CET 2019
 
`celldefine
  (* ET_MEM_VERSION="6.2.3" *)
  (* ET_MEM_LEVEL="WRAPPER" *)
module RAM16384X32 (A ,I ,IA ,DM ,CK ,CE ,WE ,FO ,SLP );

// Input/Output pin declarations
output  [31:0] A ;
input  [31:0] I ;
input  [13:0] IA ;
input  [31:0] DM ;
  (* K_FLAG="+SC" *)
  (* CT_TEST="+SC" *)
input  CK ;
input  CE ;
input  WE ;
  (* K_FLAG="-TI" *)
  (* CT_TEST="-TI" *)
input  [5:0] FO ;
  (* K_FLAG="+TI" *)
  (* CT_TEST="+TI" *)
input  SLP ;
 
// create an instance of a buffer block for each input / output 
wire [0:31] buf_A;
__buf_bus_32 ibuf_A (A, buf_A);
wire [0:31] buf_I;
__buf_bus_32 ibuf_I (buf_I, I);
wire [0:13] buf_IA;
__buf_bus_14 ibuf_IA (buf_IA, IA);
wire [0:31] buf_DM;
__buf_bus_32 ibuf_DM (buf_DM, DM);
wire buf_CK;
__buf_bus_1 ibuf_CK (buf_CK, CK);
wire buf_CE;
__buf_bus_1 ibuf_CE (buf_CE, CE);
wire buf_WE;
__buf_bus_1 ibuf_WE (buf_WE, WE);
wire [0:5] buf_FO;
__buf_bus_6 ibuf_FO (buf_FO, FO);
wire buf_SLP;
__buf_bus_1 ibuf_SLP (buf_SLP, SLP);
 
// Instantiate the internal layer 
__RAM16384X32 i1(buf_A ,buf_I ,buf_IA ,buf_DM ,buf_CK ,buf_CE ,buf_WE ,buf_FO ,buf_SLP );
endmodule
`endcelldefine
 
 
// ************************************************
// buffer / TSD bus
// ************************************************
 
`celldefine
module __buf_bus_32 (out, in);
output [0:31] out;
input  [0:31] in;
buf i_0 (out[0], in[0]);
buf i_1 (out[1], in[1]);
buf i_2 (out[2], in[2]);
buf i_3 (out[3], in[3]);
buf i_4 (out[4], in[4]);
buf i_5 (out[5], in[5]);
buf i_6 (out[6], in[6]);
buf i_7 (out[7], in[7]);
buf i_8 (out[8], in[8]);
buf i_9 (out[9], in[9]);
buf i_10 (out[10], in[10]);
buf i_11 (out[11], in[11]);
buf i_12 (out[12], in[12]);
buf i_13 (out[13], in[13]);
buf i_14 (out[14], in[14]);
buf i_15 (out[15], in[15]);
buf i_16 (out[16], in[16]);
buf i_17 (out[17], in[17]);
buf i_18 (out[18], in[18]);
buf i_19 (out[19], in[19]);
buf i_20 (out[20], in[20]);
buf i_21 (out[21], in[21]);
buf i_22 (out[22], in[22]);
buf i_23 (out[23], in[23]);
buf i_24 (out[24], in[24]);
buf i_25 (out[25], in[25]);
buf i_26 (out[26], in[26]);
buf i_27 (out[27], in[27]);
buf i_28 (out[28], in[28]);
buf i_29 (out[29], in[29]);
buf i_30 (out[30], in[30]);
buf i_31 (out[31], in[31]);
endmodule
`endcelldefine


 
// ************************************************
// buffer / TSD bus
// ************************************************
 
`celldefine
module __buf_bus_14 (out, in);
output [0:13] out;
input  [0:13] in;
buf i_0 (out[0], in[0]);
buf i_1 (out[1], in[1]);
buf i_2 (out[2], in[2]);
buf i_3 (out[3], in[3]);
buf i_4 (out[4], in[4]);
buf i_5 (out[5], in[5]);
buf i_6 (out[6], in[6]);
buf i_7 (out[7], in[7]);
buf i_8 (out[8], in[8]);
buf i_9 (out[9], in[9]);
buf i_10 (out[10], in[10]);
buf i_11 (out[11], in[11]);
buf i_12 (out[12], in[12]);
buf i_13 (out[13], in[13]);
endmodule
`endcelldefine


 
// ************************************************
// buffer / TSD bus
// ************************************************
 
`celldefine
module __buf_bus_1 (out, in);
output out;
input  in;
buf i_0 (out, in);
endmodule
`endcelldefine


 
// ************************************************
// buffer / TSD bus
// ************************************************
 
`celldefine
module __buf_bus_6 (out, in);
output [0:5] out;
input  [0:5] in;
buf i_0 (out[0], in[0]);
buf i_1 (out[1], in[1]);
buf i_2 (out[2], in[2]);
buf i_3 (out[3], in[3]);
buf i_4 (out[4], in[4]);
buf i_5 (out[5], in[5]);
endmodule
`endcelldefine


`celldefine
  (* ET_MEM_VERSION="6.2.3" *)
  (* ET_MEM_LEVEL="CORE" *)
module __RAM16384X32 (A ,I ,IA ,DM ,CK ,CE ,WE ,FO ,SLP );

// Input/Output pin declarations
output  [31:0] A ;
input  [31:0] I ;
input  [13:0] IA ;
input  [31:0] DM ;
  (* K_FLAG="+SC" *)
  (* CT_TEST="+SC" *)
input  CK ;
input  CE ;
input  WE ;
  (* K_FLAG="-TI" *)
  (* CT_TEST="-TI" *)
input  [5:0] FO ;
  (* K_FLAG="+TI" *)
  (* CT_TEST="+TI" *)
input  SLP ;
 
wire vdd = 1'b1;
wire gnd = 1'b0;

// Assign each input function to a signal for ease of reference
wire [13:0] addrPins0;
assign addrPins0[13:0] = IA[13:0];
wire [31:0] dinPins0;
assign dinPins0[31:0] = I[31:0];
wire [0:0] renPin0;
assign renPin0[0:0] = ~CE & WE & SLP;
wire rclkPin0;
assign rclkPin0 = CK;
wire corruptenable1;
wire [31:0] wenPin0;
assign wenPin0[31:0] = { {32{~CE}} & {32{~WE}} & {32{SLP}} & ~DM };
wire wclkPin0;
assign wclkPin0 = CK;
wire [31:0] dinPins1;
assign dinPins1[31:0] = 32'bX;
wire [0:31] wenPin1;
assign wenPin1[0:31] = { ~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1,~CE & WE & SLP & corruptenable1 };
wire wclkPin1;
assign wclkPin1 = CK;
not (WCLK_not0,wclkPin0);
wire latch_wenPin00;
LATCH_1 wen_capture00 (latch_wenPin00, wenPin0[0],WCLK_not0);
wire latch_wclk_and_wen00;
and (latch_wclk_and_wen00,wclkPin0,latch_wenPin00);
wire latch_wenPin01;
LATCH_1 wen_capture01 (latch_wenPin01, wenPin0[1],WCLK_not0);
wire latch_wclk_and_wen01;
and (latch_wclk_and_wen01,wclkPin0,latch_wenPin01);
wire latch_wenPin02;
LATCH_1 wen_capture02 (latch_wenPin02, wenPin0[2],WCLK_not0);
wire latch_wclk_and_wen02;
and (latch_wclk_and_wen02,wclkPin0,latch_wenPin02);
wire latch_wenPin03;
LATCH_1 wen_capture03 (latch_wenPin03, wenPin0[3],WCLK_not0);
wire latch_wclk_and_wen03;
and (latch_wclk_and_wen03,wclkPin0,latch_wenPin03);
wire latch_wenPin04;
LATCH_1 wen_capture04 (latch_wenPin04, wenPin0[4],WCLK_not0);
wire latch_wclk_and_wen04;
and (latch_wclk_and_wen04,wclkPin0,latch_wenPin04);
wire latch_wenPin05;
LATCH_1 wen_capture05 (latch_wenPin05, wenPin0[5],WCLK_not0);
wire latch_wclk_and_wen05;
and (latch_wclk_and_wen05,wclkPin0,latch_wenPin05);
wire latch_wenPin06;
LATCH_1 wen_capture06 (latch_wenPin06, wenPin0[6],WCLK_not0);
wire latch_wclk_and_wen06;
and (latch_wclk_and_wen06,wclkPin0,latch_wenPin06);
wire latch_wenPin07;
LATCH_1 wen_capture07 (latch_wenPin07, wenPin0[7],WCLK_not0);
wire latch_wclk_and_wen07;
and (latch_wclk_and_wen07,wclkPin0,latch_wenPin07);
wire latch_wenPin08;
LATCH_1 wen_capture08 (latch_wenPin08, wenPin0[8],WCLK_not0);
wire latch_wclk_and_wen08;
and (latch_wclk_and_wen08,wclkPin0,latch_wenPin08);
wire latch_wenPin09;
LATCH_1 wen_capture09 (latch_wenPin09, wenPin0[9],WCLK_not0);
wire latch_wclk_and_wen09;
and (latch_wclk_and_wen09,wclkPin0,latch_wenPin09);
wire latch_wenPin010;
LATCH_1 wen_capture010 (latch_wenPin010, wenPin0[10],WCLK_not0);
wire latch_wclk_and_wen010;
and (latch_wclk_and_wen010,wclkPin0,latch_wenPin010);
wire latch_wenPin011;
LATCH_1 wen_capture011 (latch_wenPin011, wenPin0[11],WCLK_not0);
wire latch_wclk_and_wen011;
and (latch_wclk_and_wen011,wclkPin0,latch_wenPin011);
wire latch_wenPin012;
LATCH_1 wen_capture012 (latch_wenPin012, wenPin0[12],WCLK_not0);
wire latch_wclk_and_wen012;
and (latch_wclk_and_wen012,wclkPin0,latch_wenPin012);
wire latch_wenPin013;
LATCH_1 wen_capture013 (latch_wenPin013, wenPin0[13],WCLK_not0);
wire latch_wclk_and_wen013;
and (latch_wclk_and_wen013,wclkPin0,latch_wenPin013);
wire latch_wenPin014;
LATCH_1 wen_capture014 (latch_wenPin014, wenPin0[14],WCLK_not0);
wire latch_wclk_and_wen014;
and (latch_wclk_and_wen014,wclkPin0,latch_wenPin014);
wire latch_wenPin015;
LATCH_1 wen_capture015 (latch_wenPin015, wenPin0[15],WCLK_not0);
wire latch_wclk_and_wen015;
and (latch_wclk_and_wen015,wclkPin0,latch_wenPin015);
wire latch_wenPin016;
LATCH_1 wen_capture016 (latch_wenPin016, wenPin0[16],WCLK_not0);
wire latch_wclk_and_wen016;
and (latch_wclk_and_wen016,wclkPin0,latch_wenPin016);
wire latch_wenPin017;
LATCH_1 wen_capture017 (latch_wenPin017, wenPin0[17],WCLK_not0);
wire latch_wclk_and_wen017;
and (latch_wclk_and_wen017,wclkPin0,latch_wenPin017);
wire latch_wenPin018;
LATCH_1 wen_capture018 (latch_wenPin018, wenPin0[18],WCLK_not0);
wire latch_wclk_and_wen018;
and (latch_wclk_and_wen018,wclkPin0,latch_wenPin018);
wire latch_wenPin019;
LATCH_1 wen_capture019 (latch_wenPin019, wenPin0[19],WCLK_not0);
wire latch_wclk_and_wen019;
and (latch_wclk_and_wen019,wclkPin0,latch_wenPin019);
wire latch_wenPin020;
LATCH_1 wen_capture020 (latch_wenPin020, wenPin0[20],WCLK_not0);
wire latch_wclk_and_wen020;
and (latch_wclk_and_wen020,wclkPin0,latch_wenPin020);
wire latch_wenPin021;
LATCH_1 wen_capture021 (latch_wenPin021, wenPin0[21],WCLK_not0);
wire latch_wclk_and_wen021;
and (latch_wclk_and_wen021,wclkPin0,latch_wenPin021);
wire latch_wenPin022;
LATCH_1 wen_capture022 (latch_wenPin022, wenPin0[22],WCLK_not0);
wire latch_wclk_and_wen022;
and (latch_wclk_and_wen022,wclkPin0,latch_wenPin022);
wire latch_wenPin023;
LATCH_1 wen_capture023 (latch_wenPin023, wenPin0[23],WCLK_not0);
wire latch_wclk_and_wen023;
and (latch_wclk_and_wen023,wclkPin0,latch_wenPin023);
wire latch_wenPin024;
LATCH_1 wen_capture024 (latch_wenPin024, wenPin0[24],WCLK_not0);
wire latch_wclk_and_wen024;
and (latch_wclk_and_wen024,wclkPin0,latch_wenPin024);
wire latch_wenPin025;
LATCH_1 wen_capture025 (latch_wenPin025, wenPin0[25],WCLK_not0);
wire latch_wclk_and_wen025;
and (latch_wclk_and_wen025,wclkPin0,latch_wenPin025);
wire latch_wenPin026;
LATCH_1 wen_capture026 (latch_wenPin026, wenPin0[26],WCLK_not0);
wire latch_wclk_and_wen026;
and (latch_wclk_and_wen026,wclkPin0,latch_wenPin026);
wire latch_wenPin027;
LATCH_1 wen_capture027 (latch_wenPin027, wenPin0[27],WCLK_not0);
wire latch_wclk_and_wen027;
and (latch_wclk_and_wen027,wclkPin0,latch_wenPin027);
wire latch_wenPin028;
LATCH_1 wen_capture028 (latch_wenPin028, wenPin0[28],WCLK_not0);
wire latch_wclk_and_wen028;
and (latch_wclk_and_wen028,wclkPin0,latch_wenPin028);
wire latch_wenPin029;
LATCH_1 wen_capture029 (latch_wenPin029, wenPin0[29],WCLK_not0);
wire latch_wclk_and_wen029;
and (latch_wclk_and_wen029,wclkPin0,latch_wenPin029);
wire latch_wenPin030;
LATCH_1 wen_capture030 (latch_wenPin030, wenPin0[30],WCLK_not0);
wire latch_wclk_and_wen030;
and (latch_wclk_and_wen030,wclkPin0,latch_wenPin030);
wire latch_wenPin031;
LATCH_1 wen_capture031 (latch_wenPin031, wenPin0[31],WCLK_not0);
wire latch_wclk_and_wen031;
and (latch_wclk_and_wen031,wclkPin0,latch_wenPin031);

// Add latch to capture RAM/ROM data inputs on clock edge
LATCH_1 data_capture_P01D000 (latch_P01D000,dinPins0[0],WCLK_not0);
LATCH_1 data_capture_P01D001 (latch_P01D001,dinPins0[1],WCLK_not0);
LATCH_1 data_capture_P01D002 (latch_P01D002,dinPins0[2],WCLK_not0);
LATCH_1 data_capture_P01D003 (latch_P01D003,dinPins0[3],WCLK_not0);
LATCH_1 data_capture_P01D004 (latch_P01D004,dinPins0[4],WCLK_not0);
LATCH_1 data_capture_P01D005 (latch_P01D005,dinPins0[5],WCLK_not0);
LATCH_1 data_capture_P01D006 (latch_P01D006,dinPins0[6],WCLK_not0);
LATCH_1 data_capture_P01D007 (latch_P01D007,dinPins0[7],WCLK_not0);
LATCH_1 data_capture_P01D008 (latch_P01D008,dinPins0[8],WCLK_not0);
LATCH_1 data_capture_P01D009 (latch_P01D009,dinPins0[9],WCLK_not0);
LATCH_1 data_capture_P01D010 (latch_P01D010,dinPins0[10],WCLK_not0);
LATCH_1 data_capture_P01D011 (latch_P01D011,dinPins0[11],WCLK_not0);
LATCH_1 data_capture_P01D012 (latch_P01D012,dinPins0[12],WCLK_not0);
LATCH_1 data_capture_P01D013 (latch_P01D013,dinPins0[13],WCLK_not0);
LATCH_1 data_capture_P01D014 (latch_P01D014,dinPins0[14],WCLK_not0);
LATCH_1 data_capture_P01D015 (latch_P01D015,dinPins0[15],WCLK_not0);
LATCH_1 data_capture_P01D016 (latch_P01D016,dinPins0[16],WCLK_not0);
LATCH_1 data_capture_P01D017 (latch_P01D017,dinPins0[17],WCLK_not0);
LATCH_1 data_capture_P01D018 (latch_P01D018,dinPins0[18],WCLK_not0);
LATCH_1 data_capture_P01D019 (latch_P01D019,dinPins0[19],WCLK_not0);
LATCH_1 data_capture_P01D020 (latch_P01D020,dinPins0[20],WCLK_not0);
LATCH_1 data_capture_P01D021 (latch_P01D021,dinPins0[21],WCLK_not0);
LATCH_1 data_capture_P01D022 (latch_P01D022,dinPins0[22],WCLK_not0);
LATCH_1 data_capture_P01D023 (latch_P01D023,dinPins0[23],WCLK_not0);
LATCH_1 data_capture_P01D024 (latch_P01D024,dinPins0[24],WCLK_not0);
LATCH_1 data_capture_P01D025 (latch_P01D025,dinPins0[25],WCLK_not0);
LATCH_1 data_capture_P01D026 (latch_P01D026,dinPins0[26],WCLK_not0);
LATCH_1 data_capture_P01D027 (latch_P01D027,dinPins0[27],WCLK_not0);
LATCH_1 data_capture_P01D028 (latch_P01D028,dinPins0[28],WCLK_not0);
LATCH_1 data_capture_P01D029 (latch_P01D029,dinPins0[29],WCLK_not0);
LATCH_1 data_capture_P01D030 (latch_P01D030,dinPins0[30],WCLK_not0);
LATCH_1 data_capture_P01D031 (latch_P01D031,dinPins0[31],WCLK_not0);
not (WCLK_not1,wclkPin1);
wire latch_wenPin10;
LATCH_1 wen_capture10 (latch_wenPin10, wenPin1[0],WCLK_not1);
wire latch_wclk_and_wen10;
and (latch_wclk_and_wen10,wclkPin1,latch_wenPin10);
wire latch_wenPin11;
LATCH_1 wen_capture11 (latch_wenPin11, wenPin1[1],WCLK_not1);
wire latch_wclk_and_wen11;
and (latch_wclk_and_wen11,wclkPin1,latch_wenPin11);
wire latch_wenPin12;
LATCH_1 wen_capture12 (latch_wenPin12, wenPin1[2],WCLK_not1);
wire latch_wclk_and_wen12;
and (latch_wclk_and_wen12,wclkPin1,latch_wenPin12);
wire latch_wenPin13;
LATCH_1 wen_capture13 (latch_wenPin13, wenPin1[3],WCLK_not1);
wire latch_wclk_and_wen13;
and (latch_wclk_and_wen13,wclkPin1,latch_wenPin13);
wire latch_wenPin14;
LATCH_1 wen_capture14 (latch_wenPin14, wenPin1[4],WCLK_not1);
wire latch_wclk_and_wen14;
and (latch_wclk_and_wen14,wclkPin1,latch_wenPin14);
wire latch_wenPin15;
LATCH_1 wen_capture15 (latch_wenPin15, wenPin1[5],WCLK_not1);
wire latch_wclk_and_wen15;
and (latch_wclk_and_wen15,wclkPin1,latch_wenPin15);
wire latch_wenPin16;
LATCH_1 wen_capture16 (latch_wenPin16, wenPin1[6],WCLK_not1);
wire latch_wclk_and_wen16;
and (latch_wclk_and_wen16,wclkPin1,latch_wenPin16);
wire latch_wenPin17;
LATCH_1 wen_capture17 (latch_wenPin17, wenPin1[7],WCLK_not1);
wire latch_wclk_and_wen17;
and (latch_wclk_and_wen17,wclkPin1,latch_wenPin17);
wire latch_wenPin18;
LATCH_1 wen_capture18 (latch_wenPin18, wenPin1[8],WCLK_not1);
wire latch_wclk_and_wen18;
and (latch_wclk_and_wen18,wclkPin1,latch_wenPin18);
wire latch_wenPin19;
LATCH_1 wen_capture19 (latch_wenPin19, wenPin1[9],WCLK_not1);
wire latch_wclk_and_wen19;
and (latch_wclk_and_wen19,wclkPin1,latch_wenPin19);
wire latch_wenPin110;
LATCH_1 wen_capture110 (latch_wenPin110, wenPin1[10],WCLK_not1);
wire latch_wclk_and_wen110;
and (latch_wclk_and_wen110,wclkPin1,latch_wenPin110);
wire latch_wenPin111;
LATCH_1 wen_capture111 (latch_wenPin111, wenPin1[11],WCLK_not1);
wire latch_wclk_and_wen111;
and (latch_wclk_and_wen111,wclkPin1,latch_wenPin111);
wire latch_wenPin112;
LATCH_1 wen_capture112 (latch_wenPin112, wenPin1[12],WCLK_not1);
wire latch_wclk_and_wen112;
and (latch_wclk_and_wen112,wclkPin1,latch_wenPin112);
wire latch_wenPin113;
LATCH_1 wen_capture113 (latch_wenPin113, wenPin1[13],WCLK_not1);
wire latch_wclk_and_wen113;
and (latch_wclk_and_wen113,wclkPin1,latch_wenPin113);
wire latch_wenPin114;
LATCH_1 wen_capture114 (latch_wenPin114, wenPin1[14],WCLK_not1);
wire latch_wclk_and_wen114;
and (latch_wclk_and_wen114,wclkPin1,latch_wenPin114);
wire latch_wenPin115;
LATCH_1 wen_capture115 (latch_wenPin115, wenPin1[15],WCLK_not1);
wire latch_wclk_and_wen115;
and (latch_wclk_and_wen115,wclkPin1,latch_wenPin115);
wire latch_wenPin116;
LATCH_1 wen_capture116 (latch_wenPin116, wenPin1[16],WCLK_not1);
wire latch_wclk_and_wen116;
and (latch_wclk_and_wen116,wclkPin1,latch_wenPin116);
wire latch_wenPin117;
LATCH_1 wen_capture117 (latch_wenPin117, wenPin1[17],WCLK_not1);
wire latch_wclk_and_wen117;
and (latch_wclk_and_wen117,wclkPin1,latch_wenPin117);
wire latch_wenPin118;
LATCH_1 wen_capture118 (latch_wenPin118, wenPin1[18],WCLK_not1);
wire latch_wclk_and_wen118;
and (latch_wclk_and_wen118,wclkPin1,latch_wenPin118);
wire latch_wenPin119;
LATCH_1 wen_capture119 (latch_wenPin119, wenPin1[19],WCLK_not1);
wire latch_wclk_and_wen119;
and (latch_wclk_and_wen119,wclkPin1,latch_wenPin119);
wire latch_wenPin120;
LATCH_1 wen_capture120 (latch_wenPin120, wenPin1[20],WCLK_not1);
wire latch_wclk_and_wen120;
and (latch_wclk_and_wen120,wclkPin1,latch_wenPin120);
wire latch_wenPin121;
LATCH_1 wen_capture121 (latch_wenPin121, wenPin1[21],WCLK_not1);
wire latch_wclk_and_wen121;
and (latch_wclk_and_wen121,wclkPin1,latch_wenPin121);
wire latch_wenPin122;
LATCH_1 wen_capture122 (latch_wenPin122, wenPin1[22],WCLK_not1);
wire latch_wclk_and_wen122;
and (latch_wclk_and_wen122,wclkPin1,latch_wenPin122);
wire latch_wenPin123;
LATCH_1 wen_capture123 (latch_wenPin123, wenPin1[23],WCLK_not1);
wire latch_wclk_and_wen123;
and (latch_wclk_and_wen123,wclkPin1,latch_wenPin123);
wire latch_wenPin124;
LATCH_1 wen_capture124 (latch_wenPin124, wenPin1[24],WCLK_not1);
wire latch_wclk_and_wen124;
and (latch_wclk_and_wen124,wclkPin1,latch_wenPin124);
wire latch_wenPin125;
LATCH_1 wen_capture125 (latch_wenPin125, wenPin1[25],WCLK_not1);
wire latch_wclk_and_wen125;
and (latch_wclk_and_wen125,wclkPin1,latch_wenPin125);
wire latch_wenPin126;
LATCH_1 wen_capture126 (latch_wenPin126, wenPin1[26],WCLK_not1);
wire latch_wclk_and_wen126;
and (latch_wclk_and_wen126,wclkPin1,latch_wenPin126);
wire latch_wenPin127;
LATCH_1 wen_capture127 (latch_wenPin127, wenPin1[27],WCLK_not1);
wire latch_wclk_and_wen127;
and (latch_wclk_and_wen127,wclkPin1,latch_wenPin127);
wire latch_wenPin128;
LATCH_1 wen_capture128 (latch_wenPin128, wenPin1[28],WCLK_not1);
wire latch_wclk_and_wen128;
and (latch_wclk_and_wen128,wclkPin1,latch_wenPin128);
wire latch_wenPin129;
LATCH_1 wen_capture129 (latch_wenPin129, wenPin1[29],WCLK_not1);
wire latch_wclk_and_wen129;
and (latch_wclk_and_wen129,wclkPin1,latch_wenPin129);
wire latch_wenPin130;
LATCH_1 wen_capture130 (latch_wenPin130, wenPin1[30],WCLK_not1);
wire latch_wclk_and_wen130;
and (latch_wclk_and_wen130,wclkPin1,latch_wenPin130);
wire latch_wenPin131;
LATCH_1 wen_capture131 (latch_wenPin131, wenPin1[31],WCLK_not1);
wire latch_wclk_and_wen131;
and (latch_wclk_and_wen131,wclkPin1,latch_wenPin131);
LATCH_1 data_capture_P02D000 (latch_P02D000,dinPins1[0],WCLK_not1);
LATCH_1 data_capture_P02D001 (latch_P02D001,dinPins1[1],WCLK_not1);
LATCH_1 data_capture_P02D002 (latch_P02D002,dinPins1[2],WCLK_not1);
LATCH_1 data_capture_P02D003 (latch_P02D003,dinPins1[3],WCLK_not1);
LATCH_1 data_capture_P02D004 (latch_P02D004,dinPins1[4],WCLK_not1);
LATCH_1 data_capture_P02D005 (latch_P02D005,dinPins1[5],WCLK_not1);
LATCH_1 data_capture_P02D006 (latch_P02D006,dinPins1[6],WCLK_not1);
LATCH_1 data_capture_P02D007 (latch_P02D007,dinPins1[7],WCLK_not1);
LATCH_1 data_capture_P02D008 (latch_P02D008,dinPins1[8],WCLK_not1);
LATCH_1 data_capture_P02D009 (latch_P02D009,dinPins1[9],WCLK_not1);
LATCH_1 data_capture_P02D010 (latch_P02D010,dinPins1[10],WCLK_not1);
LATCH_1 data_capture_P02D011 (latch_P02D011,dinPins1[11],WCLK_not1);
LATCH_1 data_capture_P02D012 (latch_P02D012,dinPins1[12],WCLK_not1);
LATCH_1 data_capture_P02D013 (latch_P02D013,dinPins1[13],WCLK_not1);
LATCH_1 data_capture_P02D014 (latch_P02D014,dinPins1[14],WCLK_not1);
LATCH_1 data_capture_P02D015 (latch_P02D015,dinPins1[15],WCLK_not1);
LATCH_1 data_capture_P02D016 (latch_P02D016,dinPins1[16],WCLK_not1);
LATCH_1 data_capture_P02D017 (latch_P02D017,dinPins1[17],WCLK_not1);
LATCH_1 data_capture_P02D018 (latch_P02D018,dinPins1[18],WCLK_not1);
LATCH_1 data_capture_P02D019 (latch_P02D019,dinPins1[19],WCLK_not1);
LATCH_1 data_capture_P02D020 (latch_P02D020,dinPins1[20],WCLK_not1);
LATCH_1 data_capture_P02D021 (latch_P02D021,dinPins1[21],WCLK_not1);
LATCH_1 data_capture_P02D022 (latch_P02D022,dinPins1[22],WCLK_not1);
LATCH_1 data_capture_P02D023 (latch_P02D023,dinPins1[23],WCLK_not1);
LATCH_1 data_capture_P02D024 (latch_P02D024,dinPins1[24],WCLK_not1);
LATCH_1 data_capture_P02D025 (latch_P02D025,dinPins1[25],WCLK_not1);
LATCH_1 data_capture_P02D026 (latch_P02D026,dinPins1[26],WCLK_not1);
LATCH_1 data_capture_P02D027 (latch_P02D027,dinPins1[27],WCLK_not1);
LATCH_1 data_capture_P02D028 (latch_P02D028,dinPins1[28],WCLK_not1);
LATCH_1 data_capture_P02D029 (latch_P02D029,dinPins1[29],WCLK_not1);
LATCH_1 data_capture_P02D030 (latch_P02D030,dinPins1[30],WCLK_not1);
LATCH_1 data_capture_P02D031 (latch_P02D031,dinPins1[31],WCLK_not1);
 

// Gate read clock and read enable signals
not (RCLK_not0,rclkPin0);
LATCH_1 ren_capture00 (latch_renPin00, renPin0[0],RCLK_not0);
and (latch_rclk_and_ren00,rclkPin0,latch_renPin00);

// Add latch to capture RAM/ROM addrs on clock edge
wire latch_P01A00;
LATCH_1 addr_capture_P01A00 (latch_P01A00,addrPins0[0],RCLK_not0);
wire latch_P01A01;
LATCH_1 addr_capture_P01A01 (latch_P01A01,addrPins0[1],RCLK_not0);
wire latch_P01A02;
LATCH_1 addr_capture_P01A02 (latch_P01A02,addrPins0[2],RCLK_not0);
wire latch_P01A03;
LATCH_1 addr_capture_P01A03 (latch_P01A03,addrPins0[3],RCLK_not0);
wire latch_P01A04;
LATCH_1 addr_capture_P01A04 (latch_P01A04,addrPins0[4],RCLK_not0);
wire latch_P01A05;
LATCH_1 addr_capture_P01A05 (latch_P01A05,addrPins0[5],RCLK_not0);
wire latch_P01A06;
LATCH_1 addr_capture_P01A06 (latch_P01A06,addrPins0[6],RCLK_not0);
wire latch_P01A07;
LATCH_1 addr_capture_P01A07 (latch_P01A07,addrPins0[7],RCLK_not0);
wire latch_P01A08;
LATCH_1 addr_capture_P01A08 (latch_P01A08,addrPins0[8],RCLK_not0);
wire latch_P01A09;
LATCH_1 addr_capture_P01A09 (latch_P01A09,addrPins0[9],RCLK_not0);
wire latch_P01A10;
LATCH_1 addr_capture_P01A10 (latch_P01A10,addrPins0[10],RCLK_not0);
wire latch_P01A11;
LATCH_1 addr_capture_P01A11 (latch_P01A11,addrPins0[11],RCLK_not0);
wire latch_P01A12;
LATCH_1 addr_capture_P01A12 (latch_P01A12,addrPins0[12],RCLK_not0);
wire latch_P01A13;
LATCH_1 addr_capture_P01A13 (latch_P01A13,addrPins0[13],RCLK_not0);


xor xaddr_P01A00 (xor_P01A00,latch_P01A00,latch_P01A00);
xor xaddr_P01A01 (xor_P01A01,latch_P01A01,latch_P01A01);
xor xaddr_P01A02 (xor_P01A02,latch_P01A02,latch_P01A02);
xor xaddr_P01A03 (xor_P01A03,latch_P01A03,latch_P01A03);
xor xaddr_P01A04 (xor_P01A04,latch_P01A04,latch_P01A04);
xor xaddr_P01A05 (xor_P01A05,latch_P01A05,latch_P01A05);
xor xaddr_P01A06 (xor_P01A06,latch_P01A06,latch_P01A06);
xor xaddr_P01A07 (xor_P01A07,latch_P01A07,latch_P01A07);
xor xaddr_P01A08 (xor_P01A08,latch_P01A08,latch_P01A08);
xor xaddr_P01A09 (xor_P01A09,latch_P01A09,latch_P01A09);
xor xaddr_P01A10 (xor_P01A10,latch_P01A10,latch_P01A10);
xor xaddr_P01A11 (xor_P01A11,latch_P01A11,latch_P01A11);
xor xaddr_P01A12 (xor_P01A12,latch_P01A12,latch_P01A12);
xor xaddr_P01A13 (xor_P01A13,latch_P01A13,latch_P01A13);
or Corrupt_P1 (corruptenable1,xor_P01A00,xor_P01A01,xor_P01A02,xor_P01A03,xor_P01A04,xor_P01A05,xor_P01A06,xor_P01A07,xor_P01A08,xor_P01A09,xor_P01A10,xor_P01A11,xor_P01A12,xor_P01A13);

// Add latch/DFF to latch RAM/ROM outputs 
wire latch_P01_000;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_000 (A[0],latch_P01_000,latch_rclk_and_ren00);
wire latch_P01_001;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_001 (A[1],latch_P01_001,latch_rclk_and_ren00);
wire latch_P01_002;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_002 (A[2],latch_P01_002,latch_rclk_and_ren00);
wire latch_P01_003;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_003 (A[3],latch_P01_003,latch_rclk_and_ren00);
wire latch_P01_004;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_004 (A[4],latch_P01_004,latch_rclk_and_ren00);
wire latch_P01_005;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_005 (A[5],latch_P01_005,latch_rclk_and_ren00);
wire latch_P01_006;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_006 (A[6],latch_P01_006,latch_rclk_and_ren00);
wire latch_P01_007;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_007 (A[7],latch_P01_007,latch_rclk_and_ren00);
wire latch_P01_008;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_008 (A[8],latch_P01_008,latch_rclk_and_ren00);
wire latch_P01_009;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_009 (A[9],latch_P01_009,latch_rclk_and_ren00);
wire latch_P01_010;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_010 (A[10],latch_P01_010,latch_rclk_and_ren00);
wire latch_P01_011;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_011 (A[11],latch_P01_011,latch_rclk_and_ren00);
wire latch_P01_012;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_012 (A[12],latch_P01_012,latch_rclk_and_ren00);
wire latch_P01_013;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_013 (A[13],latch_P01_013,latch_rclk_and_ren00);
wire latch_P01_014;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_014 (A[14],latch_P01_014,latch_rclk_and_ren00);
wire latch_P01_015;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_015 (A[15],latch_P01_015,latch_rclk_and_ren00);
wire latch_P01_016;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_016 (A[16],latch_P01_016,latch_rclk_and_ren00);
wire latch_P01_017;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_017 (A[17],latch_P01_017,latch_rclk_and_ren00);
wire latch_P01_018;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_018 (A[18],latch_P01_018,latch_rclk_and_ren00);
wire latch_P01_019;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_019 (A[19],latch_P01_019,latch_rclk_and_ren00);
wire latch_P01_020;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_020 (A[20],latch_P01_020,latch_rclk_and_ren00);
wire latch_P01_021;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_021 (A[21],latch_P01_021,latch_rclk_and_ren00);
wire latch_P01_022;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_022 (A[22],latch_P01_022,latch_rclk_and_ren00);
wire latch_P01_023;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_023 (A[23],latch_P01_023,latch_rclk_and_ren00);
wire latch_P01_024;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_024 (A[24],latch_P01_024,latch_rclk_and_ren00);
wire latch_P01_025;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_025 (A[25],latch_P01_025,latch_rclk_and_ren00);
wire latch_P01_026;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_026 (A[26],latch_P01_026,latch_rclk_and_ren00);
wire latch_P01_027;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_027 (A[27],latch_P01_027,latch_rclk_and_ren00);
wire latch_P01_028;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_028 (A[28],latch_P01_028,latch_rclk_and_ren00);
wire latch_P01_029;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_029 (A[29],latch_P01_029,latch_rclk_and_ren00);
wire latch_P01_030;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_030 (A[30],latch_P01_030,latch_rclk_and_ren00);
wire latch_P01_031;
  (* SUPPRESS_MSG="CSV350,CSV027" *)
  (* ET_RE_LIST="latch_renPin00 " *)
__rDFF dout_capture_P01_031 (A[31],latch_P01_031,latch_rclk_and_ren00);

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin10 latch_wenPin00 " *)
RAM_A14_D001_BS memory_0 ({latch_P01_000}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D000} ,vdd ,latch_wclk_and_wen00  
     ,{latch_P02D000} ,latch_wclk_and_wen10 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin11 latch_wenPin01 " *)
RAM_A14_D001_BS memory_1 ({latch_P01_001}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D001} ,vdd ,latch_wclk_and_wen01  
     ,{latch_P02D001} ,latch_wclk_and_wen11 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin12 latch_wenPin02 " *)
RAM_A14_D001_BS memory_2 ({latch_P01_002}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D002} ,vdd ,latch_wclk_and_wen02  
     ,{latch_P02D002} ,latch_wclk_and_wen12 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin13 latch_wenPin03 " *)
RAM_A14_D001_BS memory_3 ({latch_P01_003}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D003} ,vdd ,latch_wclk_and_wen03  
     ,{latch_P02D003} ,latch_wclk_and_wen13 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin14 latch_wenPin04 " *)
RAM_A14_D001_BS memory_4 ({latch_P01_004}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D004} ,vdd ,latch_wclk_and_wen04  
     ,{latch_P02D004} ,latch_wclk_and_wen14 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin15 latch_wenPin05 " *)
RAM_A14_D001_BS memory_5 ({latch_P01_005}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D005} ,vdd ,latch_wclk_and_wen05  
     ,{latch_P02D005} ,latch_wclk_and_wen15 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin16 latch_wenPin06 " *)
RAM_A14_D001_BS memory_6 ({latch_P01_006}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D006} ,vdd ,latch_wclk_and_wen06  
     ,{latch_P02D006} ,latch_wclk_and_wen16 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin17 latch_wenPin07 " *)
RAM_A14_D001_BS memory_7 ({latch_P01_007}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D007} ,vdd ,latch_wclk_and_wen07  
     ,{latch_P02D007} ,latch_wclk_and_wen17 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin18 latch_wenPin08 " *)
RAM_A14_D001_BS memory_8 ({latch_P01_008}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D008} ,vdd ,latch_wclk_and_wen08  
     ,{latch_P02D008} ,latch_wclk_and_wen18 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin19 latch_wenPin09 " *)
RAM_A14_D001_BS memory_9 ({latch_P01_009}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D009} ,vdd ,latch_wclk_and_wen09  
     ,{latch_P02D009} ,latch_wclk_and_wen19 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin110 latch_wenPin010 " *)
RAM_A14_D001_BS memory_10 ({latch_P01_010}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D010} ,vdd ,latch_wclk_and_wen010  
     ,{latch_P02D010} ,latch_wclk_and_wen110 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin111 latch_wenPin011 " *)
RAM_A14_D001_BS memory_11 ({latch_P01_011}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D011} ,vdd ,latch_wclk_and_wen011  
     ,{latch_P02D011} ,latch_wclk_and_wen111 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin112 latch_wenPin012 " *)
RAM_A14_D001_BS memory_12 ({latch_P01_012}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D012} ,vdd ,latch_wclk_and_wen012  
     ,{latch_P02D012} ,latch_wclk_and_wen112 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin113 latch_wenPin013 " *)
RAM_A14_D001_BS memory_13 ({latch_P01_013}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D013} ,vdd ,latch_wclk_and_wen013  
     ,{latch_P02D013} ,latch_wclk_and_wen113 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin114 latch_wenPin014 " *)
RAM_A14_D001_BS memory_14 ({latch_P01_014}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D014} ,vdd ,latch_wclk_and_wen014  
     ,{latch_P02D014} ,latch_wclk_and_wen114 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin115 latch_wenPin015 " *)
RAM_A14_D001_BS memory_15 ({latch_P01_015}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D015} ,vdd ,latch_wclk_and_wen015  
     ,{latch_P02D015} ,latch_wclk_and_wen115 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin116 latch_wenPin016 " *)
RAM_A14_D001_BS memory_16 ({latch_P01_016}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D016} ,vdd ,latch_wclk_and_wen016  
     ,{latch_P02D016} ,latch_wclk_and_wen116 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin117 latch_wenPin017 " *)
RAM_A14_D001_BS memory_17 ({latch_P01_017}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D017} ,vdd ,latch_wclk_and_wen017  
     ,{latch_P02D017} ,latch_wclk_and_wen117 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin118 latch_wenPin018 " *)
RAM_A14_D001_BS memory_18 ({latch_P01_018}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D018} ,vdd ,latch_wclk_and_wen018  
     ,{latch_P02D018} ,latch_wclk_and_wen118 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin119 latch_wenPin019 " *)
RAM_A14_D001_BS memory_19 ({latch_P01_019}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D019} ,vdd ,latch_wclk_and_wen019  
     ,{latch_P02D019} ,latch_wclk_and_wen119 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin120 latch_wenPin020 " *)
RAM_A14_D001_BS memory_20 ({latch_P01_020}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D020} ,vdd ,latch_wclk_and_wen020  
     ,{latch_P02D020} ,latch_wclk_and_wen120 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin121 latch_wenPin021 " *)
RAM_A14_D001_BS memory_21 ({latch_P01_021}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D021} ,vdd ,latch_wclk_and_wen021  
     ,{latch_P02D021} ,latch_wclk_and_wen121 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin122 latch_wenPin022 " *)
RAM_A14_D001_BS memory_22 ({latch_P01_022}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D022} ,vdd ,latch_wclk_and_wen022  
     ,{latch_P02D022} ,latch_wclk_and_wen122 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin123 latch_wenPin023 " *)
RAM_A14_D001_BS memory_23 ({latch_P01_023}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D023} ,vdd ,latch_wclk_and_wen023  
     ,{latch_P02D023} ,latch_wclk_and_wen123 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin124 latch_wenPin024 " *)
RAM_A14_D001_BS memory_24 ({latch_P01_024}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D024} ,vdd ,latch_wclk_and_wen024  
     ,{latch_P02D024} ,latch_wclk_and_wen124 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin125 latch_wenPin025 " *)
RAM_A14_D001_BS memory_25 ({latch_P01_025}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D025} ,vdd ,latch_wclk_and_wen025  
     ,{latch_P02D025} ,latch_wclk_and_wen125 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin126 latch_wenPin026 " *)
RAM_A14_D001_BS memory_26 ({latch_P01_026}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D026} ,vdd ,latch_wclk_and_wen026  
     ,{latch_P02D026} ,latch_wclk_and_wen126 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin127 latch_wenPin027 " *)
RAM_A14_D001_BS memory_27 ({latch_P01_027}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D027} ,vdd ,latch_wclk_and_wen027  
     ,{latch_P02D027} ,latch_wclk_and_wen127 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin128 latch_wenPin028 " *)
RAM_A14_D001_BS memory_28 ({latch_P01_028}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D028} ,vdd ,latch_wclk_and_wen028  
     ,{latch_P02D028} ,latch_wclk_and_wen128 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin129 latch_wenPin029 " *)
RAM_A14_D001_BS memory_29 ({latch_P01_029}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D029} ,vdd ,latch_wclk_and_wen029  
     ,{latch_P02D029} ,latch_wclk_and_wen129 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin130 latch_wenPin030 " *)
RAM_A14_D001_BS memory_30 ({latch_P01_030}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D030} ,vdd ,latch_wclk_and_wen030  
     ,{latch_P02D030} ,latch_wclk_and_wen130 );

// Instance RAM/ROM primitive
  (* LPD="YES" *)
  (* ET_WE_LIST="latch_wenPin131 latch_wenPin031 " *)
RAM_A14_D001_BS memory_31 ({latch_P01_031}  
     ,{latch_P01A00,latch_P01A01,latch_P01A02,latch_P01A03,latch_P01A04
,latch_P01A05,latch_P01A06,latch_P01A07,latch_P01A08,latch_P01A09
,latch_P01A10,latch_P01A11,latch_P01A12,latch_P01A13} ,{latch_P01D031} ,vdd ,latch_wclk_and_wen031  
     ,{latch_P02D031} ,latch_wclk_and_wen131 );
endmodule
`endcelldefine
 
// **************************************************
//  RAM/ROM primitive module definition
// **************************************************
`celldefine
module RAM_A14_D001_BS (P01_000 , P01A[0:13] , P01D000 , P01READ , P01WCLK , P02D000 , P02WCLK 
     );
output P01_000;
input [0:13]  P01A;
input  P01D000;
input  P01READ;
input  P01WCLK;
input  P02D000;
input  P02WCLK;
endmodule
`endcelldefine
 
// **************************************************
//    Latch primitive definition
// **************************************************
module LATCH_1(DOUT,P01DATA,P01DCLK);
output DOUT;
input P01DATA, P01DCLK;
endmodule
