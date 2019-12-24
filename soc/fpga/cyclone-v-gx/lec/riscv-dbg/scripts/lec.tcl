read_design \
    -enumconstraint -define SYNTHESIS  -merge bbox -golden -lastmod -noelab \
    -systemverilog \
    {../../../../../../riscv-dbg/src/dm_pkg.sv \
     ../../../../../../riscv-dbg/src/dm_csrs.sv \
     ../../../../../../riscv-dbg/src/dm_mem.sv \
     ../../../../../../riscv-dbg/src/dm_sba.sv \
     ../../../../../../riscv-dbg/src/dm_top.sv \
     ../../../../../../riscv-dbg/src/dmi_cdc.sv \
     ../../../../../../riscv-dbg/src/dmi_jtag.sv \
     ../../../../../../riscv-dbg/src/dmi_jtag_tap.sv \
     ../../../../../../riscv-dbg/debug_rom/debug_rom.sv \
     ../../../../../../common_cells/src/cdc_2phase.sv \
     ../../../../../../common_cells/src/deprecated/fifo_v2.sv \
     ../../../../../../common_cells/src/fifo_v3.sv \
     ../../../../../pulpino/rtl/components/cluster_clock_inverter.sv \
     ../../../../../pulpino/rtl/components/pulp_clock_mux2.sv}

#elaborate_design -golden -root dm_jtag
elaborate_design -golden -root dm_top


read_design \
    -enumconstraint -define SYNTHESIS  -merge bbox -revised -lastmod -noelab \
    -systemverilog \
    {../../../../../riscv-dbg/src/dm_pkg.sv \
     ../../../../../riscv-dbg/src/dm_csrs.sv \
     ../../../../../riscv-dbg/src/dm_mem.sv \
     ../../../../../riscv-dbg/src/dm_sba.sv \
     ../../../../../riscv-dbg/src/dm_top.sv \
     ../../../../../riscv-dbg/src/dmi_cdc.sv \
     ../../../../../riscv-dbg/src/dmi_jtag.sv \
     ../../../../../riscv-dbg/src/dmi_jtag_tap.sv \
     ../../../../../riscv-dbg/debug_rom/debug_rom.sv \
     ../../../../../common_cells/src/cdc_2phase.sv \
     ../../../../../common_cells/src/deprecated/fifo_v2.sv \
     ../../../../../common_cells/src/fifo_v3.sv \
     ../../../../../pulpino/rtl/components/cluster_clock_inverter.sv \
     ../../../../../pulpino/rtl/components/pulp_clock_mux2.sv}

#elaborate_design -revised -root dm_jtag
elaborate_design -revised -root dm_top


report_design_data
report_black_box

#set_flatten_model -seq_constant
#set_flatten_model -seq_constant_x_to 0
#set_flatten_model -nodff_to_dlat_zero
#set_flatten_model -nodff_to_dlat_feedback
#set_flatten_model -hier_seq_merge
#
#set_flatten_model -balanced_modeling

set_system_mode lec

add_compared_points -all

compare

exit
