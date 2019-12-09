# Modus ATPG Script

#-------------------------------------------------------------------------------
# INITIALIZE VARIABLES
#-------------------------------------------------------------------------------
# "set_db workdir" is recommended to be set first to initialize where the Database is to be located
# WORKDIR Tcl variable can be used in the script to reference file locations
set_db workdir ./work
set   WORKDIR [get_db workdir]

file delete -force $WORKDIR/tbdata      ;# Delete Test Database
file delete -force $WORKDIR/testresults ;# Delete Test Output Files/Logs

#-------------------------------------------------------------------------------
# BUILD THE LOGIC MODEL
#-------------------------------------------------------------------------------
build_model \
    -cell ibex_soc \
    -techlib ../../lib/modus/RAM16384X32.v,/project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250LT07/CS251DN/V1.0/verilog/cs251dn_uc.v,/project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250L_CB2EGPIO_V1.0p2/verilog/CS250L_CB2EGPIO.v,/project/processes/Fujitsu/55NM/CS250L/lib/MIFS_IP/xtal/veri/CS251/common/sim/std/IOCAXLBHFRA00.v,/project/processes/Fujitsu/55NM/CS250L/lib/MIFS_IP/xtal/veri/CS251/common/sim/std/IOCAXLIINNA00.v \
    -designsource ../../syn/genus/outputs/ibex_soc.v
    -allowmissingmodules yes \
    -definemacro FAST_FUNC

#-------------------------------------------------------------------------------
# BUILD THE TEST MODEL
#-------------------------------------------------------------------------------
build_testmode \
    -testmode FULLSCAN \
    -assignfile ./scripts/ibex_soc.FULLSCAN.pinassign \
    -modedef FULLSCAN

#-------------------------------------------------------------------------------
# REPORT THE TEST MODEL
#-------------------------------------------------------------------------------
report_test_structures -testmode FULLSCAN

#-------------------------------------------------------------------------------
# VERIFY THE TEST MODEL
#-------------------------------------------------------------------------------
verify_test_structures \
    -messagecount TSV-016=10,TSV-024=10,TSV-315=10,TSV-027=10 \
    -testmode FULLSCAN \
    -xclockanalysis yes

#-------------------------------------------------------------------------------
# BUILD THE FAULT MODEL
#-------------------------------------------------------------------------------
build_faultmodel

###-------------------------------------------------------------------------------
### MEMORY - TEST GENERATION
###-------------------------------------------------------------------------------
##create_memory_delay_tests \
##    -experiment memory_delay_test \
##    -testmode FULLSCAN
##
##write_vectors \
##    -inexperiment memory_delay_test \
##    -testmode FULLSCAN \
##    -language verilog \
##    -scanformat parallel \
##    -multibitscanshifts yes
##
##write_vectors \
##    -inexperiment memory_delay_test \
##    -testmode FULLSCAN \
##    -language stil \
##    -signalsfile no \
##    -testperiod 20.0 \
##    -scanperiod 80.0

#-------------------------------------------------------------------------------
# ATPG - TEST GENERATION
#-------------------------------------------------------------------------------
create_scanchain_tests \
    -experiment scanchain_test \
    -testmode FULLSCAN

write_vectors \
    -inexperiment scanchain_test \
    -testmode FULLSCAN \
    -language verilog \
    -scanformat parallel \
    -messagecount TVE-253=10 \
    -multibitscanshifts yes

write_vectors \
    -inexperiment scanchain_test \
    -testmode FULLSCAN \
    -language stil \
    -signalsfile no

commit_tests \
    -inexperiment scanchain_test \
    -testmode FULLSCAN

#-------------------------------------------------------------------------------
# ATPG - TEST GENERATION
#-------------------------------------------------------------------------------
create_logic_delay_tests \
    -experiment logic_delay_test \
    -testmode FULLSCAN \
    -effort low

write_vectors \
    -inexperiment logic_delay_test \
    -testmode FULLSCAN \
    -language verilog \
    -scanformat parallel \
    -messagecount TVE-253=10 \
    -multibitscanshifts yes

write_vectors \
    -inexperiment logic_delay_test \
    -testmode FULLSCAN \
    -language stil \
    -signalsfile no \
    -testperiod 20.0 \
    -scanperiod 80.0

#-timingfile <infilename> ???

commit_tests \
    -inexperiment logic_delay_test \
    -testmode FULLSCAN

#-------------------------------------------------------------------------------
# ATPG - TEST GENERATION
#-------------------------------------------------------------------------------
create_logic_tests \
    -experiment logic_test \
    -testmode FULLSCAN \
    -effort low

write_vectors \
    -inexperiment logic_test \
    -testmode FULLSCAN \
    -language verilog \
    -scanformat parallel \
    -messagecount TVE-253=10 \
    -multibitscanshifts yes

write_vectors \
    -inexperiment logic_test \
    -testmode FULLSCAN \
    -language stil \
    -signalsfile no

commit_tests \
    -inexperiment logic_test \
    -testmode FULLSCAN

exit
