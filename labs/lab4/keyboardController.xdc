## Nexys A7-100T constraints for the keyboard controller.
## Taken from the Digilent master file, with only the ports this design uses
## uncommented and renamed.

## 100 MHz oscillator
set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33 } [get_ports { globalClock }]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { globalClock }]

## cpu reset button, active low
set_property -dict { PACKAGE_PIN C12 IOSTANDARD LVCMOS33 } [get_ports { globalReset }]

## ps2 keyboard. the clock comes in asynchronously and gets filtered inside
set_property -dict { PACKAGE_PIN F4  IOSTANDARD LVCMOS33 } [get_ports { keyboardClock }]
set_property -dict { PACKAGE_PIN B2  IOSTANDARD LVCMOS33 } [get_ports { keyboardData }]

## high nibble on ld15 down to ld12
set_property -dict { PACKAGE_PIN V11 IOSTANDARD LVCMOS33 } [get_ports { BCD1[3] }]
set_property -dict { PACKAGE_PIN V12 IOSTANDARD LVCMOS33 } [get_ports { BCD1[2] }]
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports { BCD1[1] }]
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports { BCD1[0] }]

## low nibble on ld7 down to ld4
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports { BCD2[3] }]
set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports { BCD2[2] }]
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports { BCD2[1] }]
set_property -dict { PACKAGE_PIN R18 IOSTANDARD LVCMOS33 } [get_ports { BCD2[0] }]

## the handout's pin table also lists SW0, LD0 and LD1, but nothing in the
## specification says what they do, so this design leaves them out

## seven segment cathodes, active low
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { SEG[0] }]
set_property -dict { PACKAGE_PIN R10 IOSTANDARD LVCMOS33 } [get_ports { SEG[1] }]
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33 } [get_ports { SEG[2] }]
set_property -dict { PACKAGE_PIN K13 IOSTANDARD LVCMOS33 } [get_ports { SEG[3] }]
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports { SEG[4] }]
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports { SEG[5] }]
set_property -dict { PACKAGE_PIN L18 IOSTANDARD LVCMOS33 } [get_ports { SEG[6] }]
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports { DP }]

## seven segment anodes, active low
set_property -dict { PACKAGE_PIN J17 IOSTANDARD LVCMOS33 } [get_ports { AN[0] }]
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports { AN[1] }]
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { AN[2] }]
set_property -dict { PACKAGE_PIN J14 IOSTANDARD LVCMOS33 } [get_ports { AN[3] }]
set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports { AN[4] }]
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports { AN[5] }]
set_property -dict { PACKAGE_PIN K2  IOSTANDARD LVCMOS33 } [get_ports { AN[6] }]
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports { AN[7] }]

## the filter has a deliberate feedback loop in it
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical -filter { NAME =~ "*filter*" }]
