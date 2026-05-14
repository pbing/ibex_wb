#include "JtagDrv.hpp"

void JtagDrv::writeIR(IR_t ir) {
  if (!past_tck && top->tck) {
    switch (state) {
    case TEST_LOGIC_RESET:
      top->tms =  0;
      state = RUN_TEST_IDLE;
      break;
    case RUN_TEST_IDLE:
      top->tms =  1;
      state = SELECT_DR_SCAN;
      break;
    case SELECT_DR_SCAN:
      top->tms =  1;
      state = SELECT_IR_SCAN;
      break;
    case SELECT_IR_SCAN:
      top->tms =  0;
      state = CAPTURE_IR;
      break;
    case CAPTURE_IR:
      top->tms =  0;
      state = SHIFT_IR;
      break;
    case SHIFT_IR:
      top->tms =  1;
      state = EXIT1_IR;
      break;
    case EXIT1_IR:
      top->tms =  0;
      state = PAUSE_IR;
      break;
    case PAUSE_IR:
      top->tms =  1;
      state = EXIT2_IR;
      break;
    case EXIT2_IR:
      top->tms =  1;
      state = UPDATE_IR;
      break;
    case UPDATE_IR:
      top->tms =  0;
      state = RUN_TEST_IDLE;
      break;
    default:
      top->tms =  1;
      state = TEST_LOGIC_RESET;
      break;
    }
  }
  past_tck = top->tck;
}
