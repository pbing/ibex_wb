# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Generate a baremetal application

PROGRAM ?= fib
PROGRAM_CFLAGS = -Wall -g -Os
#PROGRAM_CFLAGS = -Wall -g -O0
ARCH = rv32imc_zicsr
#ARCH = rv32im_zicsr # to disable compressed instructions
SRCS = $(PROGRAM).c

CC = riscv64-unknown-elf-gcc

OBJCOPY ?= $(subst gcc,objcopy,$(wordlist 1,1,$(CC)))
OBJDUMP ?= $(subst gcc,objdump,$(wordlist 1,1,$(CC)))

LINKER_SCRIPT ?= link.ld
CRT ?= crt0.S
CFLAGS ?= -march=$(ARCH) -mabi=ilp32 -static -mcmodel=medany \
	-fvisibility=hidden -nostdlib -nostartfiles $(PROGRAM_CFLAGS)

OBJS := ${SRCS:.c=.o} ${CRT:.S=.o}
DEPS = $(OBJS:%.o=%.d)

OUTFILES = $(PROGRAM).elf $(PROGRAM).vmem $(PROGRAM).bin $(PROGRAM).dis

HEX2VMEM = ../../../../../scripts/hex2vmem.pl

all: $(OUTFILES)

$(PROGRAM).elf: $(OBJS) $(LINKER_SCRIPT)
	$(CC) $(CFLAGS) -T $(LINKER_SCRIPT) $(OBJS) -o $@ $(LIBS)

%.dis: %.elf
	$(OBJDUMP) -SD $^ > $@

# Note: this target requires the srecord package to be installed.
# XXX: This could be replaced by objcopy once
# https://sourceware.org/bugzilla/show_bug.cgi?id=19921
# is widely available.
# XXX: Currently the start address 0x00000000 is hardcoded. It could/should be
# read from the elf file, but is lost in the bin file.
# Switching to objcopy will resolve that as well.
# %.vmem: %.bin
# 	srec_cat $^ -binary -offset 0x0000 -byte-swap 4 -o $@ -vmem
%.vmem: %.hex
	$(HEX2VMEM) $< > $@

%.hex: %.elf
	$(OBJCOPY) -O verilog --interleave-width=4 --interleave=4 --byte=0 $< $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.o: %.c
	$(CC) $(CFLAGS) -MMD -c $(INCS) -o $@ $<

%.o: %.S
	$(CC) $(CFLAGS) -MMD -c $(INCS) -o $@ $<

clean:
	$(RM) -f *.o *.d *.hex

distclean: clean
	$(RM) -f $(OUTFILES)
