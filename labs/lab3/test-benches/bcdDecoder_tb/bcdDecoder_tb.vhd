LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY bcdDecoder_tb IS
END bcdDecoder_tb;

ARCHITECTURE sim OF bcdDecoder_tb IS

    COMPONENT bcdDecoder IS
        PORT(
            i_count : IN  STD_LOGIC_VECTOR(3 downto 0);
            o_bcd1  : OUT STD_LOGIC_VECTOR(3 downto 0);
            o_bcd2  : OUT STD_LOGIC_VECTOR(3 downto 0)
        );
    END COMPONENT;

    SIGNAL i_count : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    SIGNAL o_bcd1  : STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL o_bcd2  : STD_LOGIC_VECTOR(3 downto 0);

BEGIN

    -- Unit Under Test (UUT)
    UUT: bcdDecoder
        PORT MAP(
            i_count => i_count,
            o_bcd1  => o_bcd1,
            o_bcd2  => o_bcd2
        );

    -- Test process
    PROCESS
    BEGIN

        -- Test all values from 0 to 15
        FOR i IN 0 TO 15 LOOP

            i_count <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, 4));

            WAIT FOR 10 ns;

            -- Check tens digit
            ASSERT o_bcd1 =
                STD_LOGIC_VECTOR(TO_UNSIGNED(i / 10, 4))
                REPORT "Tens digit incorrect"
                SEVERITY ERROR;

            -- Check units digit
            ASSERT o_bcd2 =
                STD_LOGIC_VECTOR(TO_UNSIGNED(i MOD 10, 4))
                REPORT "Units digit incorrect"
                SEVERITY ERROR;

        END LOOP;

        REPORT "BCD Decoder test completed"
            SEVERITY NOTE;

        WAIT;

    END PROCESS;

END sim;
