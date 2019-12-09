####################################################################################
#             MAIN SETUP (root attributes & setup variables)                       #
####################################################################################
##############################################################################
## Preset global variables and attributes
##############################################################################


set DESIGN ibex_soc
set GEN_EFF medium
set MAP_OPT_EFF high
set DATE [clock format [clock seconds] -format "%b%d-%T"]
set _OUTPUTS_PATH outputs
set _REPORTS_PATH reports
set _LOG_PATH logs
#set ET_WORKDIR test_scripts

set_db init_lib_search_path {../../lib/lef \
                             ../../memory/ramcell/dc.pg_pin \
                             ../../memory/ramcell/lef/v5.6 \
                             /project/processes/Fujitsu/55NM/CS250L/design/EDIS_TF_R1.01/7S0G1 \
                             /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250LT07/CS251DN/V1.0/lef \
                             /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250LT07/CS251DN/V1.0/liberty/nldm \
                             /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250LT07/CS251DNC/V1.0/lef \
                             /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250LT07/CS251DNC/V1.0/liberty/nldm \
                             /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250LT07/CS251DZ/V1.0/lef \
                             /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250LT07/CS251DZ/V1.0/liberty/nldm \
                             /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250L_CB2EGPIO_V1.0p2/lef \
                             /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_CS250L_CB2EGPIO_V1.0p2/liberty/nldm \
                             /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_IP/pll/lib \
                             /project/processes/Fujitsu/55NM/CS250L/lib/MIFS_IP/xtal/lib}

set_db / .script_search_path {./scripts}

set_db / .init_hdl_search_path {../../../../common_cells/src \
                                ../../../../common_cells/src/deprecated \
                                ../../../../ibex/rtl \
                                ../../../../pulpino/rtl/components \
                                ../../../../riscv-dbg/debug_rom \
                                ../../../../riscv-dbg/src \
                                ../../../../rtl \
                                ../../../common/rtl \
                                ../../rtl}

##Uncomment and specify machine names to enable super-threading.
##set_db / .super_thread_servers {<machine names>}
set_db / .super_thread_servers {localhost}

## LSF
#set_db / .super_thread_servers {batch}
#set_db / .super_thread_batch_command {bsub -R span\[hosts=1\] -n 4,8}
#set_db super_thread_kill_command {bkill}

##For design size of 1.5M - 5M gates, use 8 to 16 CPUs. For designs > 5M gates, use 16 to 32 CPUs
set_db / .max_cpus_per_server 8

##Default undriven/unconnected setting is 'none'.
##set_db / .hdl_unconnected_value 0 | 1 | x | none

#set_db / .information_level 7

###############################################################
## Library setup
###############################################################
if false {
    # SVT and LVT
    read_libs {cs251dn_uc_core_s_p125_1012v.lib \
               cs251dn_uc_nscan_s_p125_1012v.lib \
               cs251dn_uc_scan4_s_p125_1012v.lib \
               cs251dn_uc_scan_s_p125_1012v.lib \
               cs251dz_uc_core_s_p125_1012v.lib \
               cs251dz_uc_nscan_s_p125_1012v.lib \
               cs251dz_uc_scan4_s_p125_1012v.lib \
               cs251dz_uc_scan_s_p125_1012v.lib \
               CS250L_CB2EGPIO_s_p125_m_1012v_30v.lib \
               cs251_socketize_ip_APLL_PL21LS02_APLL_s_p125_1012v.lib \
               cs251_251CA_XTAL_33_io_IOFVD_s_p125_m_1012v_30v.lib \
               cs251_cc_s_p125_1012v.lib}

    read_physical -lef {tech.lef \
                        cs251dn_uc.lef \
                        cs251dz_uc.lef \
                        CS250L_CB2EGPIO.lef \
                        pll.lef \
                        xtal.lef \
                        RAMROM.lef}
} else {
    # SVT only
    read_libs {cs251dn_uc_core_s_p125_1012v.lib \
               cs251dn_uc_nscan_s_p125_1012v.lib \
               cs251dn_uc_scan4_s_p125_1012v.lib \
               cs251dn_uc_scan_s_p125_1012v.lib \
               CS250L_CB2EGPIO_s_p125_m_1012v_30v.lib \
               cs251_socketize_ip_APLL_PL21LS02_APLL_s_p125_1012v.lib \
               cs251_251CA_XTAL_33_io_IOFVD_s_p125_m_1012v_30v.lib \
               cs251_cc_s_p125_1012v.lib}                   

    read_physical -lef {tech.lef \
                        cs251dn_uc.lef \
                        CS250L_CB2EGPIO.lef \
                        pll.lef \
                        xtal.lef \
                        RAMROM.lef}
}

## Provide either cap_table_file or the qrc_tech_file
#set_db / .cap_table_file /project/processes/Fujitsu/55NM/CS250L/design/QRC/CS250L_7S0G1/typ/CS250L_7S0G1_typ_1513s052.captable
read_qrc /project/processes/Fujitsu/55NM/CS250L/design/QRC/CS250L_7S0G1/typ/CS250L_7S0G1_typ_1513s052.qrctechfile

##generates <signal>_reg[<bit_width>] format
#set_db / .hdl_array_naming_style %s\[%d\]

set_db / .lp_insert_clock_gating false
set_db / .hdl_track_filename_row_col true ;# allow tracking of any DFT rule violations 
set_db / .use_scan_seqs_for_non_dft false
set_db / .use_multibit_cells true
set_db / .auto_ungroup none

set_dont_use [get_lib_cells {SCC?CKAND2* SCC?CKBUFB* SCC?CKBUFC* SCC?CKINVB* SCC?CKINVC*}]
