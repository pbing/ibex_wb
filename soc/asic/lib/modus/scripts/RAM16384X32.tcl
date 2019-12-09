set data(0,versionNum) {6.2}
set data(0,cellName) {RAM16384X32}
set data(0,numData) {32}
set data(0,numPortsOptions) {1}
set data(0,numAddr) {14}
set data(0,addrTypeOptions) {Encoded}
set data(0,addrLatchOptions) {Lockup}
set data(0,bitLatchOptions) {RAM/ROM Primitive}
set data(0,intFaultsOptions) {Yes}
set data(0,romContents) {}
set data(0,romFormat) {4}
set data(0,readOperOptions) {Rising Edge}
set data(0,rwConflictOptions) {Write then Read}
set data(0,oenDisableOptions) {X}
set data(0,wwConflictOptions) {Last Port}
set data(0,writeThru) {No}
set data(0,minAddr) {}
set data(0,maxAddr) {}
set data(0,readoffOptions) {Hold}
set data(0,writeOperOptions) {Rising Edge}
set data(0,corruptRAMread) {Yes}
set data(0,pinNames) {{A[31:0]} {I[31:0]} {IA[13:0]} {DM[31:0]} CK CE WE {FO[5:0]} SLP}
set data(0,pinDirs) {Output Input Input Input {Clock +SC} Input Input {Input -TI} {Input +TI}}
set data(0,numWE) {32}
set data(0,numDataPerWE) {1}
set data(0,numRE) {1}
set data(0,numDataPerRE) {}
set data(0,comments) {}
set data(0,portTypeOptions0) {RW}
set data(0,addrPinNames0) {IA[13:0]}
set data(0,doutPinNames0) {A[31:0]}
set data(0,renPinName0) {~CE & WE & SLP}
set data(0,rclkPinName0) {CK}
set data(0,oenPinName0) {}
set data(0,bypPinName0) {}
set data(0,bypData0) {}
set data(0,readCorr0) {}
set data(0,dinPinNames0) {I[31:0]}
set data(0,wenPinName0) {{32{~CE}} & {32{~WE}} & {32{SLP}} & ~DM}
set data(0,wclkPinName0) {CK}
