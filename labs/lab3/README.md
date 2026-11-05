# Laboratory 3, traffic light controller

A main street and a side street meet. The main street holds the green until the
count finishes and a car is waiting on the side street, then the lights cycle
through yellow and red, the side street takes its turn, and the main street
comes back.

Four states, two inputs. `SSCS` from the debounced car sensor and `EXP` from the
counting block go in. `MSTL`, `SSTL` and `Select` come out.

## The state assignment

`y2` means the side street phase and `y1` means a yellow phase.

| `y2 y1` | state | `Select` names |
|---|---|---|
| `00` | main green | `MSC` |
| `01` | main yellow | `YC` |
| `10` | side green | `SSC` |
| `11` | side yellow | `YC` |

`Select` is the two state bits unchanged, so there are no gates between the flip
flops and the multiplexer.

## The design equations

```
Y2 = y2.y1' + EXP'.y2 + EXP.y2'.y1
Y1 = EXP'.y1 + EXP.y2.y1' + SSCS.EXP.y2'.y1'

MSTL(2) = y2        MSTL(1) = y2'.y1    MSTL(0) = y2'.y1'
SSTL(2) = y2'       SSTL(1) = y2.y1     SSTL(0) = y2.y1'

Select(1) = y2      Select(0) = y1
```

One hot on the lights, bit 2 red, bit 1 yellow, bit 0 green, which is the order
the pin table in section 5.4 fixes.

## The blocks

### `fsm/dff.vhd`

One bit register, asynchronous active low reset, synchronous enable.

### `fsm/fsmControl.vhd`

Two `dff` instances for `y2` and `y1`, the next state gates in front of them and
the output gates behind them.

### `blocks/counting/downCounter4.vhd`

Four `dff` instances and the gates in front. Load takes `i_value` on the next
edge, enable subtracts one, neither holds. Counting down, a bit flips when every
bit below it is already zero, so bit 0 flips on every count, bit 1 flips when
bit 0 is zero, bit 2 when bits 1 and 0 are both zero, bit 3 when all three below
it are zero.

### `blocks/counting/periodMux.vhd`

Four to one on four bit buses, one concurrent conditional assignment, no
storage.

| `i_select` | passes |
|---|---|
| `00` | `i_mscMax`, the main green from SW1 to SW4 |
| `01` | `i_yc`, the fixed yellow |
| `10` | `i_sscMax`, the side green from SW5 to SW8 |
| `11` | `i_yc` again |

Yellow appears twice because both yellow states ask for the same length. The
assignment ends with a bare `else` so no input combination is left undriven.

### `blocks/counting/countingBlock.vhd`

One block serves all three periods. `periodMux` picks the period and
`downCounter4` counts it down. `o_exp` is a NOR of the four count bits, so it is
high at zero, and the counter's enable is `o_exp'`, which holds it at zero once
it gets there. Holding is what lets the main green state sit at expired while it
waits for a car, so a car arriving late changes the light with no further wait.

`i_reload` drives the load, and `o_count` goes out to the BCD decoder.

### `blocks/change-detect/changeDetect.vhd`

The counter reloads on every state change, and `Select` changes on every
transition and on none of the self loops, so it stands in for a change of state.
Two `dff` instances hold what `Select` was one clock ago, then

```
o_changed = (prev(1) xor i_select(1)) or (prev(0) xor i_select(0))
```

`o_changed` is high for one cycle, because the register catches up on the next
edge.

### `blocks/display/bcdDecoder.vhd`

The bonus. The count is four bits, so 0 to 15, and the display needs two decimal
digits. Below ten the tens digit is 0 and the units digit is the count. At ten
and above the tens digit is 1 and the units digit is the count minus ten. A
comparison against ten and a subtract, both combinational.

### `top-entity.vhd`

Instantiates everything and wires it to the pins in Table 10.

## Provided cores

The debouncer and the clock divider come from the course material, and the
display controller is Appendix F. Section 6 allows them and requires that they
be referenced in the report. The display controller only matters for the bonus,
since nothing else in the design writes to the seven segment display.

## Two things the handout buries

**The divided clock is an enable.** Section 5.5 says every flip flop runs on the
100 MHz `CLOCK` qualified by a clock enable, so the divider produces a one cycle
tick and that tick goes to `i_enable`. A register clocked by the divider output
fails timing, and the handout lists that as one of the usual causes.

**`LOAD_FSM` has to reach the state flip flops.** SW0 enables the machine, so the
two state flip flops take `tick and LOAD_FSM` on their enable.

## Constraints

`SSC_MAX(3)` is on SW8 at pin T8, which sits on a 1.8 V bank while everything
else is LVCMOS33. It either moves to a switch on a 3.3 V bank or takes LVCMOS18
on its own.
