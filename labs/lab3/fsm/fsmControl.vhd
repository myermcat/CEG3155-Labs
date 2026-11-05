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
    i_enable   : IN  STD_LOGIC;
    i_sscs     : IN  STD_LOGIC;                     -- car on the side street
    i_exp      : IN  STD_LOGIC;                     -- the period ran out
    o_mstl     : OUT STD_LOGIC_VECTOR(2 downto 0);  -- 2 red, 1 yellow, 0 green
    o_sstl     : OUT STD_LOGIC_VECTOR(2 downto 0);
    o_select   : OUT STD_LOGIC_VECTOR(1 downto 0)); -- which period to count
END fsmControl;

ARCHITECTURE rtl OF fsmControl IS
  signal y2, y1 : std_logic;
  signal Y2n, Y1n : std_logic;

  component dff
    port(
      i_resetBar, i_d, i_enable, i_clock : in std_logic;
      o_q, o_qBar : out std_logic);
  end component;

BEGIN

  Y2n <= (y2 and not(y1)) or (not(i_exp) and y2) or (i_exp and not(y2) and y1);
  Y1n <= (not(i_exp) and y1) or (i_exp and y2 and not(y1)) or (i_sscs and i_exp and not(y2) and not(y1));


  y2_dff: dff
    port map(
      i_resetBar => i_resetBar,
      i_d => Y2n,
      i_enable => i_enable,
      i_clock => i_clock,
      o_q => y2,
      o_qBar => open
    );

  y1_dff: dff
    port map(
      i_resetBar => i_resetBar,
      i_d => Y1n,
      i_enable => i_enable,
      i_clock => i_clock,
      o_q => y1,
      o_qBar => open
    );

o_mstl(2) <= y2;
o_mstl(1) <= not(y2) and y1;
o_mstl(0) <= not(y2) and not(y1);

o_sstl(2) <= not(y2);
o_sstl(1) <= y2 and y1;
o_sstl(0) <= y2 and not(y1);

o_select(1) <= y2;
o_select(0) <= y1;

END rtl;
