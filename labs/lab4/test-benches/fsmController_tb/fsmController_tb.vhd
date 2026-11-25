-- walks the machine through a whole frame on the filtered clock. idle holds
-- until the start bit pulls the data line low, scan runs for eight bits, wait
-- sits through parity and stop, and it comes back to idle.
-- c8 and c10 are driven by hand here so the machine can be looked at on its own.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fsmController_tb IS
END fsmController_tb;

ARCHITECTURE sim OF fsmController_tb IS

  COMPONENT fsmController IS
    PORT(
      i_clock    : IN  STD_LOGIC;
      i_resetBar : IN  STD_LOGIC;
      i_info     : IN  STD_LOGIC;
      i_c8       : IN  STD_LOGIC;
      i_c10      : IN  STD_LOGIC;
      o_setCount : OUT STD_LOGIC;
      o_enable   : OUT STD_LOGIC;
      o_shift    : OUT STD_LOGIC);
  END COMPONENT;

  SIGNAL clock    : STD_LOGIC := '0';
  SIGNAL resetBar : STD_LOGIC := '0';
  SIGNAL info     : STD_LOGIC := '1';
  SIGNAL c8       : STD_LOGIC := '0';
  SIGNAL c10      : STD_LOGIC := '0';
  SIGNAL setCount : STD_LOGIC;
  SIGNAL enable   : STD_LOGIC;
  SIGNAL shift    : STD_LOGIC;

BEGIN

  DUT: fsmController PORT MAP(
    i_clock    => clock,
    i_resetBar => resetBar,
    i_info     => info,
    i_c8       => c8,
    i_c10      => c10,
    o_setCount => setCount,
    o_enable   => enable,
    o_shift    => shift
  );

  stimulus: PROCESS
  BEGIN
    WAIT FOR 20 ns;
    resetBar <= '1';
    WAIT FOR 20 ns;

    -- idle. the line is high, so two clocks change nothing
    FOR i IN 1 TO 2 LOOP
      clock <= '1'; WAIT FOR 10 ns; clock <= '0'; WAIT FOR 10 ns;
    END LOOP;

    -- the start bit. one clock later the machine is in scan
    info <= '0';
    WAIT FOR 10 ns;
    clock <= '1'; WAIT FOR 10 ns; clock <= '0'; WAIT FOR 10 ns;
    info <= '1';

    -- eight data bits. the count has not reached eight yet, so it stays in scan
    FOR i IN 1 TO 7 LOOP
      clock <= '1'; WAIT FOR 10 ns; clock <= '0'; WAIT FOR 10 ns;
    END LOOP;

    -- the eighth bit is in. c8 sends it to wait
    c8 <= '1';
    WAIT FOR 10 ns;
    clock <= '1'; WAIT FOR 10 ns; clock <= '0'; WAIT FOR 10 ns;
    c8 <= '0';

    -- parity goes past
    clock <= '1'; WAIT FOR 10 ns; clock <= '0'; WAIT FOR 10 ns;

    -- the stop bit takes the count to ten and the machine returns to idle
    c10 <= '1';
    WAIT FOR 10 ns;
    clock <= '1'; WAIT FOR 10 ns; clock <= '0'; WAIT FOR 10 ns;
    c10 <= '0';

    -- back in idle, nothing moves
    FOR i IN 1 TO 2 LOOP
      clock <= '1'; WAIT FOR 10 ns; clock <= '0'; WAIT FOR 10 ns;
    END LOOP;

    WAIT;
  END PROCESS;

END sim;
