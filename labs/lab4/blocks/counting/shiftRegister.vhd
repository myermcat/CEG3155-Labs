-- eight bit shift register. one bit of keyboardData comes in on every filtered
-- keyboard clock while i_shift is on, and the byte stays put between frames,
-- which is what keeps the last scan code on the display.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY shiftRegister IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_shift    : IN  STD_LOGIC;
    i_serial   : IN  STD_LOGIC;                      -- keyboardData
    o_value    : OUT STD_LOGIC_VECTOR(7 downto 0));  -- the scan code
END shiftRegister;

ARCHITECTURE structural OF shiftRegister IS

  COMPONENT dff IS
    PORT(
      i_resetBar : IN  STD_LOGIC;
      i_d        : IN  STD_LOGIC;
      i_enable   : IN  STD_LOGIC;
      i_clock    : IN  STD_LOGIC;
      o_q        : OUT STD_LOGIC;
      o_qBar     : OUT STD_LOGIC);
  END COMPONENT;

  SIGNAL value : STD_LOGIC_VECTOR(7 downto 0);

BEGIN
  -- the keyboard sends the least significant bit first, so the new bit goes in
  -- at the top and everything walks down. after eight shifts the first bit
  -- that arrived sits in bit 0.
  FF7: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => i_serial,
    i_enable   => i_shift,
    i_clock    => i_clock,
    o_q        => value(7),
    o_qBar     => OPEN
  );
  FF6: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => value(7),
    i_enable   => i_shift,
    i_clock    => i_clock,
    o_q        => value(6),
    o_qBar     => OPEN
  );
  FF5: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => value(6),
    i_enable   => i_shift,
    i_clock    => i_clock,
    o_q        => value(5),
    o_qBar     => OPEN
  );
  FF4: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => value(5),
    i_enable   => i_shift,
    i_clock    => i_clock,
    o_q        => value(4),
    o_qBar     => OPEN
  );
  FF3: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => value(4),
    i_enable   => i_shift,
    i_clock    => i_clock,
    o_q        => value(3),
    o_qBar     => OPEN
  );
  FF2: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => value(3),
    i_enable   => i_shift,
    i_clock    => i_clock,
    o_q        => value(2),
    o_qBar     => OPEN
  );
  FF1: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => value(2),
    i_enable   => i_shift,
    i_clock    => i_clock,
    o_q        => value(1),
    o_qBar     => OPEN
  );
  FF0: dff PORT MAP(
    i_resetBar => i_resetBar,
    i_d        => value(1),
    i_enable   => i_shift,
    i_clock    => i_clock,
    o_q        => value(0),
    o_qBar     => OPEN
  );

  --output
  o_value <= value;

END structural;
