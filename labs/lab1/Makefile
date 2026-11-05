# Simulation for CEG3155 Lab 1, using nvc on macOS.
# Synthesis, pin assignment and programming the board happen in Vivado.
#
#   make TB=dff_tb sim          compile everything, run that testbench
#   make TB=dff_tb wave         the same, then open the waveform in surfer
#   make TB=dff_tb STOP=2us sim run for longer than the default
#   make clean                  remove the build directory and the waveforms

NVC  := nvc
STD  := --std=2008
TB   ?= dff_tb
STOP ?= 300ns

# find, rather than wildcard, so files in src/atoms, src/blocks and
# src/datapath-blocks are all picked up. Paths must not contain spaces.
SRC := $(shell find src tb -name '*.vhd' | sort)

.PHONY: sim wave clean list
sim:
	$(NVC) $(STD) -a $(SRC)
	$(NVC) $(STD) -e $(TB)
	$(NVC) $(STD) -r $(TB) --wave=$(TB).fst --stop-time=$(STOP)

wave: sim
	surfer $(TB).fst &

list:
	@echo $(SRC) | tr ' ' '\n'

clean:
	rm -rf work *.fst
