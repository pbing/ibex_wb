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

### Interconnect with Shared Bus
The shared bus interconnect has the lowest latency but long combinational paths.
This can lead to a decrease of the maximum clock frequency.

An instruction cache does not improve the performance by a large amount.

#### Timing without ICACHE
| Program    | Cycles | Instructions   | CPI  |
|------------|--------|----------------|------|
| crc_32     | 35032  | 23689          | 1.48 |
| nettle-aes | 91710  | 64380          | 1.42 |
| geom. mean |        |                | 1.45 |

#### Timing with ICACHE
| Program    | Cycles | Instructions   | CPI  |
|------------|--------|----------------|------|
| crc_32     | 35044  | 23689          | 1.48 |
| nettle-aes | 87829  | 64380          | 1.36 |
| geom. mean |        |                | 1.42 |

### Interconnect with Crossbar
The crossbar interconnect uses skid buffers. Therefor the latency has been increased.

The optional instruction cache is designed to improve CPU performance in systems
with high instruction memory latency. The instruction cache integrates into the
CPU by replacing the prefetch buffer, interfacing directly between the bus and IF stage.

#### Timing without ICACHE
| Program    | Cycles | Instructions   | CPI  |
|------------|--------|----------------|------|
| crc_32     | 66997  | 23689          | 2.83 |
| nettle-aes | 186998 | 64380          | 2.90 |
| geom. mean |        |                | 2.87 |

#### Timing with ICACHE
| Program    | Cycles | Instructions   | CPI  |
|------------|--------|----------------|------|
| crc_32     | 44478  | 23689          | 1.88 |
| nettle-aes | 134913 | 64380          | 2.10 |
| geom. mean |        |                | 1.98 |

## FPGA Implementation
[Arty A7-100T](https://www.xilinx.com/products/boards-and-kits/1-w51quh.html)

## Recources
- [Wishbone at opencores.org](https://opencores.org/howto/wishbone)
- [ZipCPU](http://zipcpu.com/zipcpu/2017/11/07/wb-formal.html) for a deeper understanding of the pipelined mode.
- [WB2AXIP: Bus interconnects, bridges, and other components](https://github.com/ZipCPU/wb2axip/)
