-- the traffic light controller. four states, two flip flops.
-- s0 main green, s1 main yellow, s2 side green, s3 side yellow.
-- y2 means the side street phase and y1 means a yellow phase, which is why
-- o_select comes straight off the flip flops with no gates.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fsmControl IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_sscs     : IN  STD_LOGIC;                     -- car on the side street
    i_exp      : IN  STD_LOGIC;                     -- the period ran out
    o_mstl     : OUT STD_LOGIC_VECTOR(2 downto 0);  -- 2 red, 1 yellow, 0 green
    o_sstl     : OUT STD_LOGIC_VECTOR(2 downto 0);
    o_select   : OUT STD_LOGIC_VECTOR(1 downto 0)); -- which period to count
END fsmControl;

ARCHITECTURE rtl OF fsmControl IS
BEGIN

END rtl;
