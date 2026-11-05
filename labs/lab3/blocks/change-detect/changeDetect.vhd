-- the counter reloads on every state change, and select changes on every
-- transition and on none of the self loops. so we hold the previous select and
-- raise o_changed when the two differ.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY changeDetect IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_select   : IN  STD_LOGIC_VECTOR(1 downto 0);
    o_changed  : OUT STD_LOGIC);
END changeDetect;

ARCHITECTURE rtl OF changeDetect IS
BEGIN

END rtl;
