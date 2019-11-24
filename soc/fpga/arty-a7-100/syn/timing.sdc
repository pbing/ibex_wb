# Timing constraints

create_clock -name CLK100MHZ -period 10.000 -waveform {0.000 5.000} [get_ports {clk100mhz}]

create_generated_clock -name CLK25MHZ -source [get_ports {clk100mhz}] -divide_by 4 [get_pins {crg/clkdiv/O}]

set_false_path -from [all_inputs] -to [get_clocks {CLK100MHZ CLK25MHZ}]

set_false_path -from [get_clocks {CLK25MHZ}] -to [all_outputs]

# JTAG
create_clock -period 100.000 -name TCK -waveform {0.000 50.000} [get_ports {tck}]

set_input_delay -clock_fall -clock [get_clocks TCK] 0.000 [get_ports {trst_n tms tdi}]

set_output_delay -clock [get_clocks TCK] 0.000 [get_ports {tdo}]

# clock groups
set_clock_groups -asynchronous -group {CLK100MHZ CLK25MHZ} -group TCK
