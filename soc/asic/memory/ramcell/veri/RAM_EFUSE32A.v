// *****************************************************************
// ***                                                           ***
// ***   MIE FUJITSU SEMICONDUCTOR CS251 Series                  ***
// ***   E-FUSE Simulation Library                               ***
// ***   Copyright (c) MIE FUJITSU SEMICONDUCTOR Limited, 2017   ***
// ***   All Rights Reserved. Licensed Library.                  ***
// ***                                                           ***
// *****************************************************************
// E-FUSE Verilog HDL Model.
//
// Rev. 0007  Apr 26,2017  K.Kasuga
// Rev. 0006  Apr 22,2013  T.Sahashi
// Rev. 0005  Feb 28,2013  T.Sahashi
// Rev. 0004  Feb 19,2013  T.Sahashi
// Rev. 0003  Jan 31,2013  T.Sahashi
// Rev. 0002  Jan 23,2013  T.Sahashi
// Rev. 0001  Oct 16,2012  H.Takeda.
//

`resetall
`timescale 1ps/1ps
`celldefine
`ifdef verifault
	`suppress_faults
	`enable_portfaults
`endif
//`delay_mode_path

module RAM_EFUSE32A (
 EN, SEL, SM, SI, CLK, WE, SENSE, VBLOW,
 FO, SO, SENSO);

input         EN, SEL, SM, SI, CLK, WE, SENSE, VBLOW;
output [31 : 0] FO;
output        SO, SENSO;

`ifdef FAST_FUNC
`else
reg
 notify_SENSE,
 notify_Read, notify_Read_CLK_SENSE, notify_Read_CLK_EN, notify_Read_CLK_SM, notify_Read_CLK_SEL, notify_Read_CLK_SI,
 notify_Set, notify_Set_CLK_WE, notify_Set_CLK_SENSE, notify_Set_CLK_EN, notify_Set_CLK_SM, notify_Set_CLK_SEL, notify_Set_CLK_SI,
 notify_BLOW_VBLOW_SENSE, notify_BLOW_WE_VBLOW, notify_BLOW_WE_CLK, notify_BLOW_WE_EN, notify_BLOW_WE_SI,
 notify_Update, notify_Update_CLK_WE, notify_Update_CLK_SENSE, notify_Update_CLK_EN, notify_Update_CLK_SM, notify_Update_CLK_SEL, notify_Update_CLK_SI  ;
`endif

`ifdef FAST_FUNC
`ifdef del_hold_delay
`else
`define hold_delay 10
`endif
`endif

wire  [31 : 0] Buf_FO;
wire  Reg_SIorWFF;

reg [31 : 0] Reg_FO ;
reg [31 : 0] Reg_RFF, Reg_WFF, Reg_EFC ;
reg        Reg_SO;
reg        Pre_VBLOW, Pre_SENSE, Pre_CLK, Pre_WE, Pre_SEL, Pre_SM, Pre_SI, Pre_EN;
reg        Flag_Blow_Shift, Flag_Blow_Set;
reg [31 : 0] Flag_Over_Blow, Flag_WFF_SET;

time WE_pos_time, WE_neg_time;

buf
`ifdef FAST_FUNC
`ifdef del_hold_delay
`else
#`hold_delay
`endif
`endif
  (Buf_EN, EN),
  (Buf_SEL, SEL),
  (Buf_SM, SM),
  (Buf_SI, SI),
  (Buf_WE, WE),
  (Buf_SENSE, SENSE),
  (Buf_VBLOW, VBLOW);

buf
  (Buf_CLK, CLK),
  (FO[31], Buf_FO[31]),
  (FO[30], Buf_FO[30]),
  (FO[29], Buf_FO[29]),
  (FO[28], Buf_FO[28]),
  (FO[27], Buf_FO[27]),
  (FO[26], Buf_FO[26]),
  (FO[25], Buf_FO[25]),
  (FO[24], Buf_FO[24]),
  (FO[23], Buf_FO[23]),
  (FO[22], Buf_FO[22]),
  (FO[21], Buf_FO[21]),
  (FO[20], Buf_FO[20]),
  (FO[19], Buf_FO[19]),
  (FO[18], Buf_FO[18]),
  (FO[17], Buf_FO[17]),
  (FO[16], Buf_FO[16]),
  (FO[15], Buf_FO[15]),
  (FO[14], Buf_FO[14]),
  (FO[13], Buf_FO[13]),
  (FO[12], Buf_FO[12]),
  (FO[11], Buf_FO[11]),
  (FO[10], Buf_FO[10]),
  (FO[9], Buf_FO[9]),
  (FO[8], Buf_FO[8]),
  (FO[7], Buf_FO[7]),
  (FO[6], Buf_FO[6]),
  (FO[5], Buf_FO[5]),
  (FO[4], Buf_FO[4]),
  (FO[3], Buf_FO[3]),
  (FO[2], Buf_FO[2]),
  (FO[1], Buf_FO[1]),
  (FO[0], Buf_FO[0]),
  (SO, Buf_SO),
  (SENSO, Buf_SENSO);


not  (N_SEL, Buf_SEL);
not  (N_CLK, Buf_CLK);
not  (N_SENSE, Buf_SENSE);

and  (Blow_Set, Buf_EN, Buf_SEL, Buf_SM, N_CLK, N_SENSE);

assign Buf_SO    = Reg_SO ;
assign Buf_FO    = Reg_FO ;
assign Buf_SENSO = Buf_SENSE ;
assign Reg_SIorWFF = |Reg_WFF | Buf_SI ;

// Timing Check
buf (ENe1, Buf_EN), (SELe1, Buf_SEL), (SMe1, Buf_SM), (VBLOWe1, Buf_VBLOW);
not (VBLOWe0, Buf_VBLOW), (CLKe0, Buf_CLK), (SMe0, Buf_SM), (SIe0, Buf_SI), (SENSEe0, Buf_SENSE), (ENe0, Buf_EN), (SELe0, Buf_SEL), (WEe0, Buf_WE);

// Initialize mode
and (VBLOWe0andENe1, VBLOWe0, ENe1);

// Read
and (SENSEe0andENe1andSMe0andSELe0andVBLOWe0, ENe1, SMe0, SELe0, VBLOWe0);
and (SMe0andSELe0andVBLOWe0, SMe0, SELe0, VBLOWe0);
and (ENe1andSELe0andVBLOWe0, ENe1, SELe0, VBLOWe0);
and (ENe1andSMe0andVBLOWe0, ENe1, SMe0, VBLOWe0);

// Write Set
and (ENe1andSMe0andSELe1, ENe1, SMe0, SELe1);
and (WEe0andENe1andSMe0andSELe1, WEe0, ENe1, SMe0, SELe1);
and (WEe0andSMe0andSELe1, WEe0, SMe0, SELe1);
and (WEe0andENe1andSELe1, WEe0, ENe1, SELe1);
and (WEe0andENe1andSMe0, WEe0, ENe1, SMe0);

// Update
and (ENe1andSMe1andSELe1, ENe1, SMe1, SELe1);
and (WEe0andSENSEe0andENe1andSMe1andSELe1, WEe0, ENe1, SMe1, SELe1);
and (WEe0andSMe1andSELe1, WEe0, SMe1, SELe1);
and (WEe0andENe1andSMe1, WEe0, ENe1, SMe1);

// Blow
and (SELe1andSMe1andENe1andSIe0, SELe1, SMe1, ENe1, SIe0);
and (SELe1andSMe1andVBLOWe1andENe1andSIe0, SELe1, SMe1, VBLOWe1, ENe1, SIe0);
and (SELe1andSMe1andVBLOWe1andSIe0, SELe1, SMe1, VBLOWe1, SIe0);
and (SELe1andSMe1andVBLOWe1andENe1, SELe1, SMe1, VBLOWe1, ENe1);


specify

