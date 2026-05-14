#include "monitor.hpp"

void monitor::sample() {

  // strobe TDO at rising TCK edge
  if (!past_tck && top->tck) {
    tdo_i = top->tdo;
  }

  past_tck = top->tck;
}
