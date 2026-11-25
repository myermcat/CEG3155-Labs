-- the digital filter on the keyboard clock. eight flip flops sample the raw
-- clock on every global clock edge, one AND fires when all eight read one and
-- another when all eight read zero, and those set and reset a latch.
-- so the filtered clock only moves after the raw one has held a level for
-- eighty nanoseconds, and a reflection shorter than that never gets through.
--
-- the latch is a deliberate combinational loop. vivado refuses it until the
-- constraints file carries ALLOW_COMBINATORIAL_LOOPS on this net.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY digitalFilter IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;   -- globalClock, the 100 MHz global clock
    i_resetBar : IN  STD_LOGIC;
    i_raw      : IN  STD_LOGIC;   -- keyboardClock, straight off the pin
    o_filtered : OUT STD_LOGIC);  -- the clean clock the rest of the design runs on
END digitalFilter;

ARCHITECTURE structural OF digitalFilter IS

  COMPONENT dff IS
    PORT(
      i_resetBar : IN  STD_LOGIC;
      i_d        : IN  STD_LOGIC;
      i_enable   : IN  STD_LOGIC;
      i_clock    : IN  STD_LOGIC;
      o_q        : OUT STD_LOGIC;
      o_qBar     : OUT STD_LOGIC);
  END COMPONENT;

  SIGNAL sample   : STD_LOGIC_VECTOR(7 downto 0);
  SIGNAL allOnes  : STD_LOGIC;
  SIGNAL allZeros : STD_LOGIC;
  SIGNAL filtered : STD_LOGIC;

BEGIN
  -- the raw clock walks down the chain, one global clock edge per step
  FF7: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => i_raw,
    i_enable   => '1',
    i_clock    => i_clock,
    o_q        => sample(7),
    o_qBar     => OPEN
  );
  FF6: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => sample(7),
    i_enable   => '1',
    i_clock    => i_clock,
    o_q        => sample(6),
    o_qBar     => OPEN
  );
  FF5: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => sample(6),
    i_enable   => '1',
    i_clock    => i_clock,
    o_q        => sample(5),
    o_qBar     => OPEN
  );
  FF4: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => sample(5),
    i_enable   => '1',
    i_clock    => i_clock,
    o_q        => sample(4),
    o_qBar     => OPEN
  );
  FF3: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => sample(4),
    i_enable   => '1',
    i_clock    => i_clock,
    o_q        => sample(3),
    o_qBar     => OPEN
  );
  FF2: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => sample(3),
    i_enable   => '1',
    i_clock    => i_clock,
    o_q        => sample(2),
    o_qBar     => OPEN
  );
  FF1: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => sample(2),
    i_enable   => '1',
    i_clock    => i_clock,
    o_q        => sample(1),
    o_qBar     => OPEN
  );
  FF0: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => sample(1),
    i_enable   => '1',
    i_clock    => i_clock,
    o_q        => sample(0),
    o_qBar     => OPEN
  );

  allOnes  <= sample(7) AND sample(6) AND sample(5) AND sample(4)
          AND sample(3) AND sample(2) AND sample(1) AND sample(0);

  allZeros <= NOT sample(7) AND NOT sample(6) AND NOT sample(5) AND NOT sample(4)
          AND NOT sample(3) AND NOT sample(2) AND NOT sample(1) AND NOT sample(0);

  -- the latch. all ones sets it, all zeros clears it, and anything else leaves
  -- it alone, which is the loop
  filtered <= allOnes OR (filtered AND NOT allZeros);

  --output
  o_filtered <= filtered;

END structural;
