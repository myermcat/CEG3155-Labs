-- bonus. splits the current count into two decimal digits for the display.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bcdDecoder IS
  PORT( -- ports
    i_count : IN  STD_LOGIC_VECTOR(3 downto 0);
    o_bcd1  : OUT STD_LOGIC_VECTOR(3 downto 0);  -- left digit, the tens
    o_bcd2  : OUT STD_LOGIC_VECTOR(3 downto 0)); -- right digit, the units
END bcdDecoder;

ARCHITECTURE rtl OF bcdDecoder IS
BEGIN

END rtl;
