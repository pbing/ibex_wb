#include "driver.hpp"

void driver::drive(std::shared_ptr<transaction> xaction) {
  const int num_idle = 8; // avoid DTM_BUSY
  rdy = false;
  // assign all signals at falling TCK edge
  if (past_tck && !top->tck) {
    switch (state) {
    case TEST_LOGIC_RESET:
      idle = 0;
      top->tms = 0;
      state = RUN_TEST_IDLE;
      break;
    case RUN_TEST_IDLE:
      bits = 0;
      if (++idle < num_idle) {
        top->tms = 0;
        state = RUN_TEST_IDLE;
      } else {
        top->tms = 1;
        state = SELECT_DR_SCAN;
      }
      break;
    case SELECT_DR_SCAN:
      if (xaction->mode == JTAG_IR) {
        top->tms = 1;
        state = SELECT_IR_SCAN;
      } else {
        top->tms = 0;
        state = CAPTURE_DR;
      }
      break;
    case CAPTURE_DR:
      top->tms = 0;
      state = SHIFT_DR;
      break;
    case SHIFT_DR:
      top->tdi = xaction->req & 1;
      xaction->req >>= 1;
      if (bits++ < xaction->len - 1) {
        top->tms = 0;
        state = SHIFT_DR;
      } else {
        top->tms = 1;
        state = EXIT1_DR;
      }
      break;
    case EXIT1_DR:
      top->tms = 0;
      top->tdi = xaction->req & 1;
      state = PAUSE_DR;
      break;
    case PAUSE_DR:
      top->tms = 1;
      state = EXIT2_DR;
      break;
    case EXIT2_DR:
      top->tms = 1;
      state = UPDATE_DR;
      break;
    case UPDATE_DR:
      top->tms = 0;
      idle = 0;
      state = RUN_TEST_IDLE;
      rdy = true;
      break;
    case SELECT_IR_SCAN:
      top->tms = 0;
      state = CAPTURE_IR;
      break;
    case CAPTURE_IR:
      top->tms = 0;
      state = SHIFT_IR;
      break;
    case SHIFT_IR:
      top->tdi = xaction->req & 1;
      xaction->req >>= 1;
      if (bits++ < xaction->len - 1) {
        top->tms = 0;
        state = SHIFT_IR;
      } else {
        top->tms = 1;
        state = EXIT1_IR;
      }
      break;
    case EXIT1_IR:
      top->tms = 0;
      top->tdi = xaction->req & 1;
      state = PAUSE_IR;
      break;
    case PAUSE_IR:
      top->tms = 1;
      state = EXIT2_IR;
      break;
    case EXIT2_IR:
      top->tms = 1;
      state = UPDATE_IR;
      break;
    case UPDATE_IR:
      top->tms = 0;
      idle = 0;
      state = RUN_TEST_IDLE;
      rdy = true;
      break;
    default:
      top->tms = 1;
      state = TEST_LOGIC_RESET;
      break;
    }
  }
  past_tck = top->tck;
}