// Timing Check
specparam
`ifdef FAST_FUNC
// Initialize mode
tTs_vblow_sense = (1:1:1),
tTh_vblow_sense = (1:1:1),
tTs_clk_sense   = (1:1:1),
tTh_clk_sense   = (1:1:1),
tTs_en_sense    = (1:1:1),
tTh_en_sense    = (1:1:1),
tTw_sense_H     = (1:1:1),
tTw_sense_L     = (1:1:1),
tTd_sense_fo    = (1:1:1),
tTd_sense_senso = (1:1:1),
tTd_sense_so    = (1:1:1),
// Read mode
tTs_sense_clk   = (1:1:1),
tTh_sense_clk   = (1:1:1),
tTs_en_clk      = (1:1:1),
tTh_en_clk      = (1:1:1),
tTs_sm_clk      = (1:1:1),
tTh_sm_clk      = (1:1:1),
tTs_sel_clk     = (1:1:1),
tTh_sel_clk     = (1:1:1),
tTs_si_clk01    = (1:1:1),
tTh_si_clk01    = (1:1:1),
ttCY            = (1:1:1),
tTw_clk_H       = (1:1:1),
tTw_clk_L       = (1:1:1),
tTd_clk_so01    = (1:1:1),
tTd_clk_fo      = (1:1:1),
tTd_sel_so      = (1:1:1),
// Write Set mode
tTs_we_clk      = (1:1:1),
tTh_we_clk      = (1:1:1),
tTd_sm_so       = (1:1:1),
// Write Blow mode
tTs_vblow_we    = (1:1:1),
tTh_vblow_we    = (1:1:1),
tTs_clk_we      = (1:1:1),
tTh_clk_we      = (1:1:1),
tTs_en_we       = (1:1:1),
tTh_en_we       = (1:1:1),
tTs_si_we       = (1:1:1),
tTh_si_we       = (1:1:1),
tTw_we_Hmax     = (27000000:27000000:27000000),
tTw_we_Hmin     = (1:1:1),
// Write Update mode
tTd_si_so       = (1:1:1),
tTd_clk_so02    = (1:1:1),
tTs_si_clk02    = (1:1:1),
tTh_si_clk02    = (1:1:1);

`else
// Initialize mode
tTs_vblow_sense = (100:100:100),
tTh_vblow_sense = (104522:104522:104522),
tTs_clk_sense   = (100:100:100),
tTh_clk_sense   = (90952:90952:90952),
tTs_en_sense    = (100:100:100),
tTh_en_sense    = (90952:90952:90952),
tTw_sense_H     = (104390:104390:104390),
tTw_sense_L     = (104390:104390:104390),
tTd_sense_fo    = (2312:299702:299702),
tTd_sense_senso = (8936:109610:109610),
tTd_sense_so    = (7584:90048:90048),
// Read mode
tTs_sense_clk   = (90952:90952:90952),
tTh_sense_clk   = (100:100:100),
tTs_en_clk      = (252:252:252),
tTh_en_clk      = (100:100:100),
tTs_sm_clk      = (5292:5292:5292),
tTh_sm_clk      = (100:100:100),
tTs_sel_clk     = (6022:6022:6022),
tTh_sel_clk     = (100:100:100),
tTs_si_clk01    = (100:100:100),
tTh_si_clk01    = (742:742:742),
ttCY            = (3696:3696:3696),
tTw_clk_H       = (950:950:950),
tTw_clk_L       = (950:950:950),
tTd_clk_so01    = (288:3213:3213),
tTd_clk_fo      = (256:2751:2751),
tTd_sel_so      = (208:1722:1722),
// Write Set mode
tTs_we_clk      = (100:100:100),
tTh_we_clk      = (11702:11702:11702),
tTd_sm_so       = (192:7371:7371),
// Write Blow mode
tTs_vblow_we    = (100:100:100),
tTh_vblow_we    = (2362:2362:2362),
tTs_clk_we      = (11702:11702:11702),
tTh_clk_we      = (100:100:100),
tTs_en_we       = (412:412:412),
tTh_en_we       = (100:100:100),
tTs_si_we       = (10442:10442:10442),
tTh_si_we       = (100:100:100),
tTw_we_Hmax     = (27000000:27000000:27000000),
tTw_we_Hmin     = (23000000:23000000:23000000),
// Write Update mode
tTd_si_so       = (984:11634:11634),
tTd_clk_so02    = (288:12065:12065),
tTs_si_clk02    = (9142:9142:9142),
tTh_si_clk02    = (742:742:742);
`endif


`ifdef FAST_FUNC
// Path Delay
(CLK => SO)      = (1, 1);
(SEL => SO)      = (1, 1);
(SENSE => FO[31])    = (1, 1);
(SENSE => FO[30])    = (1, 1);
(SENSE => FO[29])    = (1, 1);
(SENSE => FO[28])    = (1, 1);
(SENSE => FO[27])    = (1, 1);
(SENSE => FO[26])    = (1, 1);
(SENSE => FO[25])    = (1, 1);
(SENSE => FO[24])    = (1, 1);
(SENSE => FO[23])    = (1, 1);
(SENSE => FO[22])    = (1, 1);
(SENSE => FO[21])    = (1, 1);
(SENSE => FO[20])    = (1, 1);
(SENSE => FO[19])    = (1, 1);
(SENSE => FO[18])    = (1, 1);
(SENSE => FO[17])    = (1, 1);
(SENSE => FO[16])    = (1, 1);
(SENSE => FO[15])    = (1, 1);
(SENSE => FO[14])    = (1, 1);
(SENSE => FO[13])    = (1, 1);
(SENSE => FO[12])    = (1, 1);
(SENSE => FO[11])    = (1, 1);
(SENSE => FO[10])    = (1, 1);
(SENSE => FO[9])    = (1, 1);
(SENSE => FO[8])    = (1, 1);
(SENSE => FO[7])    = (1, 1);
(SENSE => FO[6])    = (1, 1);
(SENSE => FO[5])    = (1, 1);
(SENSE => FO[4])    = (1, 1);
(SENSE => FO[3])    = (1, 1);
(SENSE => FO[2])    = (1, 1);
(SENSE => FO[1])    = (1, 1);
(SENSE => FO[0])    = (1, 1);
(SENSE => SENSO) = (1, 1);
(SENSE => SO)    = (1, 1);
`ifdef same_time_check
`ifdef del_hold_delay
$hold (posedge CLK &&& ENe1andSMe0andSELe1, posedge SI, 1);
`else
$hold (posedge CLK &&& ENe1andSMe0andSELe1, posedge Buf_SI, 1);
`endif
`endif
`else
// Path Delay
// Initialize mode
(SENSE => FO[31]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[30]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[29]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[28]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[27]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[26]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[25]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[24]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[23]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[22]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[21]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[20]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[19]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[18]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[17]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[16]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[15]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[14]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[13]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[12]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[11]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[10]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[9]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[8]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[7]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[6]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[5]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[4]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[3]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[2]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[1]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => FO[0]) = (tTd_sense_fo, tTd_sense_fo);
(SENSE => SENSO) = (tTd_sense_senso, tTd_sense_senso);
(SENSE => SO) = (tTd_sense_so, tTd_sense_so);

// Read
if (SM===0) (CLK => SO)  = (tTd_clk_so01, tTd_clk_so01);
if (SM===1) (CLK => SO)  = (tTd_clk_so02, tTd_clk_so02);
(CLK => FO[31])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[30])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[29])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[28])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[27])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[26])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[25])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[24])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[23])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[22])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[21])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[20])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[19])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[18])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[17])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[16])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[15])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[14])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[13])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[12])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[11])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[10])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[9])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[8])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[7])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[6])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[5])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[4])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[3])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[2])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[1])  = (tTd_clk_fo, tTd_clk_fo);
(CLK => FO[0])  = (tTd_clk_fo, tTd_clk_fo);
(SEL => SO)  = (tTd_sel_so, tTd_sel_so);

// Write
(SM => SO)  = (tTd_sm_so, tTd_sm_so);
if (SM===1) (SI => SO)  = (tTd_si_so, tTd_si_so);

