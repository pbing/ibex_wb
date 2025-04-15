verilator --cc \
          -CFLAGS -std=c++20 \
          --build --exe -o sim_main \
          --trace-fst --trace-structs \
          --top-module ibex_soc \
          -Wno-fatal -Wno-lint \
          -Wno-REDEFMACRO -Wno-UNOPTFLAT -Wno-WIDTHEXPAND -Wno-WIDTHCONCAT -Wno-MULTIDRIVEN \
          -f verilator.f \
          +define+USE_TRACER +define+RVFI \
          sim_main.cpp
