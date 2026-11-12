LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY changeDetect_tb IS
END changeDetect_tb;

ARCHITECTURE sim OF changeDetect_tb IS

    COMPONENT changeDetect IS
        PORT(
            i_clock    : IN  STD_LOGIC;
            i_resetBar : IN  STD_LOGIC;
            i_select   : IN  STD_LOGIC_VECTOR(1 downto 0);
            o_changed  : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL i_clock    : STD_LOGIC := '0';
    SIGNAL i_resetBar : STD_LOGIC := '0';
    SIGNAL i_select   : STD_LOGIC_VECTOR(1 downto 0) := "00";
    SIGNAL o_changed  : STD_LOGIC;

    CONSTANT CLK_PERIOD : TIME := 10 ns;

BEGIN

    -- Unit Under Test
    UUT: changeDetect
        PORT MAP(
            i_clock    => i_clock,
            i_resetBar => i_resetBar,
            i_select   => i_select,
            o_changed  => o_changed
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
        -- the clock rises at 5 ns and every 10 ns after. starting 2 ns in and
        -- spending 10 ns on each test keeps every change off an edge, so the
        -- register never samples the new value in the instant it arrives
        WAIT FOR 2 ns;

        -- Test 1: Reset
        i_resetBar <= '0';
        i_select <= "00";
        WAIT FOR 12 ns;

        ASSERT o_changed = '0'
            REPORT "Test 1 failed: Reset"
            SEVERITY ERROR;

        -- Release reset
        i_resetBar <= '1';
        WAIT FOR 9 ns;

        -- Test 2: No state change (00 -> 00)
        ASSERT o_changed = '0'
            REPORT "Test 2 failed: No change"
            SEVERITY ERROR;

        -- Test 3: Change (00 -> 01)
        i_select <= "01";
        WAIT FOR 1 ns;

        ASSERT o_changed = '1'
            REPORT "Test 3 failed: 00 to 01"
            SEVERITY ERROR;

        -- Wait for next rising edge to store 01
        WAIT FOR 9 ns;

        ASSERT o_changed = '0'
            REPORT "Test 4 failed: Change not cleared"
            SEVERITY ERROR;

        -- Test 5: Change (01 -> 10)
        i_select <= "10";
        WAIT FOR 1 ns;

        ASSERT o_changed = '1'
            REPORT "Test 5 failed: 01 to 10"
            SEVERITY ERROR;

        WAIT FOR 9 ns;

        ASSERT o_changed = '0'
            REPORT "Test 6 failed: Change not cleared"
            SEVERITY ERROR;

        -- Test 7: Change (10 -> 11)
        i_select <= "11";
        WAIT FOR 1 ns;

        ASSERT o_changed = '1'
            REPORT "Test 7 failed: 10 to 11"
            SEVERITY ERROR;

        WAIT FOR 9 ns;

        ASSERT o_changed = '0'
            REPORT "Test 8 failed: Change not cleared"
            SEVERITY ERROR;

        -- Test 9: Change (11 -> 00)
        i_select <= "00";
        WAIT FOR 1 ns;

        ASSERT o_changed = '1'
            REPORT "Test 9 failed: 11 to 00"
            SEVERITY ERROR;

        WAIT FOR 9 ns;

        ASSERT o_changed = '0'
            REPORT "Test 10 failed: Change not cleared"
            SEVERITY ERROR;

        REPORT "All changeDetect tests completed"
            SEVERITY NOTE;

        WAIT;

    END PROCESS;

END sim;
