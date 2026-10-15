-- the three cases the TA asked for: positive by positive, negative by
-- negative, and one of each. the clock here stands in for the push button, so
-- each pair gets enough edges for the eleven or so states to run through.

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
    resetBar <= '0'; wait for 40 ns;
    resetBar <= '1'; wait for 40 ns;

    -- 3 * 2 = 6
    A <= "0011"; B <= "0010"; wait for 40 ns;
    for i in 1 to 15 loop tick(clock); end loop;

    -- -3 * -2 = 6. both flips happen, and the signs match so no final negate
    A <= "1101"; B <= "1110"; wait for 40 ns;
    for i in 1 to 15 loop tick(clock); end loop;

    -- -3 * 2 = -6. one flip, and the product gets negated at the end
    A <= "1101"; B <= "0010"; wait for 40 ns;
    for i in 1 to 15 loop tick(clock); end loop;

    -- the awkward one. -8 flips to itself, and read as a magnitude that is 8
    A <= "1000"; B <= "0111"; wait for 40 ns;   -- -8 * 7 = -56
    for i in 1 to 15 loop tick(clock); end loop;

    wait;
  end process;

end architecture sim;
