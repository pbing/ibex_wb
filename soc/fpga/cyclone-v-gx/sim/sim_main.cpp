#include <verilated.h>
#include <verilated_fst_c.h>
#include "Vibex_soc.h"

int main(int argc, char **argv) {
  const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
  contextp->traceEverOn(true);
  contextp->commandArgs(argc, argv);

  const std::unique_ptr<Vibex_soc> top{new Vibex_soc{contextp.get(), "TOP"}};
  top->CPU_RESET_n = 1;
  top->CLOCK_50_B5B = 0;

  const std::unique_ptr<VerilatedFstC> tfp{new VerilatedFstC};
  top->trace(tfp.get(), 99);
  tfp->open("dump.fst");

  while (contextp->time() < 2 * 1000000) {
    contextp->timeInc(1);

    top->CLOCK_50_B5B = ~top->CLOCK_50_B5B;

    if (!top->CLOCK_50_B5B) {
      if (contextp->time() > 1 && contextp->time() < 10) {
        top->CPU_RESET_n = 0; // Assert reset
      } else {
        top->CPU_RESET_n = 1; // Deassert reset
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
