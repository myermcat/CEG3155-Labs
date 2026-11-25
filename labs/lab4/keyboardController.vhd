-- top entity. ports are the board pins.
-- the filter cleans the keyboard clock, the state machine walks the frame,
-- the counter tells it how many bits have gone in, and the shift register
-- holds the scan code for the display.
--
-- the only clock that reaches the blocks is the filtered keyboard clock, so
-- the global clock does nothing here except drive the filter and the display
-- refresh. that is the asynchronous build the bonus asks for.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY keyboardController IS
  PORT( -- ports
    globalClock    : IN  STD_LOGIC;                      -- E3, 100 MHz
    globalReset    : IN  STD_LOGIC;                      -- C12, CPU RESETN
    keyboardClock  : IN  STD_LOGIC;                      -- F4, PS2 clock
    keyboardData   : IN  STD_LOGIC;                      -- B2, PS2 data
    BCD1           : OUT STD_LOGIC_VECTOR(3 downto 0);   -- LD15 to LD12
    BCD2           : OUT STD_LOGIC_VECTOR(3 downto 0);   -- LD7 to LD4
    SEG            : OUT STD_LOGIC_VECTOR(6 downto 0);   -- cathodes, active low
    DP             : OUT STD_LOGIC;                      -- H15
    AN             : OUT STD_LOGIC_VECTOR(7 downto 0));  -- anodes, active low
END keyboardController;

ARCHITECTURE structural OF keyboardController IS

  COMPONENT digitalFilter IS
    PORT(
      i_clock    : IN  STD_LOGIC;
      i_resetBar : IN  STD_LOGIC;
      i_raw      : IN  STD_LOGIC;
      o_filtered : OUT STD_LOGIC);
  END COMPONENT;

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

  COMPONENT shiftRegister IS
    PORT(
      i_clock    : IN  STD_LOGIC;
      i_resetBar : IN  STD_LOGIC;
      i_shift    : IN  STD_LOGIC;
      i_serial   : IN  STD_LOGIC;
      o_value    : OUT STD_LOGIC_VECTOR(7 downto 0));
  END COMPONENT;

  COMPONENT bcdDecoder IS
    PORT(
      i_scanCode : IN  STD_LOGIC_VECTOR(7 downto 0);
      o_bcd1     : OUT STD_LOGIC_VECTOR(3 downto 0);
      o_bcd2     : OUT STD_LOGIC_VECTOR(3 downto 0));
  END COMPONENT;

  COMPONENT display_controller IS
    PORT(
      clk100      : IN  STD_LOGIC;
      d0,d1,d2,d3 : IN  STD_LOGIC_VECTOR(3 downto 0);
      seg         : OUT STD_LOGIC_VECTOR(6 downto 0);
      an          : OUT STD_LOGIC_VECTOR(7 downto 0));
  END COMPONENT;

  SIGNAL filteredClock : STD_LOGIC;
  SIGNAL setCount      : STD_LOGIC;
  SIGNAL enable        : STD_LOGIC;
  SIGNAL shift         : STD_LOGIC;
  SIGNAL c8, c10       : STD_LOGIC;
  SIGNAL bcd1s, bcd2s  : STD_LOGIC_VECTOR(3 downto 0);
  SIGNAL scanCode      : STD_LOGIC_VECTOR(7 downto 0);

BEGIN
  -- CPU RESETN is already active low, so it is the reset bar everything takes

  dgtlF: digitalFilter
    port map(
      i_clock    => globalClock,
      i_resetBar => globalReset,
      i_raw      => keyboardClock,
      o_filtered => filteredClock
    );

  fsm: fsmController
    port map(
      i_clock    => filteredClock,
      i_resetBar => globalReset,
      i_info     => keyboardData,
      i_c8       => c8,
      i_c10      => c10,
      o_setCount => setCount,
      o_enable   => enable,
      o_shift    => shift
    );

  counter: counter4bit
    port map(
      i_clock    => filteredClock,
      i_resetBar => globalReset,
      i_set      => setCount,
      i_enable   => enable,
      o_count    => open,
      o_c8       => c8,
      o_c10      => c10
    );

  shR: shiftRegister
    port map(
      i_clock    => filteredClock,
      i_resetBar => globalReset,
      i_shift    => shift,
      i_serial   => keyboardData,
      o_value    => scanCode
    );

  bcd: bcdDecoder
    port map(
      i_scanCode => scanCode,
      o_bcd1     => bcd1s,
      o_bcd2     => bcd2s
    );

  display: display_controller
  port map(
      clk100      => globalClock,
      d0          => bcd2s,
      d1          => bcd1s,
      d2          => "0000",
      d3          => "0000",
      seg         => SEG,
      an          => AN
  );

  BCD1 <= bcd1s;
  BCD2 <= bcd2s;
  DP   <= '1';

END structural;
