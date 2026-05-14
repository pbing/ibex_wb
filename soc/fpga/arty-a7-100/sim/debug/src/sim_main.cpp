#include <verilated.h>
#include <verilated_fst_c.h>

#include "Vibex_soc.h"
#include "debug_defs.hpp"
#include "driver.hpp"
#include "transaction.hpp"

// helper macros
#define SEQINSTR(seq, instr)                                                   \
  seq.push(std::shared_ptr<transaction>{new instr_transaction{instr}})

#define SEQIDCODE(seq, dat)                                                    \
  seq.push(std::shared_ptr<transaction>{new idcode_transaction{dat}})

#define SEQDTMCS(seq, dat)                                                     \
  seq.push(std::shared_ptr<transaction>{new dtmcs_transaction{dat}})

#define SEQDMI(seq, dat)                                                       \
  seq.push(std::shared_ptr<transaction>{new dmi_transaction{dat}})

int main(int argc, char **argv) {
  const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
  contextp->traceEverOn(true);
  contextp->commandArgs(argc, argv);

  const std::shared_ptr<Vibex_soc> top{new Vibex_soc{contextp.get(), "TOP"}};
  const std::unique_ptr<driver> drv{new driver{top}};

  std::queue<std::shared_ptr<transaction>> seq;
  dmi_t dmi {0};
  dmcontrol_t dmcontrol {0};
  command_t command;

  //--------------------------------------------------------------------------------
  SEQINSTR(seq, IDCODE);
  SEQIDCODE(seq, 0);

  SEQINSTR(seq, DMI);
  dmi.bits.address = DMSTATUS;
  dmi.bits.op = DTM_READ;
  SEQDMI(seq, dmi.reg);
  SEQDMI(seq, 0);

  dmcontrol.bits.dmactive = 1;
  dmi.bits.address = DMCONTROL;
  dmi.bits.data = dmcontrol.reg;
  dmi.bits.op = DTM_WRITE;
  SEQDMI(seq, dmi.reg);
  dmcontrol.bits.haltreq = 1;
  dmi.bits.data = dmcontrol.reg;
  SEQDMI(seq, dmi.reg);

  command.bits.cmdtype = 0; // access register command
  command.bits.control = (1<<17) | DCSR; 
  dmi.bits.address = COMMAND;
  dmi.bits.data = command.reg;
  dmi.bits.op = DTM_WRITE;
  SEQDMI(seq, dmi.reg);
  
  dmi.bits.address = DATA0;
  dmi.bits.op = DTM_READ;
  SEQDMI(seq, dmi.reg);
  SEQDMI(seq, 0);
  //--------------------------------------------------------------------------------

  const std::unique_ptr<VerilatedFstC> tfp{new VerilatedFstC};
  top->trace(tfp.get(), 99);
  tfp->open("dump.fst");

  top->clk100mhz = 0;
  top->ck_rst_n = 1;
  top->tck = 0;
  top->trst_n = 1;
  top->tms = 0;
  top->tdi = 0;
  top->eval();

  while (contextp->time() < 10000) {
    contextp->timeInc(1);

    top->clk100mhz = ~top->clk100mhz;
    if (contextp->time() % 10 == 0)
      top->tck = ~top->tck; // tck=10 MHz, must be slower than clk100mhz

    if (!top->clk100mhz) {
      if (contextp->time() > 10 && contextp->time() < 43) {
        top->ck_rst_n = 0; // assert reset
        top->trst_n = 0;
      } else {
        top->ck_rst_n = 1; // deassert reset
        top->trst_n = 1;
      }
    }

    if (contextp->time() > 100) {
      auto txn = seq.front();
      if (!seq.empty()) {
        if (drv->ready()) {
          seq.pop();
        }
        drv->drive(txn);
      }
    }

    top->eval();
    tfp->dump(contextp->time());
  }

  top->final();
  tfp->close();
  contextp->statsPrintSummary();

  return 0;
}
