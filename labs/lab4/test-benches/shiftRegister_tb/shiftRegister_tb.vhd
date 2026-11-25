-- shifts in the make code for the a key, 1C, the way the keyboard sends it:
-- least significant bit first. after eight shifts o_value should read 00011100.
-- then it is left alone for two clocks to show the byte stays put.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY shiftRegister_tb IS
END shiftRegister_tb;

ARCHITECTURE sim OF shiftRegister_tb IS

  COMPONENT shiftRegister IS
    PORT(
      i_clock    : IN  STD_LOGIC;
      i_resetBar : IN  STD_LOGIC;
      i_shift    : IN  STD_LOGIC;
      i_serial   : IN  STD_LOGIC;
      o_value    : OUT STD_LOGIC_VECTOR(7 downto 0));
  END COMPONENT;

  SIGNAL clock    : STD_LOGIC := '0';
  SIGNAL resetBar : STD_LOGIC := '0';
  SIGNAL shift    : STD_LOGIC := '0';
  SIGNAL serial   : STD_LOGIC := '0';
  SIGNAL value    : STD_LOGIC_VECTOR(7 downto 0);

  -- 1C sent least significant bit first
  CONSTANT frame : STD_LOGIC_VECTOR(0 to 7) := "00111000";

BEGIN

  DUT: shiftRegister PORT MAP(
    i_clock    => clock,
    i_resetBar => resetBar,
    i_shift    => shift,
    i_serial   => serial,
    o_value    => value
  );

  stimulus: PROCESS
  BEGIN
    WAIT FOR 20 ns;
    resetBar <= '1';
    WAIT FOR 20 ns;

    shift <= '1';
    FOR i IN 0 TO 7 LOOP
      serial <= frame(i);
      WAIT FOR 10 ns;
      clock <= '1'; WAIT FOR 10 ns; clock <= '0'; WAIT FOR 10 ns;
    END LOOP;

    -- shifting off, the byte has to hold
    shift  <= '0';
    serial <= '1';
    FOR i IN 1 TO 2 LOOP
      clock <= '1'; WAIT FOR 10 ns; clock <= '0'; WAIT FOR 10 ns;
    END LOOP;

    WAIT;
  END PROCESS;

END sim;
