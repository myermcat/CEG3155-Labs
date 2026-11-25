-- the keyboard controller's state machine. three states.
-- idle waits for the start bit, scan shifts the eight data bits in, and wait
-- lets the parity and stop bits go past without shifting them.
-- keyboardClock is the keyboard clock, keyboardData the keyboard data,
-- shift means shift and counter means counter.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fsmController IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;   -- the filtered keyboard clock
    i_resetBar : IN  STD_LOGIC;
    i_info     : IN  STD_LOGIC;   -- keyboardData, the keyboard data line
    i_c8       : IN  STD_LOGIC;   -- the count reached eight
    i_c10      : IN  STD_LOGIC;   -- the count reached ten
    o_setCount : OUT STD_LOGIC;   -- setCount, holds the counter at zero
    o_enable   : OUT STD_LOGIC;   -- lets the counter run
    o_shift    : OUT STD_LOGIC);  -- shift, shifts the register
END fsmController;

ARCHITECTURE rtl OF fsmController IS
BEGIN

END rtl;
