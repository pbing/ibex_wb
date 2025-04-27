clear -all

# read design
analyze -sv ../../rtl/wb_pkg.sv
analyze -sv ../../rtl/wb_if.sv
analyze -sv ../../rtl/core_if.sv
analyze -sv ../../rtl/core2wb.sv +define+FORMAL +define+NO_MODPORT_EXPRESSIONS

# read constraints
analyze -sv12 fv_core2wb.sv

elaborate -top core2wb

clock core.clk
reset -expression !core.rst_n

check_assumptions
prove -all
