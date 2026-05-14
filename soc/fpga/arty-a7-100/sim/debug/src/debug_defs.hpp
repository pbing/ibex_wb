#pragma once

#include <cstdint>

// Instruction register
enum : uint8_t {
  BYPASS0 = 0x00,
  IDCODE = 0x01,
  DTMCS = 0x10,
  DMI = 0x11,
  BYPASS = 0x1f
};

// Data register: IDCODE
typedef union {
  uint32_t reg;
  struct {
    uint32_t one : 1;
    uint32_t manufld : 11;
    uint32_t partnum : 16;
    uint32_t version : 4;
  } bits;
} idcode_t;

// Data register DTMCS
typedef union {
  uint32_t reg;
  struct {
    uint32_t version : 4;
    uint32_t abits : 6;
    uint32_t dmistat : 2;
    uint32_t idle : 3;
    uint32_t : 1;
    uint32_t dmireset : 1;
    uint32_t dmihardreset : 1;
    uint32_t : 14;
  } bits;
} dtmcs_t;

// Data register DMI
typedef union {
  uint64_t reg;
  struct {
    uint64_t op : 2;
    uint64_t data : 32;
    uint64_t address : 7; // riscv-dbg/src/dmi_jtag.sv
  } bits;
} dmi_t;

enum { DTM_NOP = 0, DTM_READ = 1, DTM_WRITE = 2 };
enum { DTM_SUCCESS = 0, DTM_ERR = 2, DTM_BUSY = 3 };

// Addresses of debug registers
// https://github.com/pulp-platform/riscv-dbg/blob/master/doc/debug-system.md
enum {
  DATA0 = 0x04,
  DATA1 = 0x05,
  DATA2 = 0x06,
  DATA3 = 0x07,
  DATA4 = 0x08,
  DATA5 = 0x09,
  DATA6 = 0x0a,
  DATA7 = 0x0b,
  DATA8 = 0x0c,
  DATA9 = 0x0d,
  DATA10 = 0x0e,
  DATA11 = 0x0f,
  DMCONTROL = 0x10,
  DMSTATUS = 0x11,
  HARTINFO = 0x12,
  HALTSUM1 = 0x13,
  HAWINDOWSEL = 0x14, // not implemented
  HAWINDOW = 0x15,    // not implemented
  ABSTRACTS = 0x16,
  COMMAND = 0x17,
  ABSTRACTAUTO = 0x18,
  CONFSTRPTR0 = 0x19, // not implemented
  CONFSTRPTR1 = 0x1a, // not implemented
  CONFSTRPTR2 = 0x1b, // not implemented
  CONFSTRPTR3 = 0x1c, // not implemented
  NEXTDM = 0x1d,      // not implemented
  CUSTOM = 0x1f,      // not implemented
  PROGBUF0 = 0x20,
  PROGBUF1 = 0x21,
  PROGBUF2 = 0x22,
  PROGBUF3 = 0x23,
  PROGBUF4 = 0x24,
  PROGBUF5 = 0x25,
  PROGBUF6 = 0x26,
  PROGBUF7 = 0x27,
  PROGBUF8 = 0x28,
  PROGBUF9 = 0x29,
  PROGBUF10 = 0x2a,
  PROGBUF11 = 0x2b,
  PROGBUF12 = 0x2c,
  PROGBUF13 = 0x2d,
  PROGBUF14 = 0x2e,
  PROGBUF15 = 0x2f,
  AUTHDATA = 0x30, // not implemented
  DMCS2 = 0x32,    // not implemented
  HALTSUM2 = 0x34,
  HALTSUM3 = 0x35,
  SBADDRESS3 = 0x37, // not implemented
  SBCS = 0x38,
  SBADDRESS0 = 0x39,
  SBADDRESS1 = 0x3a,
  SBADDRESS2 = 0x3b,
  SBDATA0 = 0x3c,
  SBDATA1 = 0x3d,
  SBDATA2 = 0x3e,
  SBDATA3 = 0x3f, // not implemented
  HALTSUM0 = 0x40
};

enum {
  // Addresses of trigger module
  TSELECT = 0x7a0,
  TDATA1 = 0x7a1,
  TDATA2 = 0x7a2,
  TDATA3 = 0x7a3,
  // Addresses of core debug CSRs
  DCSR = 0x7b0,
  DPC = 0x7c1,
  DSCRATCH0 = 0x7b2,
  DSCRATCH1 = 0x7b3
};

typedef union {
  uint32_t reg;
  struct {
    uint32_t dmactive : 1;
    uint32_t ndmreset : 1;
    uint32_t clrresethaltreq : 1; // Writing this register is a no-op.
    uint32_t setresethaltreq : 1; // Writing this register is a no-op.
    uint32_t : 2;
    uint32_t hartselhi : 10;
    uint32_t hartsello : 10;
    uint32_t hasel : 1;           // Hart array masks are not supported
    uint32_t : 1;
    uint32_t ackhavereset : 1;
    uint32_t hartreset : 1;       // Not implemented, reads constant 0
    uint32_t resumereq : 1;
    uint32_t haltreq : 1;
  } bits;
} dmcontrol_t;

typedef union {
  uint32_t reg;
  struct {
    uint32_t version : 4;         // 2 : Specification version 0.13 
    uint32_t confstrptrvalid : 1; // 0 : Configuration strings are not supported.
    uint32_t hasresethaltreq : 1; // 0 : Halt-on-reset is not implemented, reads always 0.
    uint32_t authbusy : 1;        // 0 : Authentication is not implemented, reads always 0. 
    uint32_t authenticated : 1;   // 1 : Authentication is not implemented, reads always 1.
    uint32_t anyhalted : 1;       // Hart array masks are not supported; identical to allhalted.
    uint32_t allhalted : 1;       // Hart array masks are not supported; identical to anyhalted.
    uint32_t anyrunning : 1;      // Hart array masks are not supported; identical to allrunning.
    uint32_t allrunning : 1;      // Hart array masks are not supported; identical to anyrunning.
    uint32_t anyunavail : 1;      // Hart array masks are not supported; identical to allunavail.
    uint32_t allunavail : 1;      // Hart array masks are not supported; identical to anyunavail.
    uint32_t anynonexistent : 1;  // Hart array masks are not supported; identical to allnonexistent
    uint32_t allnonexistent : 1;  // Hart array masks are not supported; identical to anynonexistent
    uint32_t anyresumeack : 1;    // Hart array masks are not supported; identical to allresumeack.
    uint32_t allresumeack : 1;    // Hart array masks are not supported; identical to anyresumeack.
    uint32_t anyhavereset : 1;    // Hart array masks are not supported; identical to allhavereset.
    uint32_t allhavereset : 1;    // Hart array masks are not supported; identical to allhavereset.
    uint32_t : 2;
    uint32_t impebreak : 1;       // 0: No implicit ebreak is inserted after the Program Buffer.
    uint32_t : 9;
  } bits;
} dmstatus_t;

typedef union {
  uint32_t reg;
  struct {
    uint32_t control : 24;
    uint32_t cmdtype : 8;
  } bits;
} command_t;

