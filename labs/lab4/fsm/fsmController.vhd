-- the keyboard controller's state machine. three states.
-- idle waits for the start bit, scan shifts the eight data bits in, and wait
-- lets the parity and stop bits go past without shifting them.
-- keyboardClock is the keyboard clock, keyboardData the keyboard data,
-- shift means shift and counter means counter.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fsmController IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;   -- the filtered keyboard clock
    i_resetBar : IN  STD_LOGIC;
    i_info     : IN  STD_LOGIC;   -- keyboardData, the keyboard data line
    i_c8       : IN  STD_LOGIC;   -- the count reached eight
    i_c10      : IN  STD_LOGIC;   -- the count reached ten
    o_setCount : OUT STD_LOGIC;   -- setCount, holds the counter at zero
    o_enable   : OUT STD_LOGIC;   -- lets the counter run
    o_shift    : OUT STD_LOGIC);  -- shift, shifts the register
END fsmController;

ARCHITECTURE rtl OF fsmController IS
signal Y2n, Y1n, y2, y1 : std_logic;

component dff
  port(
    i_resetBar, i_d, i_enable, i_clock : in std_logic;
    o_q, o_qBar : out std_logic
  );
end component;

BEGIN
  Y2n <= (y1 and i_c8) or (y2 and not(i_c10));
  Y1n <= (not(y2) and not(y1) and not(i_info)) or (y1 and not(i_c8));

  y2_dff: dff
    port map(
      i_resetBar => i_resetBar,
      i_d => Y2n,
      i_enable => '1',
      i_clock => i_clock,
      o_q => y2,
      o_qBar => open 
    );
  
  y1_dff: dff
    port map(
      i_resetBar => i_resetBar,
      i_d => Y1n,
      i_enable => '1',
      i_clock => i_clock,
      o_q => y1,
      o_qBar => open 
    );
  
  o_setCount <= y2 nor y1;
  o_enable <= not (y2 nor y1);
  o_shift <= y1;

END rtl;
