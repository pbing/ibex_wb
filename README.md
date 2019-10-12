# ibex_wb
RISC-V Ibex core with Wishbone B4 interface.

## Design
The instruction and data memory interfaces are converted to
Wishbone.
[These examples](https://github.com/pbing/ibex_wb/tree/master/sim) use shared bus
interconnection between masters (instruction bus, data bus) and slaves (e.g. memory, LED driver).
For better throughput or latency a crossbar interconnect can be considered.


## Ibex memory control vs. Wishbone bus

### Basic Memory Transaction
<p align="center"><img src="doc/images/timing1.svg" width="650"></p>

### Back-to-back Memory Transaction
<p align="center"><img src="doc/images/timing2.svg" width="650"></p>

### Slow Response Memory Transaction
<p align="center"><img src="doc/images/timing3.svg" width="650"></p>


## Status
Simulated with Synopsys VCS.

### Timing with uncompressed instructions
| Program  | Cycles | Instructions   | CPI  |
|----------|--------|----------------|------|
| crc_32   | 43277  | 24714          | 1.75 |
| fib      | 172    | 107            | 1.61 |
| led      | 509993 | 382481         | 1.33 |
|----------|--------|----------------|------|
|          |        | geometric mean | 1.55 |

### Timing with compressed instructions
| Program  | Cycles | Instructions   | CPI  |
|----------|--------|----------------|------|
| crc_32.c | 37105  | 23687          | 1.57 |
| fib.c    | 165    | 107            | 1.54 |
| led.c    | 509993 | 382492         | 1.33 |
|----------|--------|----------------|------|
|          |        | geometric mean | 1.48 |




## Recources
- [Wishbone at opencores.org](https://opencores.org/howto/wishbone)
- [ZipCPU](http://zipcpu.com/zipcpu/2017/11/07/wb-formal.html) for a deeper understanding of the pipelined mode.
