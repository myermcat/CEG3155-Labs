-- a whole keystroke through the finished design. the keyboard clock runs at
-- about 12.5 kHz, eighty microseconds a period, and the data line carries the
-- make code for the a key: a start bit, 1C least significant bit first, odd
-- parity, and a stop bit. BCD1 and BCD2 should finish reading 1 and C.
--
-- the data line is moved while the keyboard clock is high, since a real
-- keyboard changes it there and the design registers it on the falling edge.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY keyboardController_tb IS
END keyboardController_tb;

ARCHITECTURE sim OF keyboardController_tb IS

  COMPONENT keyboardController IS
    PORT(
      globalClock   : IN  STD_LOGIC;
      globalReset   : IN  STD_LOGIC;
      keyboardClock : IN  STD_LOGIC;
      keyboardData  : IN  STD_LOGIC;
      BCD1          : OUT STD_LOGIC_VECTOR(3 downto 0);
      BCD2          : OUT STD_LOGIC_VECTOR(3 downto 0);
      SEG           : OUT STD_LOGIC_VECTOR(6 downto 0);
      DP            : OUT STD_LOGIC;
      AN            : OUT STD_LOGIC_VECTOR(7 downto 0));
  END COMPONENT;

  SIGNAL globalClock   : STD_LOGIC := '0';
  SIGNAL globalReset   : STD_LOGIC := '0';
  SIGNAL keyboardClock : STD_LOGIC := '1';
  SIGNAL keyboardData  : STD_LOGIC := '1';
  SIGNAL BCD1, BCD2    : STD_LOGIC_VECTOR(3 downto 0);
  SIGNAL SEG           : STD_LOGIC_VECTOR(6 downto 0);
  SIGNAL DP            : STD_LOGIC;
  SIGNAL AN            : STD_LOGIC_VECTOR(7 downto 0);
  SIGNAL running       : STD_LOGIC := '1';

  -- start, 1C least significant bit first, odd parity, stop
  CONSTANT frame : STD_LOGIC_VECTOR(0 to 10) := "00011100001";

BEGIN

  DUT: keyboardController PORT MAP(
    globalClock   => globalClock,
    globalReset   => globalReset,
    keyboardClock => keyboardClock,
    keyboardData  => keyboardData,
    BCD1          => BCD1,
    BCD2          => BCD2,
    SEG           => SEG,
    DP            => DP,
    AN            => AN
  );

  -- the 100 MHz oscillator
  oscillator: PROCESS
  BEGIN
    WHILE running = '1' LOOP
      globalClock <= '0'; WAIT FOR 5 ns;
      globalClock <= '1'; WAIT FOR 5 ns;
    END LOOP;
    WAIT;
  END PROCESS;

  stimulus: PROCESS
  BEGIN
    WAIT FOR 200 ns;
    globalReset <= '1';
    WAIT FOR 1 us;

    FOR i IN 0 TO 10 LOOP
      -- the keyboard puts the bit up while its clock is high
      keyboardData  <= frame(i);
      WAIT FOR 20 us;
      keyboardClock <= '0';
      WAIT FOR 40 us;
      keyboardClock <= '1';
      WAIT FOR 20 us;
    END LOOP;

    -- the line goes back to idle and the byte has to stay on the outputs
    keyboardData <= '1';
    WAIT FOR 200 us;

    running <= '0';
    WAIT;
  END PROCESS;

END sim;
