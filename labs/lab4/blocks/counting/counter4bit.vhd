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

ARCHITECTURE structural OF counter4bit IS

  COMPONENT dff IS
    PORT(
      i_resetBar : IN  STD_LOGIC;
      i_d        : IN  STD_LOGIC;
      i_enable   : IN  STD_LOGIC;
      i_clock    : IN  STD_LOGIC;
      o_q        : OUT STD_LOGIC;
      o_qBar     : OUT STD_LOGIC);
  END COMPONENT;

  SIGNAL count     : STD_LOGIC_VECTOR(3 downto 0);
  SIGNAL incCount  : STD_LOGIC_VECTOR(3 downto 0);
  SIGNAL nextCount : STD_LOGIC_VECTOR(3 downto 0);
  SIGNAL ffEnable  : STD_LOGIC;

BEGIN
  incCount(0) <= NOT count(0);

  incCount(1) <= count(1) XOR count(0);

  incCount(2) <= count(2) XOR (count(1) AND count(0));

  incCount(3) <= count(3) XOR (count(2) AND count(1) AND count(0));

  -- enable when counting or when being set back to zero
  ffEnable <= i_set OR i_enable;

  nextCount(0) <= NOT i_set AND incCount(0);

  nextCount(1) <= NOT i_set AND incCount(1);

  nextCount(2) <= NOT i_set AND incCount(2);

  nextCount(3) <= NOT i_set AND incCount(3);

  FF0: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => nextCount(0),
    i_enable   => ffEnable,
    i_clock    => i_clock,
    o_q        => count(0),
    o_qBar     => OPEN
  );
  FF1: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => nextCount(1),
    i_enable   => ffEnable,
    i_clock    => i_clock,
    o_q        => count(1),
    o_qBar     => OPEN
  );
  FF2: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => nextCount(2),
    i_enable   => ffEnable,
    i_clock    => i_clock,
    o_q        => count(2),
    o_qBar     => OPEN
  );
  FF3: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => nextCount(3),
    i_enable   => ffEnable,
    i_clock    => i_clock,
    o_q        => count(3),
    o_qBar     => OPEN
  );

  -- the two questions the state machine asks. both fire one count early, since
  -- the machine reads them on the same edge that the counter steps on: at the
  -- eighth shift the count still reads seven
  o_c8  <= NOT count(3) AND count(2) AND count(1) AND count(0);

  o_c10 <= count(3) AND NOT count(2) AND NOT count(1) AND count(0);

  --output
  o_count <= count;

END structural;
