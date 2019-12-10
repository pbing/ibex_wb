
##################################################################
# TetraMAX Reference Methodology Pattern Update Script           #
# Script: tmax_update_patterns.tcl                               #
# Version: O-2018.06-SP2 (October 8, 2018)                       #
# Copyright (C) 2012-2018 Synopsys, Inc. All rights reserved.    #
##################################################################


###############################################################
# SETUP: Settings for overall execution                       #
###############################################################

set_messages -log tmax_update_patterns.log -replace
report_version -full
set TMAX_SCRIPTS_ROOT "./rm_tmax_scripts"
set TMAX_SETUP_ROOT "./rm_setup"
source -echo ${TMAX_SETUP_ROOT}/tmax_setup.tcl
if { $TMAX_DEBUG_MODE } {
   set_messages -level expert
}
if { $TMAX_COMPRESSION_MODE } {
   set tmax_file_ext comp
} else {
   set tmax_file_ext scan
}

# First, read the image used to generate the pattern being resolved:
read_image ${RESULTS_DIR}/${DESIGN_NAME}_trans.${tmax_file_ext}.img

# A -num_processes setting is in the image file, so it must be reset here.
if { $TMAX_NUM_PROCS > 1 } {
   set_atpg -num_processes $TMAX_NUM_PROCS
   set_simulation -num_processes $TMAX_NUM_PROCS
} else {
   set_atpg -num_processes 0
   set_simulation -num_processes 0
}

##################################################################
# RESOLVE: Resolve differences between patterns and results      #
##################################################################

# These commands resolve failures either in simulation or on the ATE,
# substituting X for mismatching values. The result is then fault
# simulated to determine the new coverage, then written out so that it
# can be used instead of the failing patterns.

# To get the failure log file from Verilog simulation, add these defines:
#    +define+tmax_diag=1+tmax_diag_file=\"error.diag\"

# Set the pattern file, using the binary pattern set if available,
# and specifying the failure log file:
set_patterns -external ${RESULTS_DIR}/${DESIGN_NAME}_trans.${tmax_file_ext}.bin.gz -resolve_differences error.diag

# Make sure that simulation settings match those used for ATPG.
set_simulation -shift_cycles 1
#set_simulation -timing_exceptions_for_stuck_at
report_settings simulation

# Make sure that Slack-Based Transition Fault Testing settings match those used for ATPG.
if { [file exists ${GLOBAL_SLACK_FILE}] } {
   puts "RM-Info: Global Slack File will be used for Transition Delay Fault testing.\n"
   set_faults -model transition
   read_timing ${GLOBAL_SLACK_FILE} -delete
   set_delay -max_tmgn 30%
   set_delay -max_delta_per_fault 0
} else {
   puts "RM-Info: Global Slack File not found. Transition Delay Fault testing will not use slacks.\n"
}

# Read the fault list for re-grading.
# Using the same fault list as ATPG makes it possible to compare coverage.
set_faults -summary verbose -noequiv_code
#set_faults -fault_coverage -pt_credit 0
set_faults -persistent_fault_models
set_faults -model transition
read_faults ${RESULTS_DIR}/${DESIGN_NAME}_trans_post.${tmax_file_ext}.faults.gz -retain_code
reset_state
report_summaries faults
set_faults -model stuck
read_faults ${RESULTS_DIR}/${DESIGN_NAME}_stuck_post.${tmax_file_ext}.faults.gz -retain_code
reset_state
report_summaries faults

# Run fault simulation on the resolved pattern set and save result.
set_faults -model transition

# Force ATPG Untestable faults to be simulated.
update_faults -reset_au
report_summaries faults

run_fault_sim
report_summaries faults
write_faults ${RESULTS_DIR}/${DESIGN_NAME}_trans_resolve.${tmax_file_ext}.faults.gz -all -replace -compress gzip

# Run fault simulation on the resolved pattern set and save result.
# This is an intermediate result and the static patterns must be fault
# simulated on this result to give the actual coverage.
set_faults -model stuck

