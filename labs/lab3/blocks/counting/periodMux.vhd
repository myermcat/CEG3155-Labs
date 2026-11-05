-- picks the period the counter loads. yellow is wired to both 01 and 11,
-- since the two yellow states ask for the same length.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY periodMux IS
  PORT( -- ports
    i_select  : IN  STD_LOGIC_VECTOR(1 downto 0);
    i_mscMax  : IN  STD_LOGIC_VECTOR(3 downto 0);  -- switches, main green
    i_sscMax  : IN  STD_LOGIC_VECTOR(3 downto 0);  -- switches, side green
    i_yc      : IN  STD_LOGIC_VECTOR(3 downto 0);  -- the fixed yellow
    o_value   : OUT STD_LOGIC_VECTOR(3 downto 0));
END periodMux;

ARCHITECTURE rtl OF periodMux IS
BEGIN

END rtl;
