
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY downCounter4_tb IS
END downCounter4_tb;

ARCHITECTURE sim OF downCounter4_tb IS

  COMPONENT downCounter4 IS
    PORT(
      i_clock    : IN  STD_LOGIC;
      i_resetBar : IN  STD_LOGIC;
      i_load     : IN  STD_LOGIC;
      i_enable   : IN  STD_LOGIC;
      i_value    : IN  STD_LOGIC_VECTOR(3 downto 0);
      o_count    : OUT STD_LOGIC_VECTOR(3 downto 0)
    );
  END COMPONENT;

  SIGNAL i_clock    : STD_LOGIC := '0';
  SIGNAL i_resetBar : STD_LOGIC := '0';
  SIGNAL i_load     : STD_LOGIC := '0';
  SIGNAL i_enable   : STD_LOGIC := '0';
  SIGNAL i_value    : STD_LOGIC_VECTOR(3 downto 0) := "0000";
  SIGNAL o_count    : STD_LOGIC_VECTOR(3 downto 0);

  CONSTANT CLK_PERIOD : TIME := 10 ns;

BEGIN

  -- Unit Under Test
  UUT: downCounter4
    PORT MAP(
      i_clock    => i_clock,
      i_resetBar => i_resetBar,
      i_load     => i_load,
      i_enable   => i_enable,
      i_value    => i_value,
      o_count    => o_count
    );

  -- Clock generation
  clock_process: PROCESS
  BEGIN
    i_clock <= '0';
    WAIT FOR CLK_PERIOD / 2;
    i_clock <= '1';
    WAIT FOR CLK_PERIOD / 2;
  END PROCESS;

  -- Test process
  test_process: PROCESS
  BEGIN

    -- Test 1: Asynchronous reset
    i_resetBar <= '0';
    WAIT FOR 12 ns;

    ASSERT o_count = "0000"
      REPORT "Test 1 failed: Reset"
      SEVERITY ERROR;

    -- Release reset
    i_resetBar <= '1';
    WAIT FOR 10 ns;

    -- Test 2: Parallel load (load 5)
    i_value <= "0101";
    i_load <= '1';
    WAIT FOR 10 ns;

    ASSERT o_count = "0101"
      REPORT "Test 2 failed: Load 5"
      SEVERITY ERROR;

    -- Test 3: Decrement 5 -> 4
    i_load <= '0';
    i_enable <= '1';
    WAIT FOR 10 ns;

    ASSERT o_count = "0100"
      REPORT "Test 3 failed: Decrement to 4"
      SEVERITY ERROR;

    -- Test 4: Decrement 4 -> 3
    WAIT FOR 10 ns;

    ASSERT o_count = "0011"
      REPORT "Test 4 failed: Decrement to 3"
      SEVERITY ERROR;

    -- Test 5: Hold current value
    i_enable <= '0';
    WAIT FOR 10 ns;

    ASSERT o_count = "0011"
      REPORT "Test 5 failed: Hold"
      SEVERITY ERROR;

    -- Test 6: Load priority over enable
    i_value <= "1001";
    i_load <= '1';
    i_enable <= '1';
    WAIT FOR 10 ns;

    ASSERT o_count = "1001"
      REPORT "Test 6 failed: Load priority"
      SEVERITY ERROR;

    -- Test 7: Load zero
    i_value <= "0000";
    i_enable <= '0';
    WAIT FOR 10 ns;

    ASSERT o_count = "0000"
      REPORT "Test 7 failed: Load zero"
      SEVERITY ERROR;

    -- Test 8: Underflow 0 -> 15
    i_load <= '0';
    i_enable <= '1';
    WAIT FOR 10 ns;

    ASSERT o_count = "1111"
      REPORT "Test 8 failed: Underflow"
      SEVERITY ERROR;

    -- Test 9: Decrement 15 -> 14
    WAIT FOR 10 ns;

    ASSERT o_count = "1110"
      REPORT "Test 9 failed: Decrement to 14"
      SEVERITY ERROR;

    -- Test 10: Asynchronous reset while counting
    i_resetBar <= '0';
    WAIT FOR 2 ns;

    ASSERT o_count = "0000"
      REPORT "Test 10 failed: Async reset"
      SEVERITY ERROR;

    -- Disable counter
    i_enable <= '0';
    i_resetBar <= '1';

    REPORT "All downCounter4 tests completed"
      SEVERITY NOTE;

    WAIT;

  END PROCESS;

END sim;