// Initialize mode
$setuphold (posedge SENSE, posedge VBLOW, tTs_vblow_sense, tTh_vblow_sense, notify_SENSE);
$setuphold (posedge SENSE, negedge VBLOW, tTs_vblow_sense, tTh_vblow_sense, notify_SENSE);
$setuphold (posedge SENSE &&& VBLOWe0, posedge EN, tTs_en_sense, tTh_en_sense, notify_SENSE);
$setuphold (posedge SENSE &&& VBLOWe0, negedge EN, tTs_en_sense, tTh_en_sense, notify_SENSE);
$setuphold (posedge SENSE &&& VBLOWe0andENe1, posedge CLK, tTs_clk_sense, tTh_clk_sense, notify_SENSE);
$setuphold (posedge SENSE &&& VBLOWe0andENe1, negedge CLK, tTs_clk_sense, tTh_clk_sense, notify_SENSE);
$width (posedge SENSE &&& VBLOWe0, tTw_sense_H, 0, notify_SENSE);
$width (negedge SENSE &&& VBLOWe0, tTw_sense_L, 0, notify_SENSE);

// Read mode
$setuphold (posedge CLK &&& SENSEe0andENe1andSMe0andSELe0andVBLOWe0, posedge SENSE, tTs_sense_clk, tTh_sense_clk, notify_Read_CLK_SENSE);
$setuphold (posedge CLK &&& SENSEe0andENe1andSMe0andSELe0andVBLOWe0, negedge SENSE, tTs_sense_clk, tTh_sense_clk, notify_Read_CLK_SENSE);
$setuphold (posedge CLK &&& SMe0andSELe0andVBLOWe0, posedge EN, tTs_en_clk, tTh_en_clk, notify_Read_CLK_EN);
$setuphold (posedge CLK &&& SMe0andSELe0andVBLOWe0, negedge EN, tTs_en_clk, tTh_en_clk, notify_Read_CLK_EN);
$setuphold (posedge CLK &&& ENe1andSELe0andVBLOWe0, posedge SM, tTs_sm_clk, tTh_sm_clk, notify_Read_CLK_SM);
$setuphold (posedge CLK &&& ENe1andSELe0andVBLOWe0, negedge SM, tTs_sm_clk, tTh_sm_clk, notify_Read_CLK_SM);
$setuphold (posedge CLK &&& ENe1andSMe0andVBLOWe0, posedge SEL, tTs_sel_clk, tTh_sel_clk, notify_Read_CLK_SEL);
$setuphold (posedge CLK &&& ENe1andSMe0andVBLOWe0, negedge SEL, tTs_sel_clk, tTh_sel_clk, notify_Read_CLK_SEL);
$setuphold (posedge CLK &&& SENSEe0andENe1andSMe0andSELe0andVBLOWe0, posedge SI, tTs_si_clk01, tTh_si_clk01, notify_Read_CLK_SI);
$setuphold (posedge CLK &&& SENSEe0andENe1andSMe0andSELe0andVBLOWe0, negedge SI, tTs_si_clk01, tTh_si_clk01, notify_Read_CLK_SI);
$period (posedge CLK, ttCY, notify_Read);
$width (posedge CLK &&& SENSEe0andENe1andSMe0andSELe0andVBLOWe0, tTw_clk_H, 0, notify_Read);
$width (negedge CLK &&& SENSEe0andENe1andSMe0andSELe0andVBLOWe0, tTw_clk_L, 0, notify_Read);

// Write Set mode
$setuphold (posedge CLK &&& ENe1andSMe0andSELe1, posedge WE, tTs_we_clk, tTh_we_clk, notify_Set_CLK_WE);
$setuphold (posedge CLK &&& ENe1andSMe0andSELe1, negedge WE, tTs_we_clk, tTh_we_clk, notify_Set_CLK_WE);
$setuphold (posedge CLK &&& WEe0andENe1andSMe0andSELe1, posedge SENSE, tTs_sense_clk, tTh_sense_clk, notify_Set_CLK_SENSE);
$setuphold (posedge CLK &&& WEe0andENe1andSMe0andSELe1, negedge SENSE, tTs_sense_clk, tTh_sense_clk, notify_Set_CLK_SENSE);
$setuphold (posedge CLK &&& WEe0andSMe0andSELe1, posedge EN, tTs_en_clk, tTh_en_clk, notify_Set_CLK_EN);
$setuphold (posedge CLK &&& WEe0andSMe0andSELe1, negedge EN, tTs_en_clk, tTh_en_clk, notify_Set_CLK_EN);
$setuphold (posedge CLK &&& WEe0andENe1andSELe1, posedge SM, tTs_sm_clk, tTh_sm_clk, notify_Set_CLK_SM);
$setuphold (posedge CLK &&& WEe0andENe1andSELe1, negedge SM, tTs_sm_clk, tTh_sm_clk, notify_Set_CLK_SM);
$setuphold (posedge CLK &&& WEe0andENe1andSMe0, posedge SEL, tTs_sel_clk, tTh_sel_clk, notify_Set_CLK_SEL);
$setuphold (posedge CLK &&& WEe0andENe1andSMe0, negedge SEL, tTs_sel_clk, tTh_sel_clk, notify_Set_CLK_SEL);
$setuphold (posedge CLK &&& WEe0andENe1andSMe0andSELe1, posedge SI, tTs_si_clk01, tTh_si_clk01, notify_Set_CLK_SI);
$setuphold (posedge CLK &&& WEe0andENe1andSMe0andSELe1, negedge SI, tTs_si_clk01, tTh_si_clk01, notify_Set_CLK_SI);
$width (posedge CLK &&& WEe0andENe1andSMe0andSELe1, tTw_clk_H, 0, notify_Set);
$width (negedge CLK &&& WEe0andENe1andSMe0andSELe1, tTw_clk_L, 0, notify_Set);

// Write Blow mode
$setup (VBLOW, posedge SENSE , tTs_vblow_sense, notify_BLOW_VBLOW_SENSE);
$hold  (negedge SENSE , VBLOW, tTh_vblow_sense, notify_BLOW_VBLOW_SENSE);

$setuphold (posedge WE &&& SELe1andSMe1andENe1andSIe0, posedge VBLOW, tTs_vblow_we, tTh_vblow_we, notify_BLOW_WE_VBLOW);
$setuphold (posedge WE &&& SELe1andSMe1andENe1andSIe0, negedge VBLOW, tTs_vblow_we, tTh_vblow_we, notify_BLOW_WE_VBLOW);
$setuphold (posedge WE &&& SELe1andSMe1andVBLOWe1andENe1andSIe0, posedge CLK, tTs_clk_we, tTh_clk_we, notify_BLOW_WE_CLK);
$setuphold (posedge WE &&& SELe1andSMe1andVBLOWe1andENe1andSIe0, negedge CLK, tTs_clk_we, tTh_clk_we, notify_BLOW_WE_CLK);
$setuphold (posedge WE &&& SELe1andSMe1andVBLOWe1andSIe0, posedge EN, tTs_en_we, tTh_en_we, notify_BLOW_WE_EN);
$setuphold (posedge WE &&& SELe1andSMe1andVBLOWe1andSIe0, negedge EN, tTs_en_we, tTh_en_we, notify_BLOW_WE_EN);
$setuphold (posedge WE &&& SELe1andSMe1andVBLOWe1andENe1, posedge SI, tTs_si_we, tTh_si_we, notify_BLOW_WE_SI);
$setuphold (posedge WE &&& SELe1andSMe1andVBLOWe1andENe1, negedge SI, tTs_si_we, tTh_si_we, notify_BLOW_WE_SI);

$setuphold (negedge WE &&& SELe1andSMe1andENe1andSIe0, posedge VBLOW, tTs_vblow_we, tTh_vblow_we, notify_BLOW_WE_VBLOW);
$setuphold (negedge WE &&& SELe1andSMe1andENe1andSIe0, negedge VBLOW, tTs_vblow_we, tTh_vblow_we, notify_BLOW_WE_VBLOW);
$setuphold (negedge WE &&& SELe1andSMe1andVBLOWe1andENe1andSIe0, posedge CLK, tTs_clk_we, tTh_clk_we, notify_BLOW_WE_CLK);
$setuphold (negedge WE &&& SELe1andSMe1andVBLOWe1andENe1andSIe0, negedge CLK, tTs_clk_we, tTh_clk_we, notify_BLOW_WE_CLK);
$setuphold (negedge WE &&& SELe1andSMe1andVBLOWe1andSIe0, posedge EN, tTs_en_we, tTh_en_we, notify_BLOW_WE_EN);
$setuphold (negedge WE &&& SELe1andSMe1andVBLOWe1andSIe0, negedge EN, tTs_en_we, tTh_en_we, notify_BLOW_WE_EN);
$setuphold (negedge WE &&& SELe1andSMe1andVBLOWe1andENe1, posedge SI, tTs_si_we, tTh_si_we, notify_BLOW_WE_SI);
$setuphold (negedge WE &&& SELe1andSMe1andVBLOWe1andENe1, negedge SI, tTs_si_we, tTh_si_we, notify_BLOW_WE_SI);