# Force ATPG Untestable faults to be simulated.
update_faults -reset_au
report_summaries faults

run_fault_sim
report_summaries faults
write_faults ${RESULTS_DIR}/${DESIGN_NAME}_stuck_resolve.${tmax_file_ext}.faults.gz -all -replace -compress gzip

# Write the resolved pattern set. Please read the comments at the top of this file.
# If you need patterns in the 1999 version of STIL, instead of the default
# 2005 version, change to -format stil99 and remove -cellnames type.
write_patterns ${RESULTS_DIR}/${DESIGN_NAME}_resolve.${tmax_file_ext}.stil.gz -external -format stil -replace -compress gzip -cellnames type
#
# This setting is required to run write_testbench in batch mode:
setenv LTRAN_SHELL 1
write_testbench -input ${RESULTS_DIR}/${DESIGN_NAME}_resolve.${tmax_file_ext}.stil.gz -output ${RESULTS_DIR}/${DESIGN_NAME}_resolve.${tmax_file_ext}.maxtb -replace -config_file ${TMAX_SCRIPTS_ROOT}/tmax_maxtb_config.tcl -parameters " -v_file ${NETLIST_FILES} -v_lib ${TMAX_LIBRARY_FILES} -sim_script vcs -log ${RESULTS_DIR}/${DESIGN_NAME}_resolve.${tmax_file_ext}.maxtb.log "

##################################################################
# RESOLVE2: Resolve differences, fault simulate static patterns  #
##################################################################

build -force
read_image ${RESULTS_DIR}/${DESIGN_NAME}_stuck.${tmax_file_ext}.img

# A -num_processes setting is in the image file, so it must be reset here.
if { $TMAX_NUM_PROCS > 1 } {
   set_atpg -num_processes $TMAX_NUM_PROCS
   set_simulation -num_processes $TMAX_NUM_PROCS
} else {
   set_atpg -num_processes 0
   set_simulation -num_processes 0
}

# Resolve differences for static patterns if necessary.
# If there are no failures for these patterns, just set them.
set_patterns -external ${RESULTS_DIR}/${DESIGN_NAME}_stuck.${tmax_file_ext}.bin.gz -resolve_differences error2.diag

set_faults -model stuck
read_faults ${RESULTS_DIR}/${DESIGN_NAME}_stuck_resolve.${tmax_file_ext}.faults.gz -retain_code
report_summaries faults

# Run fault simulation on the resolved pattern set and save result.
# This is the final fault simulation result.
set_faults -model stuck

# Force ATPG Untestable faults to be simulated.
update_faults -reset_au
report_summaries faults

run_fault_sim
report_summaries faults
write_faults ${RESULTS_DIR}/${DESIGN_NAME}_stuck_resolve2.${tmax_file_ext}.faults.gz -all -replace -compress gzip

# Write the resolved pattern set. Please read the comments at the top of this file.
# If you need patterns in the 1999 version of STIL, instead of the default
# 2005 version, change to -format stil99 and remove -cellnames type.
write_patterns ${RESULTS_DIR}/${DESIGN_NAME}_resolve2.${tmax_file_ext}.stil.gz -external -format stil -replace -compress gzip -cellnames type
#
# This setting is required to run write_testbench in batch mode:
setenv LTRAN_SHELL 1
write_testbench -input ${RESULTS_DIR}/${DESIGN_NAME}_resolve2.${tmax_file_ext}.stil.gz -output ${RESULTS_DIR}/${DESIGN_NAME}_resolve2.${tmax_file_ext}.maxtb -replace -config_file ${TMAX_SCRIPTS_ROOT}/tmax_maxtb_config.tcl -parameters " -v_file ${NETLIST_FILES} -v_lib ${TMAX_LIBRARY_FILES} -sim_script vcs -log ${RESULTS_DIR}/${DESIGN_NAME}_resolve2.${tmax_file_ext}.maxtb.log "

##################################################################
#    End of TetraMAX RM Pattern Update script                    #
##################################################################

report_summaries cpu_usage memory_usage
quit
