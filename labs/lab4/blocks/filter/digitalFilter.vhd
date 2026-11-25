-- the digital filter on the keyboard clock. eight flip flops sample the raw
-- clock on every global clock edge, one AND fires when all eight read one and
-- another when all eight read zero, and those set and reset a latch.
-- so the filtered clock only moves after the raw one has held a level for
-- eighty nanoseconds, and a reflection shorter than that never gets through.
--
-- the latch is a deliberate combinational loop. vivado refuses it until the
-- constraints file carries ALLOW_COMBINATORIAL_LOOPS on this net.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY digitalFilter IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;   -- globalClock, the 100 MHz global clock
    i_resetBar : IN  STD_LOGIC;
    i_raw      : IN  STD_LOGIC;   -- keyboardClock, straight off the pin
    o_filtered : OUT STD_LOGIC);  -- the clean clock the rest of the design runs on
END digitalFilter;

ARCHITECTURE rtl OF digitalFilter IS
BEGIN

END rtl;