// Write Update mode
$setuphold (posedge CLK &&& ENe1andSMe1andSELe1, posedge WE, tTs_we_clk, tTh_we_clk, notify_Update_CLK_WE);
$setuphold (posedge CLK &&& ENe1andSMe1andSELe1, negedge WE, tTs_we_clk, tTh_we_clk, notify_Update_CLK_WE);
$setuphold (posedge CLK &&& WEe0andSENSEe0andENe1andSMe1andSELe1, posedge SENSE, tTs_sense_clk, tTh_sense_clk, notify_Update_CLK_SENSE);
$setuphold (posedge CLK &&& WEe0andSENSEe0andENe1andSMe1andSELe1, negedge SENSE, tTs_sense_clk, tTh_sense_clk, notify_Update_CLK_SENSE);
$setuphold (posedge CLK &&& WEe0andSMe1andSELe1, posedge EN, tTs_en_clk, tTh_en_clk, notify_Update_CLK_EN);
$setuphold (posedge CLK &&& WEe0andSMe1andSELe1, negedge EN, tTs_en_clk, tTh_en_clk, notify_Update_CLK_EN);
$setuphold (posedge CLK &&& WEe0andENe1andSELe1, posedge SM, tTs_sm_clk, tTh_sm_clk, notify_Update_CLK_SM);
$setuphold (posedge CLK &&& WEe0andENe1andSELe1, negedge SM, tTs_sm_clk, tTh_sm_clk, notify_Update_CLK_SM);
$setuphold (posedge CLK &&& WEe0andENe1andSMe1, posedge SEL, tTs_sel_clk, tTh_sel_clk, notify_Update_CLK_SEL);
$setuphold (posedge CLK &&& WEe0andENe1andSMe1, negedge SEL, tTs_sel_clk, tTh_sel_clk, notify_Update_CLK_SEL);
$setuphold (posedge CLK &&& WEe0andSENSEe0andENe1andSMe1andSELe1, posedge SI, tTs_si_clk02, tTh_si_clk02, notify_Update_CLK_SI);
$setuphold (posedge CLK &&& WEe0andSENSEe0andENe1andSMe1andSELe1, negedge SI, tTs_si_clk02, tTh_si_clk02, notify_Update_CLK_SI);
$width (posedge CLK &&& WEe0andSENSEe0andENe1andSMe1andSELe1, tTw_clk_H, 0, notify_Update);
$width (negedge CLK &&& WEe0andSENSEe0andENe1andSMe1andSELe1, tTw_clk_L, 0, notify_Update);

`endif

  `ifdef finfo
    specparam
    AREA$ = 306531.8 ;
  `endif
endspecify


// simulation initail
initial begin
	Flag_Blow_Set = 1'b1;
	Reg_EFC       = 32'b0;
end


`ifdef FAST_FUNC
`else
always @(notify_SENSE) begin
#1	TaskX;
end

always @(notify_Read_CLK_SENSE) begin
#1	TaskX;
end

always @(notify_Read_CLK_EN) begin
#1	TaskX;
end

always @(notify_Read_CLK_SM) begin
#1	TaskX;
end

always @(notify_Read_CLK_SEL) begin
#1	TaskX;
end

always @(notify_Read_CLK_SI) begin
#1	TaskX;
end

always @(notify_Read) begin
#1	TaskX;
end

always @(notify_Set_CLK_WE) begin
#1	TaskX;
end

always @(notify_Set_CLK_SENSE) begin
#1	TaskX;
end

always @(notify_Set_CLK_EN) begin
#1	TaskX;
end

always @(notify_Set_CLK_SM) begin
#1	TaskX;
end

always @(notify_Set_CLK_SEL) begin
#1	TaskX;
end

always @(notify_Set_CLK_SI) begin
#1	TaskX;
end

always @(notify_Set) begin
#1	TaskX;
end

always @(notify_BLOW_VBLOW_SENSE) begin
#1	TaskX;
end

always @(notify_BLOW_WE_VBLOW) begin
#1	TaskX;
end

always @(notify_BLOW_WE_CLK) begin
#1	TaskX;
end

always @(notify_BLOW_WE_EN) begin
#1	TaskX;
end

always @(notify_BLOW_WE_SI) begin
#1	TaskX;
end

always @(notify_Update_CLK_SENSE) begin
#1	TaskX;
end

always @(notify_Update_CLK_EN) begin
#1	TaskX;
end

always @(notify_Update_CLK_SM) begin
#1	TaskX;
end

always @(notify_Update_CLK_SEL) begin
#1	TaskX;
end

always @(notify_Update_CLK_SI) begin
#1	TaskX;
end

always @(notify_Update) begin
#1	TaskX;
end


`endif


