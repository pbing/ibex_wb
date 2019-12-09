####################################################################################
#             MAIN SETUP (root attributes & setup variables)                       #
####################################################################################
##############################################################################
## Preset global variables and attributes
##############################################################################


set DESIGN <design name>
set GEN_EFF medium
set MAP_OPT_EFF high
set DATE [clock format [clock seconds] -format "%b%d-%T"] 
set _OUTPUTS_PATH outputs_${DATE}
set _REPORTS_PATH reports_${DATE}
set _LOG_PATH logs_${DATE}
##set ET_WORKDIR <ET work directory>
set_db / .init_lib_search_path {. ./lib} 
set_db / .script_search_path {. <path>} 
set_db / .init_hdl_search_path {. ./rtl} 
##Uncomment and specify machine names to enable super-threading.
##set_db / .super_thread_servers {<machine names>} 
##For design size of 1.5M - 5M gates, use 8 to 16 CPUs. For designs > 5M gates, use 16 to 32 CPUs
##set_db / .max_cpus_per_server 8

##Default undriven/unconnected setting is 'none'.  
##set_db / .hdl_unconnected_value 0 | 1 | x | none

set_db / .information_level 7 

###############################################################
## Library setup
###############################################################


read_libs <libname>
read_physical -lef <lef file(s)>
## Provide either cap_table_file or the qrc_tech_file
#set_db / .cap_table_file <file> 
read_qrc <qrcTechFile name>
##generates <signal>_reg[<bit_width>] format
#set_db / .hdl_array_naming_style %s\[%d\] 
## 


set_db / .lp_insert_clock_gating true 

