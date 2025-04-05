# ibex_wb
RISC-V Ibex core with Wishbone B4 interface.

## Design
The instruction and data memory interfaces are converted to Wishbone.

## Ibex memory control vs. Wishbone bus

### Basic Memory Transaction
<p align="center"><img src="doc/images/timing1.svg" width="650"></p>

### Back-to-back Memory Transaction
<p align="center"><img src="doc/images/timing2.svg" width="650"></p>

### Slow Response Memory Transaction
<p align="center"><img src="doc/images/timing3.svg" width="650"></p>


## Status
Simulated with Verilator

### Shared bus Wishbone interface

#### Timing with uncompressed instructions
| Program    | Cycles | Instructions | CPI  |
|------------|--------|--------------|------|
| crc_32     | 36073  | 24715        | 1.46 |
| fib        | 164    | 108          | 1.52 |
| led        | 999991 | 749959       | 1.33 |
| nettle-aes | 101476 | 63236        | 1.60 |
|            |        | geom. mean   | 1.48 |

#### Timing with compressed instructions
| Program    | Cycles | Instructions   | CPI  |
|------------|--------|----------------|------|
| crc_32     | 34008  | 23688          | 1.44 |
| fib        | 151    | 108            | 1.40 |
| led        | 999991 | 749995         | 1.33 |
| nettle-aes | 96053  | 63236          | 1.52 |
|            |        | geom. mean     | 1.42 |

### Crossbar Wishbone interface
The crossbar Wishbone interface uses skid buffers. Therefor the latency has been increased.

#### Timing with uncompressed instructions
| Program    | Cycles | Instructions   | CPI  |
|------------|--------|----------------|------|
| crc_32     | 84515  | 24715          | 3.42 |
| fib        | 370    | 108            | 3.43 |
| led        | 999990 | 375012         | 2.67 |
| nettle-aes | 236207 | 63236          | 3.74 |
|            |        | geom. mean     | 3.29 |

#### Timing with compressed instructions
| Program    | Cycles | Instructions   | CPI  |
|------------|--------|----------------|------|
| crc_32     | 67037  | 23688          | 2.83 |
| fib        | 275    | 108            | 2.55 |
| led        | 999992 | 500004         | 2.00 |
| nettle-aes | 220501 | 63236          | 3.54 |
|            |        | geom. mean     | 2.67 |

## FPGA Implementation

### Intel/Cyclone-V
[Cyclone V GX Starter Kit](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=167&No=830)

For Quartus 19.1 use branch `fpga_quartus` in submodules `common_cells`, `ibex` and`riscv-dbg`.

### Xilinx/Artix-7
[Arty A7-100T](https://www.xilinx.com/products/boards-and-kits/1-w51quh.html)

For Vivado 2019.2 use branch `master` in all submodules.

## Recources
- [Wishbone at opencores.org](https://opencores.org/howto/wishbone)
- [ZipCPU](http://zipcpu.com/zipcpu/2017/11/07/wb-formal.html) for a deeper understanding of the pipelined mode.
- [WB2AXIP: Bus interconnects, bridges, and other components](https://github.com/ZipCPU/wb2axip/)