// initailize mode
always @(Buf_SENSE) begin
	if (Buf_SENSE == 1 && Pre_SENSE == 0) begin
		if (Buf_VBLOW == 0 ) begin
			if (Buf_EN == 1) begin
				if (Buf_CLK !== 1'bx) begin
					Reg_RFF   = Reg_EFC;
					Reg_FO    = 32'b0 ;
					if (Buf_SEL == 0)                     Reg_SO = Reg_RFF[31];
					else if (Buf_SEL == 1 && Buf_SM == 0) Reg_SO = Reg_WFF[31];
					else if (Buf_SEL == 1 && Buf_SM == 1) Reg_SO = |Reg_WFF | Buf_SI;
					`ifdef no_macro_msg
					`else
					`ifdef LML_MSG
					   $display("\tMessage! Initialize-2 mode \n\tin %m\n\t(edge[01] SENSE : %0t);\n", $time);
					`endif
					`endif
				end
				else begin  // CLK = X
					TaskX;
					`ifdef no_macro_msg
					`else
					   $display("\tError! Invalid CLK Signal Detected at Initialize-2 mode \n\tin %m\n\t(edge[01] SENSE : %0t);\n", $time);
					`endif
				end
			end
			else if (Buf_EN == 0) begin
				Reg_RFF   = Reg_EFC;
				Reg_FO    = 32'b0 ;
				if (Buf_SEL == 0)                     Reg_SO = Reg_RFF[31];
				else if (Buf_SEL == 1 && Buf_SM == 0) Reg_SO = Reg_WFF[31];
				else if (Buf_SEL == 1 && Buf_SM == 1) Reg_SO = |Reg_WFF | Buf_SI;
				`ifdef no_macro_msg
				`else
				`ifdef LML_MSG
				   $display("\tMessage! Initialize-1 mode \n\tin %m\n\t(edge[01] SENSE : %0t);\n", $time);
				`endif
				`endif
			end
			else begin		// EN = X
				TaskX;
				`ifdef no_macro_msg
				`else
				   $display("\tError! Invalid EN Signal Detected at Initialize-1 mode \n\tin %m\n\t(edge[01] SENSE : %0t);\n", $time);
				`endif
			end
			if (Buf_SEL == 0) Reg_SO = Reg_RFF[31];
		end
		else begin	// VBLOW = X or H
			TaskX;
			`ifdef no_macro_msg
			`else
				if (Buf_VBLOW === 1'bx ) $display("\tError! Invalid VBLOW Signal Detected \n\tin %m\n\t(edge[01] SENSE : %0t);\n", $time);
				if (Buf_VBLOW === 1'b1 ) $display("\tError! Illegal VBLOW Signal Detected \n\tin %m\n\t(edge[01] SENSE : %0t);\n", $time);
			`endif
		end
	end
	if (Buf_SENSE == 0 && Pre_SENSE == 1) begin
		if (Buf_VBLOW == 0 ) begin
			if (Buf_EN == 1) begin
				if (Buf_CLK !== 1'bx) begin
					if (Buf_SEL == 0)                     Reg_SO = Reg_RFF[31];
					else if (Buf_SEL == 1 && Buf_SM == 0) Reg_SO = Reg_WFF[31];
					else if (Buf_SEL == 1 && Buf_SM == 1) Reg_SO = |Reg_WFF | Buf_SI;
				end
			end
		end
	end
	else if (Buf_SENSE === 1'bx) begin
		TaskX;
		`ifdef no_macro_msg
		`else
		   $display("\tError! Invalid SENSE Signal Detected  \n\tin %m\n\t(SENSE : %0t);\n", $time);
		`endif
	end
	Pre_SENSE = Buf_SENSE;
end


// CLK operation
// Read mode , Write set mode
// Write Update mode
always @(Buf_CLK) begin
	if (Buf_CLK == 1 && Pre_CLK == 0) begin
		if (Buf_EN == 1) begin
			if (Buf_SEL == 0) begin
				if (Buf_SENSE !== 1'bx) Reg_SO = Reg_RFF[31];
				if (Buf_SM == 0) begin
					if (Buf_VBLOW == 0) begin
						if (Buf_SENSE !== 1'bx) begin
							if (Buf_SI !== 1'bx) begin				// Read mode
								Reg_RFF[31] = Reg_RFF[30];
								Reg_RFF[30] = Reg_RFF[29];
								Reg_RFF[29] = Reg_RFF[28];
								Reg_RFF[28] = Reg_RFF[27];
								Reg_RFF[27] = Reg_RFF[26];
								Reg_RFF[26] = Reg_RFF[25];
								Reg_RFF[25] = Reg_RFF[24];
								Reg_RFF[24] = Reg_RFF[23];
								Reg_RFF[23] = Reg_RFF[22];
								Reg_RFF[22] = Reg_RFF[21];
								Reg_RFF[21] = Reg_RFF[20];
								Reg_RFF[20] = Reg_RFF[19];
								Reg_RFF[19] = Reg_RFF[18];
								Reg_RFF[18] = Reg_RFF[17];
								Reg_RFF[17] = Reg_RFF[16];
								Reg_RFF[16] = Reg_RFF[15];
								Reg_RFF[15] = Reg_RFF[14];
								Reg_RFF[14] = Reg_RFF[13];
								Reg_RFF[13] = Reg_RFF[12];
								Reg_RFF[12] = Reg_RFF[11];
								Reg_RFF[11] = Reg_RFF[10];
								Reg_RFF[10] = Reg_RFF[9];
								Reg_RFF[9] = Reg_RFF[8];
								Reg_RFF[8] = Reg_RFF[7];
								Reg_RFF[7] = Reg_RFF[6];
								Reg_RFF[6] = Reg_RFF[5];
								Reg_RFF[5] = Reg_RFF[4];
								Reg_RFF[4] = Reg_RFF[3];
								Reg_RFF[3] = Reg_RFF[2];
								Reg_RFF[2] = Reg_RFF[1];
								Reg_RFF[1] = Reg_RFF[0];
								Reg_RFF[0]  = Buf_SI;
								Reg_SO      = Reg_RFF[31];
								`ifdef no_macro_msg
								`else
								`ifdef LML_MSG
								$display("\tMessage! Read mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
								`endif
								`endif
							end
						end
						else begin	// SENSE = X
							TaskX;
							`ifdef no_macro_msg
							`else
								$display("\tError! Invalid SENSE Signal Detected at Read mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
							`endif
						end
						if (Buf_SI === 1'bx) begin
							TaskX;
							`ifdef no_macro_msg
							`else
								$display("\tError! Invalid SI Signal Detected at Read mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
							`endif
						end
					end
				end
				else if (Buf_SM == 1) begin
					TaskX;
					`ifdef no_macro_msg
					`else
						$display("\tError! Illegal Function \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
					`endif
				end
				else begin			// SM = X
					if (Buf_VBLOW == 0) begin
						TaskX;
						`ifdef no_macro_msg
						`else
							$display("\tError! Invalid SM Signal Detected at Read mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
						`endif
					end
				end
			end
			else if (Buf_SEL == 1) begin
				if (Buf_SM == 0) begin
					if (Buf_SENSE !== 1'bx) Reg_SO = Reg_WFF[31];
					if (Buf_SI !== 1'bx) begin
						if (Buf_WE == 0) begin
							if (Buf_SENSE !== 1'bx) begin
								Reg_WFF[31] = Reg_WFF[30];
								Flag_WFF_SET[31] = Flag_WFF_SET[30];
								Reg_WFF[30] = Reg_WFF[29];
								Flag_WFF_SET[30] = Flag_WFF_SET[29];
								Reg_WFF[29] = Reg_WFF[28];
								Flag_WFF_SET[29] = Flag_WFF_SET[28];
								Reg_WFF[28] = Reg_WFF[27];
								Flag_WFF_SET[28] = Flag_WFF_SET[27];
								Reg_WFF[27] = Reg_WFF[26];
								Flag_WFF_SET[27] = Flag_WFF_SET[26];
								Reg_WFF[26] = Reg_WFF[25];
								Flag_WFF_SET[26] = Flag_WFF_SET[25];
								Reg_WFF[25] = Reg_WFF[24];
								Flag_WFF_SET[25] = Flag_WFF_SET[24];
								Reg_WFF[24] = Reg_WFF[23];
								Flag_WFF_SET[24] = Flag_WFF_SET[23];
								Reg_WFF[23] = Reg_WFF[22];
								Flag_WFF_SET[23] = Flag_WFF_SET[22];
								Reg_WFF[22] = Reg_WFF[21];
								Flag_WFF_SET[22] = Flag_WFF_SET[21];
								Reg_WFF[21] = Reg_WFF[20];
								Flag_WFF_SET[21] = Flag_WFF_SET[20];
								Reg_WFF[20] = Reg_WFF[19];
								Flag_WFF_SET[20] = Flag_WFF_SET[19];
								Reg_WFF[19] = Reg_WFF[18];
								Flag_WFF_SET[19] = Flag_WFF_SET[18];
								Reg_WFF[18] = Reg_WFF[17];
								Flag_WFF_SET[18] = Flag_WFF_SET[17];
								Reg_WFF[17] = Reg_WFF[16];
								Flag_WFF_SET[17] = Flag_WFF_SET[16];
								Reg_WFF[16] = Reg_WFF[15];
								Flag_WFF_SET[16] = Flag_WFF_SET[15];
								Reg_WFF[15] = Reg_WFF[14];
								Flag_WFF_SET[15] = Flag_WFF_SET[14];
								Reg_WFF[14] = Reg_WFF[13];
								Flag_WFF_SET[14] = Flag_WFF_SET[13];
								Reg_WFF[13] = Reg_WFF[12];
								Flag_WFF_SET[13] = Flag_WFF_SET[12];
								Reg_WFF[12] = Reg_WFF[11];
								Flag_WFF_SET[12] = Flag_WFF_SET[11];
								Reg_WFF[11] = Reg_WFF[10];
								Flag_WFF_SET[11] = Flag_WFF_SET[10];
								Reg_WFF[10] = Reg_WFF[9];
								Flag_WFF_SET[10] = Flag_WFF_SET[9];
								Reg_WFF[9] = Reg_WFF[8];
								Flag_WFF_SET[9] = Flag_WFF_SET[8];
								Reg_WFF[8] = Reg_WFF[7];
								Flag_WFF_SET[8] = Flag_WFF_SET[7];
								Reg_WFF[7] = Reg_WFF[6];
								Flag_WFF_SET[7] = Flag_WFF_SET[6];
								Reg_WFF[6] = Reg_WFF[5];
								Flag_WFF_SET[6] = Flag_WFF_SET[5];
								Reg_WFF[5] = Reg_WFF[4];
								Flag_WFF_SET[5] = Flag_WFF_SET[4];
								Reg_WFF[4] = Reg_WFF[3];
								Flag_WFF_SET[4] = Flag_WFF_SET[3];
								Reg_WFF[3] = Reg_WFF[2];
								Flag_WFF_SET[3] = Flag_WFF_SET[2];
								Reg_WFF[2] = Reg_WFF[1];
								Flag_WFF_SET[2] = Flag_WFF_SET[1];
								Reg_WFF[1] = Reg_WFF[0];
								Flag_WFF_SET[1] = Flag_WFF_SET[0];
								Reg_WFF[0]  = Buf_SI;
								Flag_WFF_SET[0]  = Buf_SI;
								Reg_SO      = Reg_WFF[31];
								`ifdef no_macro_msg
								`else
								`ifdef LML_MSG
									$display("\tMessage! Write Set mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
								`endif
								`endif
							end
						end
					end
					else begin	// SI = X
						if (Buf_WE == 0) begin
							TaskX;
							`ifdef no_macro_msg
							`else
							`ifdef debug_message_LML
								$display("\tError! Invalid SI Signal Detected at Write set mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
							`else
							`endif
							`endif
						end
					end
					if (Buf_WE === 1'bx) begin				// WE = X
						TaskX;
						`ifdef no_macro_msg
						`else
							$display("\tError! Invalid WE Signal Detected at Write set mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
						`endif
					end
					else if (Buf_WE == 0 && Buf_SENSE === 1'bx) begin	// SENSE = X
						TaskX;
						`ifdef no_macro_msg
						`else
							$display("\tError! Invalid SENSE Signal Detected at Write set mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
						`endif
					end
				end
				else if (Buf_SM == 1) begin
					if (Buf_WE == 0) begin
						if (Buf_SENSE !== 1'bx) begin
							if (Buf_SI !== 1'bx) begin
								`ifdef no_macro_msg
								`else
								`ifdef LML_MSG
									$display("\tMessage! Write Update mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
								`endif
								`endif
								Flag_Blow_Shift = 1'b0 ;
                                                                Reg_WFF[31] = (|Reg_WFF[30:0] | Buf_SI) & Reg_WFF[31] ;
                                                                Reg_WFF[30] = (|Reg_WFF[29:0] | Buf_SI) & Reg_WFF[30] ;
                                                                Reg_WFF[29] = (|Reg_WFF[28:0] | Buf_SI) & Reg_WFF[29] ;
                                                                Reg_WFF[28] = (|Reg_WFF[27:0] | Buf_SI) & Reg_WFF[28] ;
                                                                Reg_WFF[27] = (|Reg_WFF[26:0] | Buf_SI) & Reg_WFF[27] ;
                                                                Reg_WFF[26] = (|Reg_WFF[25:0] | Buf_SI) & Reg_WFF[26] ;
                                                                Reg_WFF[25] = (|Reg_WFF[24:0] | Buf_SI) & Reg_WFF[25] ;
                                                                Reg_WFF[24] = (|Reg_WFF[23:0] | Buf_SI) & Reg_WFF[24] ;
                                                                Reg_WFF[23] = (|Reg_WFF[22:0] | Buf_SI) & Reg_WFF[23] ;
                                                                Reg_WFF[22] = (|Reg_WFF[21:0] | Buf_SI) & Reg_WFF[22] ;
                                                                Reg_WFF[21] = (|Reg_WFF[20:0] | Buf_SI) & Reg_WFF[21] ;
                                                                Reg_WFF[20] = (|Reg_WFF[19:0] | Buf_SI) & Reg_WFF[20] ;
                                                                Reg_WFF[19] = (|Reg_WFF[18:0] | Buf_SI) & Reg_WFF[19] ;
                                                                Reg_WFF[18] = (|Reg_WFF[17:0] | Buf_SI) & Reg_WFF[18] ;
                                                                Reg_WFF[17] = (|Reg_WFF[16:0] | Buf_SI) & Reg_WFF[17] ;
                                                                Reg_WFF[16] = (|Reg_WFF[15:0] | Buf_SI) & Reg_WFF[16] ;
                                                                Reg_WFF[15] = (|Reg_WFF[14:0] | Buf_SI) & Reg_WFF[15] ;
                                                                Reg_WFF[14] = (|Reg_WFF[13:0] | Buf_SI) & Reg_WFF[14] ;
                                                                Reg_WFF[13] = (|Reg_WFF[12:0] | Buf_SI) & Reg_WFF[13] ;
                                                                Reg_WFF[12] = (|Reg_WFF[11:0] | Buf_SI) & Reg_WFF[12] ;
                                                                Reg_WFF[11] = (|Reg_WFF[10:0] | Buf_SI) & Reg_WFF[11] ;
                                                                Reg_WFF[10] = (|Reg_WFF[9:0] | Buf_SI) & Reg_WFF[10] ;
                                                                Reg_WFF[9] = (|Reg_WFF[8:0] | Buf_SI) & Reg_WFF[9] ;
                                                                Reg_WFF[8] = (|Reg_WFF[7:0] | Buf_SI) & Reg_WFF[8] ;
                                                                Reg_WFF[7] = (|Reg_WFF[6:0] | Buf_SI) & Reg_WFF[7] ;
                                                                Reg_WFF[6] = (|Reg_WFF[5:0] | Buf_SI) & Reg_WFF[6] ;
                                                                Reg_WFF[5] = (|Reg_WFF[4:0] | Buf_SI) & Reg_WFF[5] ;
                                                                Reg_WFF[4] = (|Reg_WFF[3:0] | Buf_SI) & Reg_WFF[4] ;
                                                                Reg_WFF[3] = (|Reg_WFF[2:0] | Buf_SI) & Reg_WFF[3] ;
                                                                Reg_WFF[2] = (|Reg_WFF[1:0] | Buf_SI) & Reg_WFF[2] ;
                                                                Reg_WFF[1] = (|Reg_WFF[0] | Buf_SI) & Reg_WFF[1] ;
                                                                Reg_WFF[0]  = Buf_SI & Reg_WFF[0];
								Reg_SO    = |Reg_WFF | Buf_SI ;
							end
						end
						else begin	// SENSE = X
							TaskX;
							`ifdef no_macro_msg
							`else
								$display("\tError! Invalid SENSE Signal Detected at Write-Update mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
							`endif
						end
						if (Buf_SI === 1'bx) begin
							TaskX;
							`ifdef no_macro_msg
							`else
								$display("\tError! Invalid SI Signal Detected at Write-Update mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
							`endif
						end
					end
					else if (Buf_WE === 1'bx) begin		// WE = X
						TaskX;
						`ifdef no_macro_msg
						`else
							$display("\tError! Invalid WE Signal Detected at Write-Update mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
						`endif
					end
					if (Buf_SI !== 1'bx && Buf_SENSE !== 1'bx && Flag_WFF_SET !== {32{1'b0}}) Reg_SO = |Reg_WFF | Buf_SI ;
				end
				else begin	// SM = X
					if (Buf_WE == 0) begin
						TaskX;
						`ifdef no_macro_msg
						`else
							$display("\tError! Invalid SM Signal Detected at Write set or Update mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
						`endif
					end
				end
			end
			else begin	// SEL = X
				TaskX;
				`ifdef no_macro_msg
				`else
					$display("\tError! Invalid SEL Signal Detected at Read or Write set mode \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
				`endif
			end
			if (Buf_SM === 1'bx) begin
				TaskX;
				`ifdef no_macro_msg
				`else
					$display("\tError! Invalid SM Signal Detected \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
				`endif
			end
			if (Buf_SI === 1'bx) begin
				TaskX;
				`ifdef no_macro_msg
				`else
					$display("\tError! Invalid SI Signal Detected \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
				`endif
			end
		end
		else if (Buf_EN === 1'bx) begin
			TaskX;
			`ifdef no_macro_msg
			`else
				$display("\tError! Invalid EN Signal Detected \n\tin %m\n\t(edge[01] CLK : %0t);\n", $time);
			`endif
		end
	end
	if (Buf_CLK === 1'bx) begin
		if (Buf_EN !== 1'b0) begin
			TaskX;
			`ifdef no_macro_msg
			`else
				$display("\tError! Invalid CLK Signal Detected  \n\tin %m\n\t(CLK : %0t);\n", $time);
			`endif
		end
	end
	Pre_CLK = Buf_CLK;
end

always @(Buf_EN) begin
	if (Buf_EN === 1'bx) begin
		if (Buf_VBLOW === 1'bx) begin
			if ((Buf_SI !== 1'b1 && Buf_WE === 1'bx) || (Buf_SI !== 1'b1 && Buf_WE == 1)) begin
				TaskX;
				`ifdef no_macro_msg
				`else
					$display("\tError! Invalid EN Signal Detected  \n\tin %m\n\t(EN : %0t);\n", $time);
				`endif
			end
		end
		else if (Buf_VBLOW == 1) begin
			if ((Buf_SI !== 1'b1 && Buf_WE === 1'bx) || (Buf_SI !== 1'b1 && Buf_WE == 1)) begin
				TaskX;
				`ifdef no_macro_msg
				`else
					$display("\tError! Invalid EN Signal Detected  \n\tin %m\n\t(EN : %0t);\n", $time);
				`endif
 
			end
		end
	end
	else if (Buf_EN == 1 && Pre_EN == 0) begin
		if (Buf_VBLOW === 1'bx) begin
			if ((Buf_SI !== 1'b1 && Buf_WE === 1'bx) || (Buf_SI !== 1'b1 && Buf_WE == 1)) begin
				TaskX;
				`ifdef no_macro_msg
				`else
					$display("\tError! Invalid EN Signal Detected  \n\tin %m\n\t(EN : %0t);\n", $time);
				`endif
			end
		end
		else if (Buf_VBLOW == 1) begin
			if ((Buf_SI !== 1'b1 && Buf_WE === 1'bx) || (Buf_SI === 1'bx && Buf_WE == 1)) begin
				TaskX;
				`ifdef no_macro_msg
				`else
					$display("\tError! Invalid EN Signal Detected  \n\tin %m\n\t(EN : %0t);\n", $time);
				`endif
 
			end
		end
	end
	Pre_EN = Buf_EN;
end

always @(Buf_SEL) begin
	if (Buf_SEL == 0 && Pre_SEL == 1) Reg_SO = Reg_RFF[31];
	else if (Buf_SEL == 1 && Pre_SEL == 0) begin
		if (Buf_SM == 0) Reg_SO = Reg_WFF[31];
		else if (Buf_SM == 1 && Buf_SI !== 1'bx) Reg_SO = |Reg_WFF | Buf_SI ;
		else if (Buf_SM === 1'bx) Reg_SO = 1'bx ;
		else if (Buf_EN == 0 && Buf_SENSE !== 1'bx && Buf_VBLOW == 0) Reg_SO = |Reg_WFF | Buf_SI ; 
	end
	else if (Buf_SEL == 0) begin
		if (Buf_EN == 0 && Buf_SENSE !== 1'bx && Buf_VBLOW == 0) begin
			Reg_SO = Reg_RFF[31];
		end
	end
	else if (Buf_SEL == 1) begin
		if (Buf_EN == 0 && Buf_SENSE !== 1'bx && Buf_VBLOW == 0) begin
			if (Buf_SM == 0) Reg_SO = Reg_WFF[31];
			else if (Buf_SM == 1) Reg_SO = |Reg_WFF | Buf_SI ;
			else  Reg_SO = 1'bx;
		end
	end
	else if (Buf_SEL === 1'bx) begin
		if (Buf_EN !== 1'b0 || Buf_VBLOW !== 1'b0) TaskX;
		Reg_SO = 1'bx;
		`ifdef no_macro_msg
		`else
			$display("\tError! Invalid SEL Signal Detected  \n\tin %m\n\t(SEL : %0t);\n", $time);
		`endif
	end
	Pre_SEL = Buf_SEL;
end

always @(Buf_SM) begin
	if (Buf_SM == 0 && Pre_SM == 1) begin
		if (Buf_SEL == 1) Reg_SO = Reg_WFF[31];
	end
	else if (Buf_SM == 1 && Pre_SM == 0) begin
		if (Buf_SEL == 1 && Buf_SI !== 1'bx) Reg_SO = |Reg_WFF | Buf_SI ;
		else if (Buf_EN == 0 && Buf_SENSE !== 1'bx && Buf_VBLOW == 0) begin
			if (Buf_SEL == 1) Reg_SO = |Reg_WFF | Buf_SI ;
		end
	end
	else if (Buf_SM == 0) begin
		if (Buf_EN == 0 && Buf_SENSE !== 1'bx && Buf_VBLOW == 0) begin
			if (Buf_SEL == 1) Reg_SO = Reg_WFF[31];
		end
	end
	else if (Buf_SM == 1) begin
		if (Buf_EN == 0 && Buf_SENSE !== 1'bx && Buf_VBLOW == 0) begin
			if (Buf_SEL == 1) Reg_SO = |Reg_WFF | Buf_SI ;
		end
	end
	else if (Buf_SM === 1'bx) begin
		if (Buf_SEL == 1) begin
			Reg_SO = 1'bx;
			`ifdef no_macro_msg
			`else
				$display("\tError! Invalid SM Signal Detected \n\tin %m\n\t(SM : %0t);\n", $time);
			`endif
		end
	end
	Pre_SM = Buf_SM;
end

always @(Buf_SI) begin
	if (Buf_SI == 0 && Pre_SI == 1) begin
		if (Buf_SEL == 1 && Buf_SM == 1) Reg_SO = |Reg_WFF | Buf_SI ;
	end
	else if (Buf_SI == 1 && Pre_SI == 0) begin
		if (Buf_SEL == 1 && Buf_SM == 1) Reg_SO = |Reg_WFF | Buf_SI ;
	end
	else if (Buf_SI == 0 || SI == 1) begin
		if (Buf_EN == 0 && Buf_SENSE !== 1'bx && Buf_VBLOW == 0) begin
			if (Buf_SEL == 1 && Buf_SM == 1) Reg_SO = |Reg_WFF | Buf_SI ;
		end
	end
	else if (Buf_SI === 1'bx) begin
		if (Buf_EN !== 1'b0 || Buf_VBLOW !== 1'b0) begin
			if (Buf_SEL == 1 && Buf_SM ==1) begin
				TaskX;
				`ifdef no_macro_msg
				`else
					$display("\tError! Invalid SI Signal Detected \n\tin %m\n\t(SI : %0t);\n", $time);
				`endif
			end
		end
		if (Buf_VBLOW === 1'bx) begin
			if ((Buf_EN !== 1'b0 && Buf_WE === 1'bx) || (Buf_EN !== 1'b0 && Buf_WE == 1)) begin
				TaskX;
				`ifdef no_macro_msg
				`else
					$display("\tError! Invalid SI Signal Detected  \n\tin %m\n\t(SI : %0t);\n", $time);
				`endif
			end
		end
		else if (Buf_VBLOW == 1) begin
			if ((Buf_EN !== 1'b0 && Buf_WE === 1'bx) || (Buf_EN !== 1'b0 && Buf_WE == 1)) begin
				TaskX;
				`ifdef no_macro_msg
				`else
					$display("\tError! Invalid SI Signal Detected  \n\tin %m\n\t(SI : %0t);\n", $time);
				`endif
 
			end
		end
		if (Buf_SEL == 1 && Buf_SM == 1) Reg_SO = 1'bx;
	end
	Pre_SI = Buf_SI;
end

always @(Buf_VBLOW) begin
	if (Buf_VBLOW === 1'bx) begin
		if (Buf_EN !== 1'b0 && Buf_SI !== 1'b1 && Buf_WE !== 1'b0) begin
			TaskX;
			`ifdef no_macro_msg
			`else
				$display("\tError! Invalid VBLOW Signal Detected \n\tin %m\n\t(VBLOW : %0t);\n", $time);
			`endif
		end
	end
	Pre_VBLOW = Buf_VBLOW;
end

// WE operation
// Write Blow mode
always @(Buf_WE) begin
	if (Buf_WE == 1 && Pre_WE == 0) begin
		WE_pos_time = $time;
		if (Buf_EN == 1) begin
			if (Buf_SEL == 1) begin
				if (Buf_SM == 1) begin
					if (Buf_CLK !== 1'bx) begin
						if (Buf_SENSE !== 1'bx) begin
							if (Buf_VBLOW == 1) begin
								if (Buf_SI == 0) begin
									if (|Flag_WFF_SET == 1) begin
										if (Flag_WFF_SET[0] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[0] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[0] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[0] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow0 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[0] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow0 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[1] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[1] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[1] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[1] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow1 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[1] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow1 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[2] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[2] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[2] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[2] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow2 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[2] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow2 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[3] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[3] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[3] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[3] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow3 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[3] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow3 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[4] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[4] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[4] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[4] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow4 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[4] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow4 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[5] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[5] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[5] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[5] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow5 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[5] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow5 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[6] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[6] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[6] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[6] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow6 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[6] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow6 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[7] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[7] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[7] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[7] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow7 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[7] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow7 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[8] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[8] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[8] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[8] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow8 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[8] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow8 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[9] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[9] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[9] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[9] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow9 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[9] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow9 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[10] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[10] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[10] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[10] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow10 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[10] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow10 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[11] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[11] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[11] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[11] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow11 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[11] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow11 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[12] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[12] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[12] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[12] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow12 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[12] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow12 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[13] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[13] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[13] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[13] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow13 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[13] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow13 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[14] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[14] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[14] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[14] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow14 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[14] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow14 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[15] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[15] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[15] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[15] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow15 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[15] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow15 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[16] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[16] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[16] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[16] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow16 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[16] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow16 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[17] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[17] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[17] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[17] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow17 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[17] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow17 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[18] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[18] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[18] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[18] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow18 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[18] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow18 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[19] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[19] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[19] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[19] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow19 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[19] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow19 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[20] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[20] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[20] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[20] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow20 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[20] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow20 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[21] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[21] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[21] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[21] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow21 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[21] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow21 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[22] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[22] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[22] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[22] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow22 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[22] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow22 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[23] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[23] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[23] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[23] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow23 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[23] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow23 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[24] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[24] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[24] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[24] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow24 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[24] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow24 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[25] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[25] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[25] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[25] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow25 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[25] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow25 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[26] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[26] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[26] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[26] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow26 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[26] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow26 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[27] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[27] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[27] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[27] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow27 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[27] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow27 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[28] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[28] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[28] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[28] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow28 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[28] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow28 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[29] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[29] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[29] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[29] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow29 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[29] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow29 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[30] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[30] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[30] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[30] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow30 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[30] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow30 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
										if (Flag_WFF_SET[31] == 1 && Flag_Blow_Shift !== 1'b1 && Reg_SO == 1 ) begin
											`ifdef Over_Blow_chk
											if (Flag_Over_Blow[31] !== 1'b1 ) begin
											`endif
												Reg_SO = |Reg_WFF | Buf_SI ;
												Flag_WFF_SET[31] = 1'b0 ;
												`ifdef Over_Blow_chk
												Flag_Over_Blow[31] = 1'b1 ;
												`endif
												Flag_Blow_Shift = 1'b1 ;
												`ifdef no_macro_msg
												`else
												`ifdef LML_MSG
					   				   			$display("\tMessage! Blow31 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
												`endif
											`ifdef Over_Blow_chk
											end
											else if (Flag_Over_Blow[31] == 1) begin
												TaskX;
												`ifdef no_macro_msg
												`else
												$display("\tError Message! Over Blow31 \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
												`endif
											end
											`endif
										end
									end
								end
							end
						end
					end
					else if (Buf_CLK === 1'bx) begin
						if (Buf_SI == 0 && Buf_VBLOW == 1) begin
							TaskX;
							`ifdef no_macro_msg
							`else
							   $display("\tError! Invalid CLK Signal Detected at Write-Blow mode \n\tin %m\n\t(CLK : %0t);\n", $time);
							`endif
						end
					end
					if (Buf_SI === 1'bx) begin
						if (Buf_VBLOW == 1) begin
							TaskX;
							`ifdef no_macro_msg
							`else
							   $display("\tError! Invalid SI Signal Detected at Write-Blow mode \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
							`endif
						end
					end
					if (Buf_VBLOW === 1'bx) begin
						if (Buf_SI == 0) begin
							TaskX;
							`ifdef no_macro_msg
							`else
							   $display("\tError! Invalid VBLOW Signal Detected at Write-Blow mode \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
							`endif
						end
					end
				end
			end
		end
		else if (Buf_EN === 1'bx) begin
			if (Buf_SEL == 1 && Buf_SM == 1 && Buf_SI == 0 && Buf_VBLOW == 1) begin
				TaskX;
				`ifdef no_macro_msg
				`else
				   $display("\tError! Invalid EN Signal Detected at Write-Blow mode \n\tin %m\n\t(edge[01] WE : %0t);\n", $time);
				`endif
			end
		end
	end
	else if (Buf_WE == 0 && Pre_WE == 1) begin
		WE_neg_time = $time;
		if (Buf_EN == 1) begin
			if (Buf_SEL == 1 && Buf_SM == 1) begin
				if (Buf_SI === 1'bx && Buf_VBLOW == 1) begin
					TaskX ;
					`ifdef no_macro_msg
					`else
					   $display("\tError! Invalid SI Signal Detected at Write-Blow mode \n\tin %m\n\t(WE : %0t);\n", $time);
					`endif
				end
				else if (Buf_SI == 0 && Buf_CLK === 1'bx && Buf_VBLOW == 1) begin
					TaskX ;
					`ifdef no_macro_msg
					`else
					   $display("\tError! Invalid CLK Signal Detected at Write-Blow mode \n\tin %m\n\t(WE : %0t);\n", $time);
					`endif
				end
				else if (Buf_SI == 0 && Buf_VBLOW === 1'bx) begin
					TaskX ;
					`ifdef no_macro_msg
					`else
					   $display("\tError! Invalid VBLOW Signal Detected at Write-Blow mode \n\tin %m\n\t(WE : %0t);\n", $time);
					`endif
				end
			end
		end
		else if (Buf_EN === 1'bx) begin
			if (Buf_SEL == 1 && Buf_SM == 1 && Buf_SI == 0 && Buf_VBLOW == 1) begin
				TaskX ;
				`ifdef no_macro_msg
				`else
				   $display("\tError! Invalid EN Signal Detected at Write-Blow mode \n\tin %m\n\t(WE : %0t);\n", $time);
				`endif
			end

		end
`ifdef FAST_FUNC
`else
		if (Buf_EN !== 1'b0 || Buf_VBLOW !== 1'b0) begin
			if (WE_neg_time - WE_pos_time > tTw_we_Hmax || WE_neg_time - WE_pos_time < tTw_we_Hmin) begin
				TaskX;
				`ifdef no_macro_msg
				`else
				   $display("\tError! Timing violation(WE high pulse). \n\tin %m\n\t(edge[10] WE : %0t);\n", $time);
				`endif
			end
		end
`endif
	end
	else if (Buf_WE === 1'bx) begin
		if (Buf_EN == 1 && Buf_SEL == 1 && Buf_SM == 1 && Buf_SI == 0 && Buf_VBLOW == 1) begin
			TaskX;
			`ifdef no_macro_msg
			`else
			   $display("\tError! Invalid WE Signal Detected at Write-Blow mode \n\tin %m\n\t(WE : %0t);\n", $time);
			`endif
		end
		if (Buf_EN !== 1'b0 && Buf_SI !== 1'b1 && Buf_VBLOW !== 1'b0) begin
			TaskX;
			`ifdef no_macro_msg
			`else
			   $display("\tError! Invalid WE Signal Detected at Write-Blow mode \n\tin %m\n\t(WE : %0t);\n", $time);
			`endif

		end
	end
	Pre_WE = Buf_WE;
end

task TaskX ;
begin
	Reg_RFF = 32'bx ;
	Reg_WFF = 32'bx ;
	Reg_FO  = 32'bx ;
	Reg_SO  = 1'bx;
end
endtask

endmodule
`ifdef verifault
	`nosuppress_faults
	`disable_portfaults
`endif
`endcelldefine
