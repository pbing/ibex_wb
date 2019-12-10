puts "RM-Info: Running script [info script]\n"
##################################################################
# TetraMAX Reference Methodology SPF Creation Script             #
# Script: tmax_quickstil_trans.tcl                               #
# Version: O-2018.06-SP2 (October 8, 2018)                       #
# Copyright (C) 2012-2018 Synopsys, Inc. All rights reserved.    #
##################################################################

# Use this script to create a STIL protocol file for dynamic testing.

# Define all scan chains. If the design has compression only define
# scan chains used in Internal_scan mode.
#Example: add_scan_chains c0 test_si test_so
add_scan_chains chain0 gpio[0] gpio[8]
add_scan_chains chain1 gpio[1] gpio[9]
add_scan_chains chain2 gpio[2] gpio[10]
add_scan_chains chain3 gpio[3] gpio[11]
add_scan_chains chain4 gpio[4] gpio[12]
add_scan_chains chain5 gpio[5] gpio[13]

# Define all scan enables. They are constrained during scan shift.
#Example: add_scan_enables 1 test_se
add_scan_enables 1 gpio[6]

# Define all PI constraints. These are test modes constrained to the
# same state for both shift and capture.
#Example: add_pi_constraints 1 test_mode
add_pi_constraints 1 test_en

# Define clocks on ports. Only define timing for the first one.
# Define asynchronous resets as clocks, but not as shift clocks.
#Example: add_clocks 0 clk1 -shift -timing {100 45 55 40}
#Example: add_clocks 0 clk2 -shift 
#Example: add_clocks 1 reset_n
add_clocks 1 xo -shift -timing {100 45 55 40}
add_clocks 0 tck -shift -timing {100 45 55 40}
add_clocks 1 ext_rst_n
add_clocks 1 trst_n

# For transition delay fault testing, define scan enable to be in
# opposite state for capture than its shift state.
# Also constrain asynchronous resets to be inactive.
#Example: add_pi_constraints 0 test_se
#Example: add_pi_constraints 1 reset_n
add_pi_constraints 0 gpio[6]
add_pi_constraints 1 ext_rst_n
add_pi_constraints 1 trst_n

# Write the SPF because it is as complete as the Quick STIL commands
# can make it.

write_drc_file temp_trans.${tmax_file_ext}.spf -replace

# This protocol file has only a _default_WFT_ defined. This is not
# compatible with the waveform table names used in the tmax_update_spf.tcl
# commands, or in the write_timing_constraints commands. The extra WFTs
# can be added using the procedure described in the first 3 numbered steps
# at the end of TetraMAX User Guide section titled:
#   Specifying an On-Chip Clock Controller Inserted by DFT Compiler
#
# Alternatively, if WFT updating is not required, the first invocation of
# write_timing_constraints in tmax.tcl can be changed to:
#   write_timing_constraints ${RESULTS_DIR}/${DESIGN_NAME}_trans_capture.${tmax_file_ext}.tcl \
#     -mode capture -replace -wft _default_WFT_ -wft _default_WFT_

#
# If an initialization sequence is required, or if scan compression is used,
# further edits are needed.
#
#
# For initialization, see the TetraMAX User Guide section titled:
#   Defining the test_setup Macro
#
#
# For scan compression, the ScanStructures and CompressorStructures blocks
# must be supplied from an already-existing SPF file. This is done by the
# stilgen utility. To run it, type:
#
# $SYNOPSYS/linux64/syn/bin/stilgen -config_file <config_file_name> -protocol
#
# The config file fields that are used to write a compression-mode SPF file
# from a scan-mode SPF file are:
# INPUT_SPF <scan_spf_filename>
# OUTPUT_SPF <final_spf_filename>
# DFTMAX_SPF <spf_with_CompressorStructures_filename>
# TOGGLE_CONSTRAINT <DFTMAX_test_mode_portname>
#

quit

##################################################################
#    End of TetraMAX RM SPF Creation script                      #
##################################################################
puts "RM-Info: Completed script [info script]\n"
