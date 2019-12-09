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
module RAM_EFUSE32A (
 EN, SEL, SM, SI, CLK, WE, SENSE, VBLOW,
 FO, SO, SENSO);
input         EN, SEL, SM, SI, CLK, WE, SENSE, VBLOW;
output [31 : 0] FO;
output        SO, SENSO;
endmodule
