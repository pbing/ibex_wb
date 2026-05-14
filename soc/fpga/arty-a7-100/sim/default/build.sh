verilator --cc \
          -CFLAGS -std=c++20 \
          --build --exe -o sim_main \
          --trace-fst --trace-structs \
          --top-module ibex_soc \
          -Wno-fatal -Wno-lint \
          -Wno-REDEFMACRO -Wno-UNOPTFLAT -Wno-WIDTHEXPAND -Wno-WIDTHCONCAT -Wno-MULTIDRIVEN \
          -F ../verilator.f \
          +define+USE_TRACER +define+RVFI \
          src/sim_main.cpp
