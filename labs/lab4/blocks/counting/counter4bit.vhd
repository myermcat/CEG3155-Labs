-- four bit counter. counts up while enabled, and i_set holds it at zero so
-- every frame starts from the same place.
-- the comparisons are here rather than in the state machine, so the machine
-- sees one bit per question instead of four bits of count.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter4bit IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_set      : IN  STD_LOGIC;
    i_enable   : IN  STD_LOGIC;
    o_count    : OUT STD_LOGIC_VECTOR(3 downto 0);
    o_c8       : OUT STD_LOGIC;
    o_c10      : OUT STD_LOGIC);
END counter4bit;

ARCHITECTURE rtl OF counter4bit IS
BEGIN

END rtl;
