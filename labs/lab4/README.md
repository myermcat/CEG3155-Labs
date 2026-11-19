# Laboratory 4, keyboard controller

Reads the scan code bytes a PS/2 keyboard sends and shows the last byte, in
hexadecimal, on two digits. The handout's names are French; the English is
given beside each one below.

| File | What it is |
|---|---|
| `controleurClavier.vhd` | keyboard controller, the top entity, ports are the board pins |
| `fsm/fsmControleur.vhd` | the state machine, three states |
| `fsm/dff.vhd` | one bit register, asynchronous reset, synchronous enable |
| `blocks/filter/filtre_digitale.vhd` | digital filter on the keyboard clock |
| `blocks/counting/compteur4bit.vhd` | four bit counter, and the two comparisons |
| `blocks/counting/registreDecalage.vhd` | shift register, `décalage` is shift |
| `blocks/display/decodeurBCD.vhd` | splits the byte into two hexadecimal digits |
| `blocks/provided/afficheur7seg.vhd` | seven segment display driver, Appendix F |
| `controleurClavier.xdc` | pin and timing constraints |
| `test-benches/` | one per block |

## The frame

Eleven bits arrive on `InfoClavier` (keyboard data), least significant first:
one start bit, eight data bits, one odd parity bit, one stop bit. Between
frames the line idles high. A make code goes out when a key is pressed and a
break code when it is released, and the break code is `F0` followed by the make
code, so it is two frames.

## The state machine

| State | What it is doing | `Set Compteur` | `Enable` | `Décale` |
|---|---|---|---|---|
| idle | waiting for the line to drop | 1 | 0 | 0 |
| scan | shifting the eight data bits in | 0 | 1 | 1 |
| wait | letting parity and stop go past | 0 | 1 | 0 |

The start bit is the zero that leaves idle, so it never enters the shift
register and no flip flop is needed to catch it.

`Set Compteur` (set counter) holds the count at zero in idle, which is what
lets the second keypress work. It is the complement of `Enable`.

## Two things that catch people

**The filter's latch is a deliberate combinational loop.** Vivado refuses it
until the constraints file carries `ALLOW_COMBINATORIAL_LOOPS` on that net.

**The keyboard clock is not the global clock.** It comes from the keyboard, is
about ten thousand times slower, and stops between keystrokes. Nothing
synchronises the two, which is why the filter exists.
