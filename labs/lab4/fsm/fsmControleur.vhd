-- the keyboard controller's state machine. three states.
-- idle waits for the start bit, scan shifts the eight data bits in, and wait
-- lets the parity and stop bits go past without shifting them.
-- HorlogeClavier is the keyboard clock, InfoClavier the keyboard data,
-- Décale means shift and Compteur means counter.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fsmControleur IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;   -- the filtered keyboard clock
    i_resetBar : IN  STD_LOGIC;
    i_info     : IN  STD_LOGIC;   -- InfoClavier, the keyboard data line
    i_c8       : IN  STD_LOGIC;   -- the count reached eight
    i_c10      : IN  STD_LOGIC;   -- the count reached ten
    o_setCount : OUT STD_LOGIC;   -- Set Compteur, holds the counter at zero
    o_enable   : OUT STD_LOGIC;   -- lets the counter run
    o_shift    : OUT STD_LOGIC);  -- Décale, shifts the register
END fsmControleur;

ARCHITECTURE rtl OF fsmControleur IS
BEGIN

END rtl;
