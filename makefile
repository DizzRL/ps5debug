#   Copyright (C) 2023 John Törnblom
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING. If not see
# <http://www.gnu.org/licenses/>.

ifndef PS5_PAYLOAD_SDK
    $(error PS5_PAYLOAD_SDK is undefined)
endif

PS5_HOST ?= PS5IP
PS5_PORT ?= EFLLDR_PORT

ELF := $(shell basename $(CURDIR)).elf

CC := $(PS5_PAYLOAD_SDK)/host/x86_64-ps5-payload-cc
LD := $(PS5_PAYLOAD_SDK)/host/x86_64-ps5-payload-ld

ODIR   := build
IDIRS   := -I. -Iinclude -IlibNidResolver/include
CFLAGS := $(IDIRS) -O2
LDADD  := -lSceLibcInternal -lkernel_sys -lSceNet
SDIR   := source
NIDDIR := libNidResolver/source
CFILES := $(wildcard $(SDIR)/*.c)
SFILES := $(wildcard $(SDIR)/*.s)
OBJS   := $(patsubst $(SDIR)/%.c, $(ODIR)/%.o, $(CFILES)) $(patsubst $(SDIR)/%.s, $(ODIR)/%.o, $(SFILES))

all: $(ELF)

$(ODIR)/%.o: $(SDIR)/%.c
	$(CC) -c $(CFLAGS) -o $@ $^

$(ELF): $(OBJS)
	$(LD) $^ $(LDADD) -o $(ELF)

$(ODIR):
	@mkdir $@

.PHONY: clean

clean:
	rm -f $(ELF) $(ODIR)/*.o

test: $(ELF)
	nc -q0 $(PS5_HOST) $(PS5_PORT) < $^
