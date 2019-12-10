puts "RM-Info: Running script [info script]\n"
##################################################################
# TetraMAX Reference Methodology Setup Script                    #
# Script: tmax_setup.tcl                                         #
# Version: O-2018.06-SP2 (October 8, 2018)                       #
# Copyright (C) 2008-2018 Synopsys, Inc. All rights reserved.    #
##################################################################


##################################################################
#    RUNTIME: Set runtime variables                              #
##################################################################

# Set TMAX_NUM_PROCS to > 1 for multicore ATPG and simulation.
# Make sure that your compute farm settings allow multicore processing.
set TMAX_NUM_PROCS 4

# Set TMAX_OPTIMIZE_PATTERNS to TRUE for the final ATPG run to optimize
# pattern count at the expense of runtime. This optimization applies to
# the stuck-at and transition delay fault models; other fault models may
# not get better results so they are not supported in the RM.
set TMAX_OPTIMIZE_PATTERNS FALSE

# Change TMAX_DIRECT_CREDIT to FALSE to fault simulate patterns for multiple
# fault model flow. Fault simulation takes much more time but can result in
# smaller overall pattern sets.
set TMAX_DIRECT_CREDIT TRUE

# Change TMAX_DEBUG_MODE to TRUE to print a more complete log file and
# additional reports for debugging.
set TMAX_DEBUG_MODE TRUE

# Change TMAX_COMPRESSION_MODE to FALSE to run DRC and ATPG for Internal_scan
# mode instead of ScanCompression_mode. This allows achieved compression
# to be calculated.
set TMAX_COMPRESSION_MODE FALSE

##################################################################
#    DIRECTORIES: Set up output directories                      #
##################################################################

source ${TMAX_SETUP_ROOT}/common_setup.tcl
puts "RM-Info: DESIGN_NAME variable is set to ${DESIGN_NAME}\n"

set REPORTS_DIR "reports"
set RESULTS_DIR "results"
file mkdir $REPORTS_DIR
file mkdir $RESULTS_DIR

##################################################################
#    SETUP: Variables for overall execution                      #
##################################################################

# For the following variables, use a blank space to separate multiple entries
# Example: set TMAX_LIBRARY_FILES "/path1/lib1.v /path2/lib2.v /path3/lib3.v"

set RULES_TO_DOWNGRADE      "" ;# errors to downgrade without masking (default: none)
set RULES_TO_MASK           "" ;# errors to downgrade with masking (default: none)

##################################################################
#    BUILD: Variables for reading in and building the design     #
##################################################################

set MODULES_TO_BLACK_BOX    "" ;# Modules to replace by black boxes (default: none)
set INSTANCES_TO_BLACK_BOX  "" ;# Instances to replace by TIEX's (default: none)
set TMAX_LIBRARY_FILES      [list ../../memory/ramcell/tmax/RAM16384X32.v \
                                 /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250LT07/CS251DN/V1.0/verilog/cs251dn_uc.v \
                                 /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250L_CB2EGPIO_V1.0p2/verilog/CS250L_CB2EGPIO.v \
                                 /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_IP/xtal/veri/CS251/common/sim/std/IOCAXLBHFRA00.v \
                                 /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_IP/xtal/veri/CS251/common/sim/std/IOCAXLIINNA00.v] ;# Cell libraries, nofaulted inside modules (REQUIRED)
set NETLIST_FILES           "../../syn/genus/outputs/ibex_soc.v" ;# Design files, faulted inside modules (default: DC-RM output)

##################################################################
#    DRC: Files used by DRC for all ATPG runs.                   #
##################################################################

# NOTE: Only one PROTOCOL_FILE name may be specified per TetraMAX run.

# These are temporary files for protocol development purposes.
# The write_drc_file output does not contain compression information.
# The compression-mode PROTOCOL_FILE requires more edits (see tmax_quickstil_*.tcl).
# Different protocol files may be needed for the static and dynamic DRC runs.
if { $TMAX_COMPRESSION_MODE } {
   set PROTOCOL_FILE      "trans.comp.spf" ;# STIL Protocol File (default: write_drc_file output)
} else {
   set PROTOCOL_FILE      "trans.scan.spf" ;# STIL Protocol File (default: write_drc_file output)
}
set EXCEPTION_FILES         "${RESULTS_DIR}/${DESIGN_NAME}_tmax_exceptions.sdc" ;# SDC files for timing exceptions (default: PT-RM output)

##################################################################
#    SPECIAL: Files used by special ATPG runs.                   #
##################################################################

# NOTE: Only one GLOBAL_SLACK_FILE name may be specified per TetraMAX run.
set GLOBAL_SLACK_FILE       "${REPORTS_DIR}/${DESIGN_NAME}_tmax_slacks.report" ;# Slack File for Slack-Based Transition Fault Testing (default: PT-RM output)

##################################################################
#    End of TetraMAX Reference Methodology setup script          #
##################################################################
puts "RM-Info: Completed script [info script]\n"
