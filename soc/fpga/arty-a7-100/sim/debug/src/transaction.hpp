#pragma once

#include <cstddef>
#include <cstdint>

enum : bool { JTAG_IR, JTAG_DR };

class transaction {
public:
  bool mode;
  uint64_t req;
  size_t len;

  transaction(bool mode, uint64_t req, size_t len)
      : mode(mode), req(req), len(len) {}

public:
  void print();
};

class instr_transaction : public transaction {
public:
  instr_transaction(uint8_t instr) : transaction(JTAG_IR, instr, 5) {}
};

class idcode_transaction : public transaction {
public:
  idcode_transaction(uint32_t data) : transaction(JTAG_DR, data, 32) {}
};

class dtmcs_transaction : public transaction {
public:
  dtmcs_transaction(uint32_t data) : transaction(JTAG_DR, data, 32) {}
};

class dmi_transaction : public transaction {
public:
  dmi_transaction(uint64_t data) : transaction(JTAG_DR, data, 41) {}
};
