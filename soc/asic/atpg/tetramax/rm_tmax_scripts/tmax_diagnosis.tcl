
##################################################################
# TetraMAX Reference Methodology Diagnosis Example Script        #
# Script: tmax_diagnosis.tcl                                     #
# Version: O-2018.06-SP2 (October 8, 2018)                       #
# Copyright (C) 2010-2018 Synopsys, Inc. All rights reserved.    #
##################################################################

# This script is an example showing typical diagnosis flows.
# It should be customized as needed.

###############################################################
# SETUP: Settings for overall execution                       #
###############################################################

set_messages -log tmax_diagnosis.log -replace
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

###############################################################################
# PHYSICAL DATAPREP: Prepare data for physical diagnosis and open PHDS server #
###############################################################################

# Physical data preparation is time-consuming so it should be done in advance.
# This step starts a PHDS server process that remains running for future use.

# Change the value of TMAX_PHYSICAL_DATAPREP to TRUE to prepare physical data,
# then change it back to FALSE to run diagnosis.
set TMAX_PHYSICAL_DATAPREP FALSE

if { $TMAX_PHYSICAL_DATAPREP } {
   # Read LEF and DEF. The path to the LEF files must be provided.
   # The DEF file defaults to the output of the ICC RM (change if needed).
   set_physical_db -lef_dir <path_to_lef> -def_dir ${RESULTS_DIR}
   set_physical_db -top_def_file ${DESIGN_NAME}.output.def
   # Set the device name and version.
   set_physical_db -device [list ${DESIGN_NAME} "1"]

   # Create the PHDS database.
   set_physical_db -database ./PHDS
   write_physical_db -verbose -replace
   report_violations Y > ${REPORTS_DIR}/${DESIGN_NAME}_physical_db.rpt

   # Set the port number for PHDS access and start the server.
   # Avoid using an already-used port connection. Check using this command:
   #   ps -ef | grep DAPListener
   set_physical_db -port_number 9999
   open_physical_db

   # When the PHDS server is no longer required, stop it using this command:
   #   close_physical_db

   # Exit when physical data preparation is complete.
   report_summaries cpu_usage memory_usage
   quit
}

##################################################################
# READ FILES: Read image and pattern files                       #
##################################################################

# First, read the image used to generate the pattern being diagnosed:
read_image ${RESULTS_DIR}/${DESIGN_NAME}_trans.${tmax_file_ext}.img

# The set_diagnosis command cannot be used until after the image is read.
# Use the class-based candidate organization in the diagnosis report.
set_diagnosis -organization class
set_diagnosis -fault_type all
if { $TMAX_DEBUG_MODE } {
   set_diagnosis -verbose
}
# The -num_processes settings have no effect on the commands in this script.

# Set the pattern file, using the binary pattern set with diagnostics dictionary
# if available. The diagnostics dictionary can be created for transition or
# stuck-at faults, but not for other fault types.
# Pattern-based failure data can be diagnosed starting from binary patterns,
# but cycle-based failure data requires STIL or WGL patterns to be read.
# Binary patterns with diagnostics dictionary can be used to diagnose
# cycle-based failure data if STIL or WGL patterns are read before generating
# the diagnostics dictionary.
if { [file exists ${RESULTS_DIR}/${DESIGN_NAME}_trans.${tmax_file_ext}.dict.bin.gz ] } {
   set_patterns -external ${RESULTS_DIR}/${DESIGN_NAME}_trans.${tmax_file_ext}.dict.bin.gz
} else {
   set_patterns -external ${RESULTS_DIR}/${DESIGN_NAME}_trans.${tmax_file_ext}.bin.gz
}

# Make sure that simulation settings match those used for ATPG.
set_simulation -shift_cycles 1
#set_simulation -timing_exceptions_for_stuck_at
report_settings simulation

##################################################################
# DICTIONARY DATAPREP: Prepare the diagnostics dictionary        #
##################################################################

# Creating the diagnostics dictionary is time-consuming so it should be
# done in advance. Transition or stuck-at faults must be used for the
# diagnostics dictionary

