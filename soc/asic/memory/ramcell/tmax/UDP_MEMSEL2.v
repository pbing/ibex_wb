// **************************************************************
// ***                                                        ***
// *** UDP MEMSEL TetraMAX Library                            ***
// *** Copyright (c) MIE FUJITSU SEMICONDUCTOR Limited, 2015  ***
// *** All Rights Reserved. Licensed Library.                 ***
// ***                                                        ***
// **************************************************************
// Rev. 0001    Jun 10,2015

primitive UDP_MEMSEL2 (SEL, RCK, WCKA);
output SEL;
input RCK, WCKA;
`protect
reg SEL;
table

// RCK WA :mem:SEL;

   r   ?  : ? :0;
   ?   r  : ? :1;
   0   0  : ? :-;

endtable
`endprotect
endprimitive
