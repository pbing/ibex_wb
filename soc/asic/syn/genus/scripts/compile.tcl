#### Template Script for RTL->Gate-Level Flow (generated from GENUS 19.11-s087_1)

####################################################################
## Load Design
####################################################################



#### Including setup file (root attributes & setup variables).
include ./scripts/setup.tcl

read_hdl -language sv [list ibex_pkg.sv \
                            dm_pkg.sv \
                            wb_pkg.sv \
                            ../../rtl/prim_clock_gating.sv \
                            cdc_2phase.sv \
                            cluster_clock_inverter.sv \
                            core.sv \
                            core2wb.sv \
                            core_if.sv \
                            debug_rom.sv \
                            dft_wrapper.sv \
                            dm_csrs.sv \
                            dm_mem.sv \
                            dm_sba.sv \
                            dm_top.sv \
                            dmi_cdc.sv \
                            dmi_jtag.sv \
                            dmi_jtag_tap.sv \
                            fifo_v2.sv \
                            fifo_v3.sv \
                            ibex_alu.sv \
                            ibex_compressed_decoder.sv \
                            ibex_controller.sv \
                            ibex_core.sv \
                            ibex_cs_registers.sv \
                            ibex_decoder.sv \
                            ibex_ex_block.sv \
                            ibex_fetch_fifo.sv \
                            ibex_id_stage.sv \
                            ibex_if_stage.sv \
                            ibex_load_store_unit.sv \
                            ibex_multdiv_fast.sv \
                            ibex_multdiv_slow.sv \
                            ibex_prefetch_buffer.sv \
                            ibex_register_file_ff.sv \
                            ibex_soc.sv \
                            pulp_clock_mux2.sv \
                            slave2wb.sv \
                            sync_reset.sv \
                            wb_dm_top.sv \
                            wb_gpio.sv \
                            wb_ibex_core.sv \
                            wb_if.sv \
                            wb_interconnect_sharedbus.sv \
                            wb_spram16384x32.sv \
                           ]


elaborate $DESIGN
puts "Runtime & Memory after 'read_hdl'"
time_info Elaboration

check_design -unresolved

####################################################################
## Constraints Setup
####################################################################

read_sdc ${DESIGN}.sdc
puts "The number of exceptions is [llength [vfind "design:$DESIGN" -exception *]]"

#set_db "design:$DESIGN" .force_wireload <wireload name>

if {![file exists ${_LOG_PATH}]} {
  file mkdir ${_LOG_PATH}
  puts "Creating directory ${_LOG_PATH}"
}

if {![file exists ${_OUTPUTS_PATH}]} {
  file mkdir ${_OUTPUTS_PATH}
  puts "Creating directory ${_OUTPUTS_PATH}"
}

if {![file exists ${_REPORTS_PATH}]} {
  file mkdir ${_REPORTS_PATH}
  puts "Creating directory ${_REPORTS_PATH}"
}
check_timing_intent


###################################################################################
## Define cost groups (clock-clock, clock-output, input-clock, input-output)
###################################################################################

## Uncomment to remove already existing costgroups before creating new ones.
## delete_obj [vfind /designs/* -cost_group *]

if {[llength [all_registers]] > 0} {
  define_cost_group -name I2C -design $DESIGN
  define_cost_group -name C2O -design $DESIGN
  define_cost_group -name C2C -design $DESIGN
  path_group -from [all_registers] -to [all_registers] -group C2C -name C2C
  path_group -from [all_registers] -to [all_outputs] -group C2O -name C2O
  path_group -from [all_inputs]  -to [all_registers] -group I2C -name I2C
}

define_cost_group -name I2O -design $DESIGN
path_group -from [all_inputs]  -to [all_outputs] -group I2O -name I2O
foreach cg [vfind / -cost_group *] {
  report_timing -group [list $cg] >> $_REPORTS_PATH/${DESIGN}_pretim.rpt
}

#### Including DFT setup. (DFT design attributes & scan_chain, test clock definition etc..)
include ./scripts/dft.tcl


#### To turn off sequential merging on the design
#### uncomment & use the following attributes.
##set_db / .optimize_merge_flops false
##set_db / .optimize_merge_latches false
#### For a particular instance use attribute 'optimize_merge_seqs' to turn off sequential merging.


####################################################################################################
## Synthesizing to generic
####################################################################################################


set_db / .syn_generic_effort $GEN_EFF
syn_generic
puts "Runtime & Memory after 'syn_generic'"
time_info GENERIC
report_dp > $_REPORTS_PATH/generic/${DESIGN}_datapath.rpt
write_snapshot -outdir $_REPORTS_PATH -tag generic
report_summary -directory $_REPORTS_PATH




