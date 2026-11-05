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
signal int_q : std_logic;

BEGIN
  process(i_resetBar, i_clock)
  begin
    if (i_resetBar = '0') then 
      int_q <= '0';
    elsif (i_clock'EVENT and i_clock = '1') then
      if (i_enable = '1') then
        int_q <= i_d;
      end if;
    end if;
  end process;

o_q <= int_q;
o_qBar <= not(int_q);
    

END rtl;
