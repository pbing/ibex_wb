#include <verilated.h>
#include <verilated_fst_c.h>
#include "Vibex_soc.h"

int main(int argc, char **argv) {
  const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
  contextp->traceEverOn(true);
  contextp->commandArgs(argc, argv);

  const std::unique_ptr<Vibex_soc> top{new Vibex_soc{contextp.get(), "TOP"}};
  top->ck_rst_n = 1;
  top->clk100mhz = 0;
  top->eval();

  const std::unique_ptr<VerilatedFstC> tfp{new VerilatedFstC};
  top->trace(tfp.get(), 99);
  tfp->open("dump.fst");

  while (contextp->time() < 600000) {
    contextp->timeInc(1);

    top->clk100mhz = ~top->clk100mhz;

    if (!top->clk100mhz) {
      if (contextp->time() > 15 && contextp->time() < 30) {
        top->ck_rst_n = 0; // Assert reset
      } else {
        top->ck_rst_n = 1; // Deassert reset
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