######################################################################################################
## Optional DFT commands (section 1)
######################################################################################################

#############
## Identify Functional Shift Registers
#############
identify_shift_register_scan_segments

#############
## Add testability logic as required
#############
#insert_dft shadow_logic -around <instance> -mode <no_share|share|bypass> -test_control <TestModeObject>
#insert_dft test_point -location <port|pin> -test_control <test_signal> -type <string>

#######################
## Add Boundary Scan and Programmable MBIST logic
########################

## Uncomment to define the existing 3rd party TAP controller to be used as the master controller for
## DFT logic such as boundary-scan, compression, Programmable MBIST and ptam.
#define_dft jtag_macro -name <objectName> ....

## Define JTAG Instructions for the existing Macro or when building the JTAG_Macro with user-defined instructions.
## ... For current release, name the mandatory JTAG instructions as: EXTEST, SAMPLE, PRELOAD, BYPASS

##define_jtag_instruction_register -name <string> -length <integer> -capture <string>
##define_jtag_instruction -name <string> -opcode <string> ;# [-register <string> -length <integer>] [-private]

## Uncomment to build a JTAG_Macro with Programmable MBIST instructions.
## Names of the mandatory instructions are: MBISTTPN, MBISTSCH, MBISTCHK
#define_jtag_instruction -name <string> -opcode <string> -register <string> -length <integer>

## Uncomment to define the MBIST clock if inserting Programmable MBIST logic
#define_mbist_clock -name <objectNameOfMBISTClock> -period <integer> <port> ..

## Uncomment to read memory view files for programmable MBIST
#read_pmbist_memory_view -cdns_memory_view_file <string> -arm_mbif <string> -directory <string> <design>

#insert_dft boundary_scan -tck <tckpin> -tdi <tdipin> -tms <tmspin> -trst <trstpin> -tdo <tdopin> -exclude_ports <list of ports excluded from boundary register> -preview

## Uncomment to read block-level interface files for programmable MBIST
#read_dft_pmbist_interface_files -directory <locationOfInterfaceFiles> <lib_cell|module|design>

## Uncomment to insert Programmable BIST (PMBIST) for memories
#add_pmbist -config_file <filename> -connect_to_jtag -directory <PMBISTworkDir> -dft_cfg_mode <dft_configuration_mode> -amu_location <design|module|inst|hinst> ..

## Uncomment to write interface files for programmable MBIST
#write_dft_pmbist_interface_files -directory <locationOfInterfaceFiles> [<design>]

## Uncomment to write out data and script files to generate PMBIST patterns
#write_dft_pmbist_testbench [-create_embedded_test_options <string>] [-irun_options <string>] [-directory <string>] [-testbench_directory <string>] [-ncsim_library <string>] [-script_only] [-no_deposit_script] [-no_build_model] [<design>]

##Write out BSDL file
#write_bsdl -bsdlout <BSDLfileName> -directory <work directory>


####################################################################################################
## Synthesizing to gates
####################################################################################################


## Add '-auto_identify_shift_registers' to 'syn_map' to automatically
## identify functional shift register segments. Not applicable for n2n flow.
set_db / .syn_map_effort $MAP_OPT_EFF
syn_map
puts "Runtime & Memory after 'syn_map'"
time_info MAPPED
write_snapshot -outdir $_REPORTS_PATH -tag map
report_summary -directory $_REPORTS_PATH
report_dp > $_REPORTS_PATH/map/${DESIGN}_datapath.rpt


foreach cg [vfind / -cost_group *] {
  report_timing -group [list $cg] > $_REPORTS_PATH/${DESIGN}_[vbasename $cg]_post_map.rpt
}


write_do_lec -revised_design fv_map -logfile ${_LOG_PATH}/rtl2intermediate.lec.log > ${_OUTPUTS_PATH}/rtl2intermediate.lec.do

## ungroup -threshold <value>

#######################################################################################################
## Optimize Netlist
#######################################################################################################
set_db / .syn_opt_effort $MAP_OPT_EFF
syn_opt
write_snapshot -outdir $_REPORTS_PATH -tag syn_opt
report_summary -directory $_REPORTS_PATH

puts "Runtime & Memory after 'syn_opt'"
time_info OPT

foreach cg [vfind / -cost_group *] {
  report_timing -group [list $cg] > $_REPORTS_PATH/${DESIGN}_[vbasename $cg]_post_opt.rpt
}

