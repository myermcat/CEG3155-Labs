-- the one bit register everything in the fsm is built from.
-- async reset, so GReset puts the machine in a known state with no clock.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dff IS
  PORT( -- ports
    i_resetBar : IN  STD_LOGIC;
    i_d        : IN  STD_LOGIC;
    i_enable   : IN  STD_LOGIC;
    i_clock    : IN  STD_LOGIC;
    o_q, o_qBar : OUT STD_LOGIC);
END dff;

ARCHITECTURE rtl OF dff IS
BEGIN
  process(i_resetBar, i_clock)
  begin
    if (i_resetBar) then 
      o_q <= '0';

    

END rtl;
