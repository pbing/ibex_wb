+define+ASSERTS_OFF
+define+NO_MODPORT_EXPRESSIONS

+incdir+../../../../common_cells/include
../../../../common_cells/src/cdc_2phase_clearable.sv
../../../../common_cells/src/cdc_4phase.sv
../../../../common_cells/src/cdc_reset_ctrlr_pkg.sv
../../../../common_cells/src/cdc_reset_ctrlr.sv
../../../../common_cells/src/deprecated/fifo_v2.sv
../../../../common_cells/src/fifo_v3.sv
../../../../common_cells/src/spill_register.sv
../../../../common_cells/src/spill_register_flushable.sv
../../../../common_cells/src/sync.sv

../../../../tech_cells_generic/src/rtl/tc_clk.sv

+incdir+../../../../ibex/vendor/lowrisc_ip/ip/prim/rtl
+incdir+../../../../ibex/vendor/lowrisc_ip/dv/sv/dv_utils
../../../../ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_pkg.sv
../../../../ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_pkg.sv
../../../../ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_cipher_pkg.sv
../../../../ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_count_pkg.sv
../../../../ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_util_pkg.sv
../../../../ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_mubi_pkg.sv
../../../../ibex/dv/uvm/core_ibex/common/prim/prim_pkg.sv
../../../../ibex/dv/uvm/core_ibex/common/prim/prim_clock_gating.sv
../../../../ibex/dv/uvm/core_ibex/common/prim/prim_buf.sv
../../../../ibex/dv/uvm/core_ibex/common/prim/prim_ram_1p.sv
../../../../ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_clock_gating.sv
../../../../ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_buf.sv
../../../../ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_ram_1p.sv
../../../../ibex/rtl/ibex_pkg.sv
../../../../ibex/rtl/ibex_alu.sv
../../../../ibex/rtl/ibex_branch_predict.sv
../../../../ibex/rtl/ibex_compressed_decoder.sv
../../../../ibex/rtl/ibex_controller.sv
../../../../ibex/rtl/ibex_core.sv
../../../../ibex/rtl/ibex_counter.sv
../../../../ibex/rtl/ibex_cs_registers.sv
../../../../ibex/rtl/ibex_csr.sv
../../../../ibex/rtl/ibex_decoder.sv
../../../../ibex/rtl/ibex_dummy_instr.sv
../../../../ibex/rtl/ibex_ex_block.sv
../../../../ibex/rtl/ibex_fetch_fifo.sv
../../../../ibex/rtl/ibex_icache.sv
../../../../ibex/rtl/ibex_id_stage.sv
../../../../ibex/rtl/ibex_if_stage.sv
../../../../ibex/rtl/ibex_load_store_unit.sv
../../../../ibex/rtl/ibex_lockstep.sv
../../../../ibex/rtl/ibex_multdiv_fast.sv
../../../../ibex/rtl/ibex_multdiv_slow.sv
../../../../ibex/rtl/ibex_pmp.sv
../../../../ibex/rtl/ibex_prefetch_buffer.sv
../../../../ibex/rtl/ibex_register_file_ff.sv
../../../../ibex/rtl/ibex_register_file_fpga.sv
../../../../ibex/rtl/ibex_register_file_latch.sv
../../../../ibex/rtl/ibex_tracer_pkg.sv
../../../../ibex/rtl/ibex_tracer.sv
../../../../ibex/rtl/ibex_wb_stage.sv
../../../../ibex/rtl/ibex_top.sv
../../../../ibex/rtl/ibex_top_tracing.sv

../../../../riscv-dbg/src/dm_pkg.sv
../../../../riscv-dbg/src/dm_csrs.sv
../../../../riscv-dbg/src/dm_mem.sv
../../../../riscv-dbg/src/dm_obi_top.sv
../../../../riscv-dbg/src/dm_sba.sv
../../../../riscv-dbg/src/dm_top.sv
../../../../riscv-dbg/src/dmi_cdc.sv
../../../../riscv-dbg/src/dmi_intf.sv
//../../../../riscv-dbg/src/dmi_bscane_tap.sv
../../../../riscv-dbg/src/dmi_jtag_tap.sv
../../../../riscv-dbg/src/dmi_jtag.sv
../../../../riscv-dbg/debug_rom/debug_rom_one_scratch.sv
../../../../riscv-dbg/debug_rom/debug_rom.sv

../../../../rtl/wb_pkg.sv
../../../../rtl/core_if.sv
../../../../rtl/core2wb.sv
../../../../rtl/slave2wb.sv
../../../../rtl/wb_dm_top.sv
../../../../rtl/wb_if.sv
../../../../rtl/wb_ibex_top.sv

../../../../wb2axip/rtl/addrdecode.v
../../../../wb2axip/rtl/skidbuffer.v
../../../../wb2axip/rtl/wbxbar.v

../../../../soc/common/rtl/wb_interconnect_sharedbus.sv
../../../../soc/common/rtl/wb_interconnect_xbar.sv
../../../../soc/fpga/arty-a7-100/lib/verilog/clkgen_50mhz.sv
../../../../soc/fpga/arty-a7-100/rtl/crg.sv
../../../../soc/fpga/arty-a7-100/rtl/spramx32.sv
../../../../soc/fpga/arty-a7-100/rtl/sync_reset.sv
../../../../soc/fpga/arty-a7-100/rtl/wb_led.sv
../../../../soc/fpga/arty-a7-100/rtl/wb_spramx32.sv
../../../../soc/fpga/arty-a7-100/rtl/ibex_soc.sv
