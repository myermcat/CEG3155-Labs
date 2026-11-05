-- four bit down counter with a parallel load. counts while enabled and holds
-- otherwise, so the block above can stop it at zero.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY downCounter4 IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_load     : IN  STD_LOGIC;
    i_enable   : IN  STD_LOGIC;
    i_value    : IN  STD_LOGIC_VECTOR(3 downto 0);
    o_count    : OUT STD_LOGIC_VECTOR(3 downto 0));
END downCounter4;

ARCHITECTURE rtl OF downCounter4 IS
BEGIN

END rtl;
