-- one block for all three periods. loads whichever one i_select names, counts
-- down, raises o_exp at zero and stops there instead of rolling over, which is
-- what lets s0 sit at expired waiting for a car. reloads when i_reload goes up.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY countingBlock IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_reload   : IN  STD_LOGIC;
    i_select   : IN  STD_LOGIC_VECTOR(1 downto 0);
    i_mscMax   : IN  STD_LOGIC_VECTOR(3 downto 0);
    i_sscMax   : IN  STD_LOGIC_VECTOR(3 downto 0);
    o_exp      : OUT STD_LOGIC;
    o_count    : OUT STD_LOGIC_VECTOR(3 downto 0)); -- for the bcd display
END countingBlock;

ARCHITECTURE rtl OF countingBlock IS
BEGIN

END rtl;
