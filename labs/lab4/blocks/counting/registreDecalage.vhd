-- eight bit shift register. one bit of InfoClavier comes in on every filtered
-- keyboard clock while i_shift is on, and the byte stays put between frames,
-- which is what keeps the last scan code on the display.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY registreDecalage IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_shift    : IN  STD_LOGIC;
    i_serial   : IN  STD_LOGIC;                      -- InfoClavier
    o_value    : OUT STD_LOGIC_VECTOR(7 downto 0));  -- the scan code
END registreDecalage;

ARCHITECTURE rtl OF registreDecalage IS
BEGIN

END rtl;
