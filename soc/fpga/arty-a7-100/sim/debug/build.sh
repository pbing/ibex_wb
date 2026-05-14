verilator --cc \
          -CFLAGS -std=c++20 \
          -CFLAGS -g \
          --build --exe -o sim_main \
          --trace-fst --trace-structs \
          --top-module ibex_soc \
          -Wno-fatal -Wno-lint \
          -Wno-REDEFMACRO -Wno-UNOPTFLAT -Wno-WIDTHEXPAND -Wno-WIDTHCONCAT -Wno-MULTIDRIVEN \
          -F ../verilator.f \
          +define+USE_TRACER +define+RVFI \
          src/driver.cpp \
          src/transaction.cpp \
          src/sim_main.cpp
