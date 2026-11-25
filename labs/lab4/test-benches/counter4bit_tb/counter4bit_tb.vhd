-- counts a whole frame's worth of bits and watches the two comparisons come up.
-- c8 should pulse when the count is at eight and c10 when it is at ten.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter4bit_tb IS
END counter4bit_tb;

ARCHITECTURE sim OF counter4bit_tb IS

  COMPONENT counter4bit IS
    PORT(
      i_clock    : IN  STD_LOGIC;
      i_resetBar : IN  STD_LOGIC;
      i_set      : IN  STD_LOGIC;
      i_enable   : IN  STD_LOGIC;
      o_count    : OUT STD_LOGIC_VECTOR(3 downto 0);
      o_c8       : OUT STD_LOGIC;
      o_c10      : OUT STD_LOGIC);
  END COMPONENT;

  SIGNAL clock    : STD_LOGIC := '0';
  SIGNAL resetBar : STD_LOGIC := '0';
  SIGNAL set      : STD_LOGIC := '1';
  SIGNAL enable   : STD_LOGIC := '0';
  SIGNAL count    : STD_LOGIC_VECTOR(3 downto 0);
  SIGNAL c8, c10  : STD_LOGIC;

BEGIN

  DUT: counter4bit PORT MAP(
    i_clock    => clock,
    i_resetBar => resetBar,
    i_set      => set,
    i_enable   => enable,
    o_count    => count,
    o_c8       => c8,
    o_c10      => c10
  );

  stimulus: PROCESS
  BEGIN
    -- out of reset, held at zero by set
    WAIT FOR 20 ns;
    resetBar <= '1';
    WAIT FOR 20 ns;

    -- one clock while set is still on. the count must stay at zero
    clock <= '1'; WAIT FOR 10 ns; clock <= '0'; WAIT FOR 10 ns;

    -- now let it run. twelve clocks takes it past both comparisons
    set    <= '0';
    enable <= '1';
    WAIT FOR 10 ns;

    FOR i IN 1 TO 12 LOOP
      clock <= '1'; WAIT FOR 10 ns; clock <= '0'; WAIT FOR 10 ns;
    END LOOP;

    -- set it back and check it lands on zero in one clock
    set    <= '1';
    enable <= '0';
    WAIT FOR 10 ns;
    clock <= '1'; WAIT FOR 10 ns; clock <= '0'; WAIT FOR 10 ns;

    WAIT;
  END PROCESS;

END sim;
