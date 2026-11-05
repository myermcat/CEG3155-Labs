# Laboratory 3, traffic light controller

Four states, two inputs. `SSCS` from the debounced car sensor and `EXP` from
the counting block go in; `MSTL`, `SSTL` and `Select` come out.

## Who writes what

| Mariia | Kevin | Provided |
|---|---|---|
| `fsm/fsmControl.vhd` | `blocks/counting/downCounter4.vhd` | `blocks/provided/display_controller.vhd` |
| `fsm/dff.vhd` | `blocks/counting/periodMux.vhd` | debouncer |
| `blocks/counting/countingBlock.vhd` | `blocks/change-detect/changeDetect.vhd` | clock divider |
| `top-entity.vhd` | `blocks/display/bcdDecoder.vhd`, the bonus | |
| `Nexys-A7-100T-Master.xdc` | | |

Each of us writes the testbenches for our own blocks. `dff` and `periodMux` get
none, since the teaching assistant said a component that simple does not need
one.

All three provided cores are referenced in the report, which section 6 requires.

The display controller is supplied in Appendix F and is only needed for the
bonus, since that is the only thing that puts anything on the seven segment
display. The bonus itself is the BCD decoder, which we build.

## Kevin's four blocks

### `downCounter4.vhd`

Four `dff` instances and the gates in front of them. Three behaviours:

- `i_load` high, take `i_value` on the next edge
- `i_load` low and `i_enable` high, subtract one
- both low, hold

Counting down, a bit flips when every bit below it is already zero, so
`b(0)` flips always, `b(1)` flips when `count(0)` is zero, and so on. The same
shape as `counter3bit.vhd` in Lab 2, one bit wider and without the fixed load
constant.

### `periodMux.vhd`

Four to one on four bit buses, one concurrent conditional assignment, no
storage.

| `i_select` | passes |
|---|---|
| `00` | `i_mscMax`, the main green from SW1 to SW4 |
| `01` | `i_yc`, the fixed yellow |
| `10` | `i_sscMax`, the side green from SW5 to SW8 |
| `11` | `i_yc` again |

Yellow appears twice because both yellow states ask for the same length. End
the assignment with a bare `else` so no input combination is left undriven.

### `changeDetect.vhd`

Two `dff` instances holding what `i_select` was one clock ago, then

```
o_changed = (prev(1) xor i_select(1)) or (prev(0) xor i_select(0))
```

`o_changed` is high for one cycle, because on the next edge the register
catches up with the live value. That single cycle is what reloads the counting
block.

### `bcdDecoder.vhd`

The bonus. The count is four bits, so 0 to 15, and the display needs two
decimal digits.

- below ten, the tens digit is 0 and the units digit is the count
- ten and above, the tens digit is 1 and the units digit is the count minus ten

A one bit comparison against ten and a subtract, both combinational.


## The interface, settled before either half is written

| signal | direction | width |
|---|---|---|
| `SSCS` | debouncer into the fsm | 1 |
| `EXP` | counting block into the fsm | 1 |
| `Select` | fsm into the counting block | 2 |
| `RESETBAR`, `CLOCK` | into everything | 1 each |

## The counting block

One block serves all three periods. It loads whichever of `MSC`, `SSC` or `YC`
that `Select` names, counts down, raises `EXP` at zero and **stops there**.
Stopping is what lets s0 sit at expired while it
waits for a car, so a car arriving late changes the light with no further wait.

It reloads when `Select` changes, which `changeDetect` reports. `Select` changes
on all four transitions and on none of the self loops, so it stands in for a
change of state.

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
