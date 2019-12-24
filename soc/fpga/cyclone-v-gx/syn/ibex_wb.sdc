## Generated SDC file "ibex_wb.out.sdc"

## Copyright (C) 2019  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 19.1.0 Build 670 09/22/2019 SJ Lite Edition"

## DATE    "Sun Dec 22 13:16:52 2019"

##
## DEVICE  "5CGXFC5C6F27C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {SYS_CLK} -period 20.000 -waveform { 0.000 10.000 } [get_ports { CLOCK_50_B5B }]

create_clock -name {TCK} -period 100.000 -waveform { 0.000 50.000 } [get_ports { GPIO[2] }]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {SYS_CLK}] -rise_to [get_clocks {SYS_CLK}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {SYS_CLK}] -rise_to [get_clocks {SYS_CLK}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {SYS_CLK}] -fall_to [get_clocks {SYS_CLK}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {SYS_CLK}] -fall_to [get_clocks {SYS_CLK}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {SYS_CLK}] -rise_to [get_clocks {SYS_CLK}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {SYS_CLK}] -rise_to [get_clocks {SYS_CLK}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {SYS_CLK}] -fall_to [get_clocks {SYS_CLK}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {SYS_CLK}] -fall_to [get_clocks {SYS_CLK}] -hold 0.060  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -clock_fall -clock [get_clocks TCK] 0.0 [get_ports {GPIO[0] GPIO[1] GPIO[20]}]



#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock [get_clocks TCK] 0.0 [get_ports {GPIO[19]}]



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group {SYS_CLK} -group {TCK}


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_ports {CPU_RESET_n}]

set_false_path -to [get_ports {LEDG*}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

