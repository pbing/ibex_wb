#pragma once

#include <memory>

#include "Vibex_soc.h"

class monitor {
private:
  std::shared_ptr<Vibex_soc> top;
  uint8_t past_tck;
  int bits;
  uint8_t tdo_i;

  enum {
    TEST_LOGIC_RESET,
    RUN_TEST_IDLE,
    SELECT_DR_SCAN,
    CAPTURE_DR,
    SHIFT_DR,
    EXIT1_DR,
    PAUSE_DR,
    EXIT2_DR,
    UPDATE_DR,
    SELECT_IR_SCAN,
    CAPTURE_IR,
    SHIFT_IR,
    EXIT1_IR,
    PAUSE_IR,
    EXIT2_IR,
    UPDATE_IR
  } state;

public:
  monitor(std::shared_ptr<Vibex_soc> top) : top(top) {}

  void sample();
};
