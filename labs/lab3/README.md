# Laboratory 3, traffic light controller

| File | What it is |
|---|---|
| `trafficLightController.vhd` | the top entity, ports are the board pins |
| `fsm/fsmControl.vhd` | the state machine |
| `fsm/dff.vhd` | one bit register, asynchronous reset, synchronous enable |
| `blocks/counting/countingBlock.vhd` | times the three periods |
| `blocks/counting/downCounter4.vhd` | four bit down counter with a parallel load |
| `blocks/counting/periodMux.vhd` | picks which period the counter loads |
| `blocks/change-detect/changeDetect.vhd` | reports that the selected period changed |
| `blocks/display/bcdDecoder.vhd` | the bonus, the count as two decimal digits |
| `blocks/provided/display_controller.vhd` | Appendix F, scans the eight digits |
| `test-benches/` | one per block, and `top_tb` for the scenarios in section 5.5 |
| `Nexys-A7-100T-Master.xdc` | pin and timing constraints |

The debouncer, the clock divider and the display controller come from the course
material. Section 6 allows them and requires that they be referenced in the
report.
