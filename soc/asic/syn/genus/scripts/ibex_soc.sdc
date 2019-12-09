# Timing constraints

# system clock (inverted at pin xo)
create_clock \
    -name SYS_CLK \
    -period [expr 1.0e12 / 50.0e6] \
    -waveform [list [expr 0.5e12 / 50.0e6] [expr 1.0e12 / 50.0e6]] \
    [get_ports {xo}]

set_input_delay -clock_fall -clock [get_clocks SYS_CLK] 1000.0 [get_ports {ext_rst_n gpio}]

set_output_delay -clock_fall -clock [get_clocks SYS_CLK] 0.0 [get_ports {gpio}]

#set_false_path -from [all_inputs] -to [get_clocks {SYS_CLK}]

#set_false_path -from [get_clocks {SYS_CLK}] -to [all_outputs]



# JTAG
create_clock \
    -name TCK \
    -period [expr 1.0e12 / 10.0e6] \
    [get_ports {tck}]

set_input_delay -clock_fall -clock [get_clocks TCK] 0.0 [get_ports {trst_n tms tdi}]

set_output_delay -clock [get_clocks TCK] 0.0 [get_ports {tdo}]



# clock groups
set_clock_groups -asynchronous -group {SYS_CLK} -group {TCK}

# pin constraints
set_input_transition 2000.0 [get_ports {ext_rst_n gpio test_en vpd trst_n tms tdi}]

set_load 25.0 [get_ports {gpio}]
set_load 90.0 [get_ports {tdo}]

set_case_analysis 0 [get_ports {test_en vpd}]
