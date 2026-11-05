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
