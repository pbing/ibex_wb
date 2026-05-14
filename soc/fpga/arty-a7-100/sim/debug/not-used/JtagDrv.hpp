#pragma once

#include "Vibex_soc.h"

class JtagDrv {
private:
  std::shared_ptr<Vibex_soc> top;
  uint8_t past_tck;

public:
  enum {
    TEST_LOGIC_RESET,
    RUN_TEST_IDLE,
    SELECT_IR_SCAN,
    CAPTURE_IR,
    SHIFT_IR,
    EXIT1_IR,
    PAUSE_IR,
    EXIT2_IR,
    UPDATE_IR,
    SELECT_DR_SCAN,
    CAPTURE_DR,
    SHIFT_DR,
    EXIT1_DR,
    PAUSE_DR,
    EXIT2_DR,
    UPDATE_DR
  } state;

  typedef enum {
    BYPASS0 = 0x00,
    IDCODE = 0x01,
    DTMCSR = 0x10,
    DMIACCESS = 0x11,
    BYPASS1 = 0x1f
  } IR_t;

  const uint32_t DM_BASE_ADDR = 0x1A110000;

  JtagDrv(std::shared_ptr<Vibex_soc> top) : top{top}, state(TEST_LOGIC_RESET) {}

  void writeIR(IR_t ir);
};
