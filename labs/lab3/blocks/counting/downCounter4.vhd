-- four bit down counter with a parallel load. counts while enabled and holds
-- otherwise, so the block above can stop it at zero.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY downCounter4 IS
  PORT(
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_load     : IN  STD_LOGIC;
    i_enable   : IN  STD_LOGIC;
    i_value    : IN  STD_LOGIC_VECTOR(3 downto 0);
    o_count    : OUT STD_LOGIC_VECTOR(3 downto 0));
END downCounter4;

ARCHITECTURE structural OF downCounter4 IS

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
  SIGNAL decCount  : STD_LOGIC_VECTOR(3 downto 0);
  SIGNAL nextCount : STD_LOGIC_VECTOR(3 downto 0);
  SIGNAL ffEnable  : STD_LOGIC;

BEGIN
  decCount(0) <= NOT count(0);

  decCount(1) <= count(1) XOR (NOT count(0));

  decCount(2) <= count(2) XOR (NOT count(1) AND NOT count(0));

  decCount(3) <= count(3) XOR (NOT count(2) AND NOT count(1) AND NOT count(0));

  -- Enable when loading or counting
  ffEnable <= i_load OR i_enable;

  nextCount(0) <= (i_load AND i_value(0)) OR (NOT i_load AND decCount(0));

  nextCount(1) <= (i_load AND i_value(1)) OR (NOT i_load AND decCount(1));

  nextCount(2) <= (i_load AND i_value(2)) OR (NOT i_load AND decCount(2));

  nextCount(3) <= (i_load AND i_value(3)) OR (NOT i_load AND decCount(3));

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

  --output
  o_count <= count;

END structural;
