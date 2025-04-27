clear -all

# read design
analyze -sv ../../rtl/wb_pkg.sv
analyze -sv ../../rtl/wb_if.sv
analyze -sv ../../rtl/core_if.sv
analyze -sv ../../rtl/wb2core.sv +define+FORMAL +define+NO_MODPORT_EXPRESSIONS

# read constraints
analyze -sv12 fv_wb2core.sv

elaborate -top wb2core

clock wb.clk
#reset -expression wb.rst
reset -none

check_assumptions
prove -all
