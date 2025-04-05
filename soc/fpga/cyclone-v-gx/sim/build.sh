verilator --cc \
          -CFLAGS -std=c++20 \
          --build --exe -o sim_main \
          --trace-fst --trace-structs \
          --top-module ibex_soc \
          -Wno-fatal -Wno-lint -Wno-REDEFMACRO -Wno-UNOPTFLAT \
          -f verilator.f \
          +define+USE_TRACER +define+RVFI \
          ibex_soc.sv \
          sim_main.cpp
