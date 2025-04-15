verilator --lint-only \
          --top-module ibex_soc \
          -Wno-REDEFMACRO \
          -f ../sim/verilator.f
