verilator --lint-only \
          --top-module ibex_soc \
          -Wno-REDEFMACRO \
          -F ../sim/verilator.f
