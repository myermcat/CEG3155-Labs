-- the global clock runs at 100 MHz, so ten nanosecond periods and the filter's
-- window is eighty. the raw clock gets a clean low, a glitch of forty
-- nanoseconds that has to be swallowed, and then a real level change that has
-- to get through.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY digitalFilter_tb IS
END digitalFilter_tb;

ARCHITECTURE sim OF digitalFilter_tb IS

  COMPONENT digitalFilter IS
    PORT(
      i_clock    : IN  STD_LOGIC;
      i_resetBar : IN  STD_LOGIC;
      i_raw      : IN  STD_LOGIC;
      o_filtered : OUT STD_LOGIC);
  END COMPONENT;

  SIGNAL clock    : STD_LOGIC := '0';
  SIGNAL resetBar : STD_LOGIC := '0';
  SIGNAL raw      : STD_LOGIC := '0';
  SIGNAL filtered : STD_LOGIC;
  SIGNAL running  : STD_LOGIC := '1';

BEGIN

  DUT: digitalFilter PORT MAP(
    i_clock    => clock,
    i_resetBar => resetBar,
    i_raw      => raw,
    o_filtered => filtered
  );

  -- the 100 MHz oscillator
  oscillator: PROCESS
  BEGIN
    WHILE running = '1' LOOP
      clock <= '0'; WAIT FOR 5 ns;
      clock <= '1'; WAIT FOR 5 ns;
    END LOOP;
    WAIT;
  END PROCESS;

  stimulus: PROCESS
  BEGIN
    WAIT FOR 20 ns;
    resetBar <= '1';

    -- a long low, so the all zeros gate holds the output down
    WAIT FOR 200 ns;

    -- a reflection. forty nanoseconds high is four samples, never eight,
    -- so the output must not move
    raw <= '1';
    WAIT FOR 40 ns;
    raw <= '0';
    WAIT FOR 160 ns;

    -- a real edge. after eighty nanoseconds the output goes high
    raw <= '1';
    WAIT FOR 400 ns;

    -- and back down
    raw <= '0';
    WAIT FOR 400 ns;

    running <= '0';
    WAIT;
  END PROCESS;

END sim;