# Change the value of TMAX_DICTIONARY_DATAPREP to TRUE to create the 
# diagnostics dictionary, then change it back to FALSE to run diagnosis.
set TMAX_DICTIONARY_DATAPREP FALSE

if { $TMAX_DICTIONARY_DATAPREP } {
   set_faults -model transition
   read_faults ${RESULTS_DIR}/${DESIGN_NAME}_trans_post.${tmax_file_ext}.faults.gz
   report_summaries
   set_faults -store_dictionary 10
   run_fault_sim
   report_summaries
   write_patterns ${RESULTS_DIR}/${DESIGN_NAME}_trans.${tmax_file_ext}.dict.bin.gz -format binary -external -replace -compress gzip

   # Exit when diagnostics dictionary data preparation is complete.
   report_summaries cpu_usage memory_usage
   quit
}

##################################################################
# DIAGNOSIS: Run diagnosis for routine failures                  #
##################################################################

# To use physical diagnosis, connect to the same PHDS server that was opened
# in the PHYSICAL DATAPREP step. The localhost argument specifies the PHDS
# server is the same host running tmax. Change it if the hosts are different.
#set_physical_db -hostname localhost -port_number 9999
#set_physical_db -device [list ${DESIGN_NAME} "1"]

# This setting increases bridge accuracy at the expense of runtime.
#set_physical -via_bridges

# Name mismatches between the logical and physical databases may exist.
# This should be checked the first time the physical database is used.
# A sample allows the type of any name mismatch to be discerned.
#match_names -sample 1 -verbose

# If consistent name mismatches are found, a name matching rule must be
# defined to compensate. This name matching rule must then be run on the
# full design. This example shows a case where the logical design has an
# extra level of hierarchy compared to the physical design.
#set_match_names -sub_prefix {"TopLogical/" ""} 
#match_names > ${RESULTS_DIR}/${DESIGN_NAME}_match_names.rpt

# The failure file is required. To understand the diagnosis flow before
# tester data is available, you can generate failure files in TetraMAX.
# These examples show different fault types, but the bracketed information
# must be replaced by design-specific data:
#run_simulation -failure_file datalogs/fail_stuck.log -stuck { 0 <pin_pathname> } -replace
#run_simulation -failure_file datalogs/fail_bridge.log -bridge { adom <pin_pathname1> <pin_pathname2> } -replace
#run_simulation -failure_file datalogs/fail_chain.log -fast { r <chain> <position> } -replace

# Failure files from ATE may not be ideal matches for TetraMAX's expectations.
# It is common to have a cycle offset. If so, provide the number to use:
#set_diagnosis -cycle_offset <integer>
# It is common for the ATE failure log to be limited to the first several
# failing cycles. If this limit is known, provide it:
#set_diagnosis -failing_cycles_limit <integer>
# If the failure log is incomplete but the limit is not known, use this setting:
#set_diagnosis -incomplete_failures

# To limit time spent per diagnosis, either because the design is large
# or you are doing volume diagnosis on many parts, set a time limit.
# This requires "set_commands noabort":
#set_diagnosis -time_limit <seconds>
#set_commands noabort

# Perform diagnosis on the failure file and generate data for Yield Exporer.
# Multiple runs using different failure files with the same pattern may be
# run in sequence:
run_diagnosis datalogs/fail1.log
write_ydf ${RESULTS_DIR}/${DESIGN_NAME}_diagnosis.ydf -replace
run_diagnosis datalogs/fail2.log
write_ydf ${RESULTS_DIR}/${DESIGN_NAME}_diagnosis.ydf -append
run_diagnosis datalogs/fail3.log
write_ydf ${RESULTS_DIR}/${DESIGN_NAME}_diagnosis.ydf -append

# Report on candidates reported by run_diagnosis:
#report_physical -pin <candidate_pin_pathname>

##################################################################
#    End of TetraMAX RM Diagnosis Example script                 #
##################################################################

report_summaries cpu_usage memory_usage
quit
