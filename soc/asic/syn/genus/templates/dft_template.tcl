##########################################################################################
#         DFT SETUP (DFT design attributes & scan_chain, test clock definition ...)      #
##########################################################################################
##################################################################################################
## DFT Setup
##################################################################################################

set_db / .dft_scan_style muxed_scan 

## Uncomment for clocked_LSSD 
#set_db / .dft_scan_style clocked_lssd_scan
#define_dft scan_clock_a -name <scanClockAObject> -period <delay in pico sec, default 50000> -rise <integer> -fall <integer> <portOrpin> 
#define_dft scan_clock_b -name <scanClockAObject> -period <delay in pico sec, default 50000> -rise <integer> -fall <integer> <portOrpin> 

set_db / .dft_prefix DFT_ 
# For VDIO customers, it is recommended to set the value of the next two attributes to false.
set_db / .dft_identify_top_level_test_clocks true 
set_db / .dft_identify_test_signals true 

set_db / .dft_identify_internal_test_clocks false 
set_db / .use_scan_seqs_for_non_dft false 

set_db "design:$DESIGN" .dft_scan_map_mode tdrc_pass 
set_db "design:$DESIGN" .dft_connect_shift_enable_during_mapping tie_off 
set_db "design:$DESIGN" .dft_connect_scan_data_pins_during_mapping loopback 
set_db "design:$DESIGN" .dft_scan_output_preference auto 
set_db "design:$DESIGN" .dft_lockup_element_type preferred_level_sensitive 
#set_db "design:$DESIGN" .dft_mix_clock_edges_in_scan_chains true 

#set_db <instance or subdesign> .dft_dont_scan true 
#set_db "<from pin> <inverting|non_inverting>" .dft_controllable <to pin>

define_dft test_clock -name <testClockObject> -domain <testClockDomain> -period <delay in pico sec, default 50000>  -rise <integer> -fall <integer> <portOrpin>
define_dft shift_enable -name <shiftEnableObject> -active <high|low> <portOrpin> [-create_port]
define_dft test_mode -name <testModeObject> -active <high|low> <portOrpin> [-create_port] [-shared_in]

## If you intend to insert compression logic, define your compression test signals or clocks here:
## define_dft test_mode...  [-shared_in]
## define_dft test_clock...
#########################################################################
## Segments Constraints (support fixed, floating, preserved and abstract)
## only showing preserved, and abstract segments as these are most often used
#############################################################################

##define_dft preserved_segment -name <segObject> -sdi <pin|port|subport> -sdo <pin|port|subport> -analyze 
## If the block is complete from a DFT perspective, uncomment to prevent any non-scan flops from being scan-replaced
#set_db [filter dft_mapped false [vfind /designs/* -instance <subDesignInstance>/instances_seq/*]] dft_dont_scan true 

##define_dft abstract_segment -name <segObject> <-module|-insts|-libcell> -sdi <pin> -sdo <pin> -clock_port <pin> [-rise|-fall] -shift_enable_port <pin> -active <high|low> -length <integer> 
## Uncomment if abstract segments are modeled in CTL format
##read_dft_abstract_model -ctl <file>


define_dft scan_chain -name <ChainName> -sdi <topLeveLSDIPort>	-sdo <topLevelSDOPort> [-hookup_pin_sdi <coreSideSDIDrivingPin>] [-hookup_pin_sdo <coreSideSDOLoadPin>] [-shift_enable <ShiftEnableObject>] [-shared_output | -non_shared_output] [-terminal_lockup <level | edge>]

## Run the DFT rule checks
check_dft_rules > $_REPORTS_PATH/${DESIGN}-tdrcs
report dft_registers > $_REPORTS_PATH/${DESIGN}-DFTregs
report dft_setup > $_REPORTS_PATH/${DESIGN}-DFTsetup_tdrc

## Fix the DFT Violations
## Uncomment to fix dft violations
## set numDFTviolations [check_dft_rules]
## if {$numDFTviolations > "0"} {
##   report dft_violations > $_REPORTS_PATH/${DESIGN}-DFTviols  
##   fix_dft_violations -async_set -async_reset [-clock] -test_control <TestModeObject>
##   check_dft_rules
## }

##  Run the Advanced DFT rule checks to identify:
## ...  x-source generators, internal tristate nets, and clock and data race violations
## Note:  tristate nets are reported for busses in which the enables are driven by
## tristate devices.  Use 'check_design' to report other types of multidriven nets.

check_design -multiple_driver
check_dft_rules -advanced  > $_REPORTS_PATH/${DESIGN}-Advancedtdrcs
report dft_violations [-tristate] [-xsource] [-xsource_by_instance] > $_REPORTS_PATH/${DESIGN}-AdvancedDFTViols

## Fix the Avanced DFT Violations
## ... x-source violations are fixed by inserting registered shadow logic
## ... tristate net violations are fixed by selectively enabling and disabiling the tristate enable signals
##  in shift-mode. 
## ... clock and data race violations are not auto-fixed by the tool.
## Note: The fixing of tristate net violations using the 'fix_dft_violations -tristate_net' command
## should be deferred until a full-chip representation of the design is available.

## Uncomment to fix x-source violations (or alternatively, insert the shadow logic using the
## 'insert_dft shadow_logic' command).
#fix_dft_violations -xsource -test_control <TestModeObject> -test_clock_pin <ClockPinOrPort> [-exclude_xsource <instance>]
#check_dft_rules -advanced

## Update DFT status
## report dft_registers > $_REPORTS_PATH/${DESIGN}-DFTregs_tdrc
## report dft_setup > $_REPORTS_PATH/${DESIGN}-DFTsetup_tdrc
