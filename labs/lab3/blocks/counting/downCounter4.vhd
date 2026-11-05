-- four bit down counter with a parallel load. counts while enabled and holds
-- otherwise, so the block above can stop it at zero.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY downCounter4 IS
  PORT(
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_load     : IN  STD_LOGIC;
    i_enable   : IN  STD_LOGIC;
    i_value    : IN  STD_LOGIC_VECTOR(3 downto 0);
    o_count    : OUT STD_LOGIC_VECTOR(3 downto 0));
END downCounter4;

ARCHITECTURE rtl OF downCounter4 IS
  SIGNAL count : UNSIGNED(3 downto 0);

BEGIN
  PROCESS(i_clock, i_resetBar)
  BEGIN
    IF i_resetBar = '0' THEN
      count <= "0000";
    ELSIF rising_edge(i_clock) THEN
      IF i_load = '1' THEN
        count <= UNSIGNED(i_value);
      ELSIF i_enable = '1' THEN
        count <= count - 1;
      END IF;
    END IF;
  END PROCESS;
  o_count <= STD_LOGIC_VECTOR(count);
        
END rtl;
