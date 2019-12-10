puts "RM-Info: Running script [info script]\n"
##################################################################
# TetraMAX Reference Methodology SPF Update Script               #
# Script: tmax_update_spf.tcl                                    #
# Version: O-2018.06-SP2 (October 8, 2018)                       #
# Copyright (C) 2009-2018 Synopsys, Inc. All rights reserved.    #
##################################################################

# Use this script to update the timing in the STIL protocol file.
# This allows more realistic timing to be used for dynamic tests.

# First the STIL protocol file must be read in:
read_drc $PROTOCOL_FILE

# If compression-mode DRC fails with R rule violations or M464 messages,
# but passed with the original SPF, this command may be needed instead:
#read_drc $PROTOCOL_FILE -reorder_xtol_signals

# With generic capture procedures, the waveform tables are:
#   _default_WFT_ is used for test_setup and load_unload
#       (don't update unless using "set_delay -launch_cycle last_shift")
#   _multiclock_capture_WFT_ is used for non-timing-critical capture cycles
#       used to propagate fault effects through nonscan cells
#       (don't update unless using "set_delay -launch_cycle last_shift")
#   _allclock_launch_WFT_ is used for the launch cycle when using external
#       clocks (should be updated)
#   _allclock_capture_WFT_ is used for the capture cycle when using external
#       clocks (should be updated)
#   _allclock_launch_capture_WFT_ is only used by Full Sequential ATPG
#       (don't update unless using Full Sequential ATPG)

# If picosecond timing is used, the scale must be changed first.
# Otherwise, all timing specifications will be truncated to nanoseconds.
# The same time unit should be used for all waveform tables.
# Add -unit ps to all write_timing_constraints commands if appropriate.
update_scale -wft _default_WFT_ -unit ps
update_scale -wft _multiclock_capture_WFT_ -unit ps
update_scale -wft _allclock_launch_WFT_ -unit ps
update_scale -wft _allclock_capture_WFT_ -unit ps
update_scale -wft _allclock_launch_capture_WFT_ -unit ps

# The time unit for update_clock or update_wft applies only to that command.
# If -unit differs from the WFT time unit, the numbers are scaled.
#
# Clocks should pulse late in _allclock_launch_WFT_:
update_clock -wft _allclock_launch_WFT_ -clock <clk20ns> -pulse {85 90} -unit ns
update_clock -wft _allclock_launch_WFT_ -clock <clk5ns> -pulse {97500 99000} -unit ps

# Clocks should pulse early in _allclock_capture_WFT_:
update_clock -wft _allclock_capture_WFT_ -clock <clk20ns> -pulse {5 10} -unit ns
update_clock -wft _allclock_capture_WFT_ -clock <clk5ns> -pulse {2500 4000} -unit ps

# The update_wft command can be used to change the period, but this is not
# recommended. Moving the _allclock_launch_WFT_ and _allclock_capture_WFT_
# pulses close to the edges of the period results in the same timing.
# Fast Sequential ATPG does not generate transition tests that launch from
# different clock cycles, or that capture on different clock cycles.
#
# The strobe time for _allclock_capture_WFT_ must be set before the clock.
update_wft -wft _allclock_capture_WFT_ -strobe 1500 -unit ps
#update_wft -wft _allclock_capture_WFT_ -period 20000 -strobe 1500 -unit ps

# Write the new STIL protocol file and use it for run_drc:
write_drc_file ${RESULTS_DIR}/${DESIGN_NAME}_updated.${tmax_file_ext}.spf -replace
set PROTOCOL_FILE "${RESULTS_DIR}/${DESIGN_NAME}_updated.${tmax_file_ext}.spf"

##################################################################
#    End of TetraMAX RM Update SPF script                        #
##################################################################
puts "RM-Info: Completed script [info script]\n"
