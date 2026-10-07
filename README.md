# CEG3155 laboratories

VHDL for the four laboratories of CEG3155, Digital Systems II, University of Ottawa,
Fall 2026. One folder per laboratory.

| | |
|---|---|
| `lab1/` | Light display controller. Two rotating mask registers, an output multiplexer, one flip flop per state control logic, and the clock divider supplied with the course. |
| `lab2/` | Fixed-point arithmetic. A four-bit signed adder and subtractor, with both a ripple carry and a carry lookahead adder behind the same ports. |

Simulated with [nvc](https://github.com/nickg/nvc) and read in
[Surfer](https://surfer-project.org), since Vivado does not run on Apple Silicon. Built for
the Digilent Nexys A7-100T.

```
nvc --std=2008 -a <sources> <testbench>
nvc --std=2008 -e <testbench>
nvc --std=2008 -r <testbench> --wave=<testbench>.fst
surfer <testbench>.fst
```

Everything here is written by the group. The one exception is `lab1/src/blocks/clk_div.vhd`,
which is supplied with the course and is kept unchanged beside the adapted copy.
