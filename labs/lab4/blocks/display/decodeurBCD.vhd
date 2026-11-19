-- splits the scan code into its two hexadecimal digits. the byte is already
-- two nibbles, so the high four bits are the left digit and the low four the
-- right one.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decodeurBCD IS
  PORT( -- ports
    i_scanCode : IN  STD_LOGIC_VECTOR(7 downto 0);
    o_bcd1     : OUT STD_LOGIC_VECTOR(3 downto 0);   -- left digit
    o_bcd2     : OUT STD_LOGIC_VECTOR(3 downto 0));  -- right digit
END decodeurBCD;

ARCHITECTURE rtl OF decodeurBCD IS
BEGIN

END rtl;