######################################################################################################
## Optional additional DFT commands. (section 2)
######################################################################################################

identify_multibit_cell_abstract_scan_segments 

## Re-run DFT rule checks
## check_dft_rules [-advanced]
check_dft_rules -advanced

## Build the full scan chanins
## connect_scan_chains [-preview] [-auto_create_chains]
## report dft_chains > $_REPORTS_PATH/${DESIGN}-DFTchains
connect_scan_chains
report_scan_chains > $_REPORTS_PATH/${DESIGN}-DFTchains

## Inserting Compression logic
## compress_scan_chains -ratio <integer>  -mask <string> [-auto_create] [-preview]
##report dft_chains > $_REPORTS_PATH/${DESIGN}-DFTchains_compression
## Reapply CPF rules
#commit_cpf

#######################################################################################################
## Optimize Netlist
#######################################################################################################

## Uncomment to remove assigns & insert tiehilo cells during Incremental synthesis
##set_db / .remove_assigns true
##set_remove_assign_options -buffer_or_inverter <libcell> -design <design|subdesign>
##set_db / .use_tiehilo_for_const <none|duplicate|unique>

## An effort of low was selected to minimize runtime of incremental opto.
## If your timing is not met, rerun incremental opto with a different effort level
set_db / .syn_opt_effort low
syn_opt -incremental
write_snapshot -outdir $_REPORTS_PATH -tag syn_opt_low_incr
report_summary -directory $_REPORTS_PATH
puts "Runtime & Memory after 'syn_opt'"
time_info INCREMENTAL_POST_SCAN_CHAINS


#############################################
## DFT Reports
#############################################

report_scan_setup > $_REPORTS_PATH/${DESIGN}-DFTsetup_final
write_scandef > ${_OUTPUTS_PATH}/${DESIGN}-scanDEF
write_dft_abstract_model > ${_OUTPUTS_PATH}/${DESIGN}-scanAbstract
write_hdl -abstract > ${_OUTPUTS_PATH}/${DESIGN}-logicAbstract
write_script -analyze_all_scan_chains > ${_OUTPUTS_PATH}/${DESIGN}-writeScript-analyzeAllScanChains
## check_atpg_rules -library <Verilog simulation library files> -compression -directory <Encounter Test workdir directory>
## write_et_bsv -library <Verilog structural library files> -directory $ET_WORKDIR
#write_dft_atpg -library <Verilog structural library files> -compression -directory $ET_WORKDIR
set_db / .lp_insert_clock_gating true ;# for report_clock_gating
write_dft_atpg \
    -library {../../lib/modus/RAM16384X32.v \
              /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250LT07/CS251DN/V1.0/verilog/cs251dn_uc.v \
              /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250L_CB2EGPIO_V1.0p2/verilog/CS250L_CB2EGPIO.v \
              /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_IP/xtal/veri/CS251/common/sim/std/IOCAXLBHFRA00.v \
              /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_IP/xtal/veri/CS251/common/sim/std/IOCAXLIINNA00.v} \
    -build_model_options {-definemacro FAST_FUNC}


######################################################################################################
## write backend file set (verilog, SDC, config, etc.)
######################################################################################################



report_dp > $_REPORTS_PATH/${DESIGN}_datapath_incr.rpt
report_messages > $_REPORTS_PATH/${DESIGN}_messages.rpt
write_snapshot -outdir $_REPORTS_PATH -tag final
report_summary -directory $_REPORTS_PATH

write_hdl  > ${_OUTPUTS_PATH}/${DESIGN}.v
## write_script > ${_OUTPUTS_PATH}/${DESIGN}.script
write_sdc > ${_OUTPUTS_PATH}/${DESIGN}.sdc


#################################
### write_do_lec
#################################


write_do_lec -golden_design fv_map -revised_design ${_OUTPUTS_PATH}/${DESIGN}.v -logfile  ${_LOG_PATH}/intermediate2final.lec.log > ${_OUTPUTS_PATH}/intermediate2final.lec.do
##Uncomment if the RTL is to be compared with the final netlist..
##write_do_lec -revised_design ${_OUTPUTS_PATH}/${DESIGN}.v -logfile ${_LOG_PATH}/rtl2final.lec.log > ${_OUTPUTS_PATH}/rtl2final.lec.do

puts "Final Runtime & Memory."
time_info FINAL
puts "============================"
puts "Synthesis Finished ........."
puts "============================"

file copy -force [get_db / .stdout_log] ${_LOG_PATH}/.

quit
