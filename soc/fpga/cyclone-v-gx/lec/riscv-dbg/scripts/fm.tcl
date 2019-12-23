#set_mismatch_message_filter -warn -signal FMR_ELAB-034
#set_mismatch_message_filter -warn -signal FMR_ELAB-147
lappend hdlin_warn_on_mismatch_message FMR_ELAB-147
lappend hdlin_warn_on_mismatch_message FMR_ELAB-034

read_sverilog -container r -libname WORK -12 \
{ \
  /home/CC/bbeuster/Projects/github.com/pbing/riscv-dbg/src/dm_pkg.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/riscv-dbg/src/dm_csrs.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/riscv-dbg/src/dm_mem.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/riscv-dbg/src/dm_sba.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/riscv-dbg/src/dm_top.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/riscv-dbg/src/dmi_cdc.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/riscv-dbg/src/dmi_jtag_tap.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/riscv-dbg/src/dmi_jtag.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/riscv-dbg/debug_rom/debug_rom.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/common_cells/src/deprecated/fifo_v2.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/common_cells/src/fifo_v3.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/common_cells/src/cdc_2phase.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/pulpino/rtl/components/cluster_clock_inverter.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/pulpino/rtl/components/pulp_clock_mux2.sv \
}

#set_top r:/WORK/dmi_jtag
set_top r:/WORK/dm_top




read_sverilog -container i -libname WORK -12 \
{ \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/riscv-dbg/src/dm_pkg.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/riscv-dbg/src/dm_csrs.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/riscv-dbg/src/dm_mem.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/riscv-dbg/src/dm_sba.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/riscv-dbg/src/dm_top.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/riscv-dbg/src/dmi_cdc.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/riscv-dbg/src/dmi_jtag_tap.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/riscv-dbg/src/dmi_jtag.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/riscv-dbg/debug_rom/debug_rom.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/common_cells/src/deprecated/fifo_v2.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/common_cells/src/fifo_v3.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/common_cells/src/cdc_2phase.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/pulpino/rtl/components/cluster_clock_inverter.sv \
  /home/CC/bbeuster/Projects/github.com/pbing/ibex_wb/pulpino/rtl/components/pulp_clock_mux2.sv \
}

#set_top i:/WORK/dmi_jtag ;# passed
set_top i:/WORK/dm_top


match

verify

exit
