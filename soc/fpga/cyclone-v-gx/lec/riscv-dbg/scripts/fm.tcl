#set_mismatch_message_filter -warn -signal FMR_ELAB-034
#set_mismatch_message_filter -warn -signal FMR_ELAB-147
lappend hdlin_warn_on_mismatch_message FMR_ELAB-147
lappend hdlin_warn_on_mismatch_message FMR_ELAB-034

read_sverilog -container r -libname WORK -12 \
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

#set_top r:/WORK/dmi_jtag
set_top r:/WORK/dm_top



read_sverilog -container i -libname WORK -12 \
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

#set_top i:/WORK/dmi_jtag
set_top i:/WORK/dm_top


match

verify

exit
