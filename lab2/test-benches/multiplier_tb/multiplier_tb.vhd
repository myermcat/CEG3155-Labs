-- the three cases the TA asked for: positive by positive, negative by
-- negative, and one of each. the clock here stands in for the push button.
-- each pair gets a reset first and then exactly the number of presses its own
-- multiplication takes, so the waveform ends on the product and does not run
-- on into the next multiplication.

library ieee;
use ieee.std_logic_1164.all;

entity multiplier_tb is
end entity multiplier_tb;

architecture sim of multiplier_tb is
  signal clock, resetBar : std_logic := '0';
  signal A, B : std_logic_vector(3 downto 0) := "0000";
  signal S : std_logic_vector(7 downto 0);

  procedure tick (signal clk : out std_logic) is
  begin
    clk <= '1'; wait for 20 ns; clk <= '0'; wait for 20 ns;
  end procedure;

begin

  dut : entity work.multiplier(struct)
    port map ( i_clock => clock, i_resetBar => resetBar,
               i_A => A, i_B => B, o_S => S );

  stimulus : process
  begin
    -- 3 * 2 = 6. neither operand flips, and 2 has one bit set, so seven states
    resetBar <= '0'; wait for 40 ns;
    resetBar <= '1';
    A <= "0011"; B <= "0010"; wait for 40 ns;
    for i in 1 to 7 loop tick(clock); end loop;
    assert S = "00000110" report "3 times 2 should be 6" severity error;
    wait for 80 ns;

    -- -3 * -2 = 6. both flips happen, and the signs match so no final negate
    resetBar <= '0'; wait for 40 ns;
    resetBar <= '1';
    A <= "1101"; B <= "1110"; wait for 40 ns;
    for i in 1 to 9 loop tick(clock); end loop;
    assert S = "00000110" report "minus 3 times minus 2 should be 6" severity error;
    wait for 80 ns;

    -- -3 * 2 = -6. one flip, and the product gets negated at the end
    resetBar <= '0'; wait for 40 ns;
    resetBar <= '1';
    A <= "1101"; B <= "0010"; wait for 40 ns;
    for i in 1 to 9 loop tick(clock); end loop;
    assert S = "11111010" report "minus 3 times 2 should be minus 6" severity error;
    wait for 80 ns;

    -- the awkward one. -8 flips to itself, and read as a magnitude that is 8.
    -- 7 has three bits set, so three of the four passes add
    resetBar <= '0'; wait for 40 ns;
    resetBar <= '1';
    A <= "1000"; B <= "0111"; wait for 40 ns;
    for i in 1 to 11 loop tick(clock); end loop;
    assert S = "11001000" report "minus 8 times 7 should be minus 56" severity error;
    wait for 80 ns;

    report "all four pairs came out right" severity note;
    wait;
  end process;

end architecture sim;
