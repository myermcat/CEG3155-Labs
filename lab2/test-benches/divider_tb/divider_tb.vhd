-- the three cases the TA asked for, plus dividing by zero.
-- quotient comes out in S(3..0) and the remainder in S(7..4).

library ieee;
use ieee.std_logic_1164.all;

entity divider_tb is
end entity divider_tb;

architecture sim of divider_tb is
  signal clock, resetBar, divByZero : std_logic := '0';
  signal A, B : std_logic_vector(3 downto 0) := "0000";
  signal S : std_logic_vector(7 downto 0);

  procedure tick (signal clk : out std_logic) is
  begin
    clk <= '1'; wait for 20 ns; clk <= '0'; wait for 20 ns;
  end procedure;

begin

  dut : entity work.divider(stub)
    port map ( i_clock => clock, i_resetBar => resetBar,
               i_A => A, i_B => B, o_S => S, o_divideByZero => divByZero );

  stimulus : process
  begin
    resetBar <= '0'; wait for 40 ns;
    resetBar <= '1'; wait for 40 ns;

    -- 6 / 2 = 3 remainder 0
    A <= "0110"; B <= "0010"; wait for 40 ns;
    for i in 1 to 20 loop tick(clock); end loop;

    -- -6 / -2 = 3 remainder 0
    A <= "1010"; B <= "1110"; wait for 40 ns;
    for i in 1 to 20 loop tick(clock); end loop;

    -- -7 / 2 = -3 remainder -1. the remainder takes the dividend's sign
    A <= "1001"; B <= "0010"; wait for 40 ns;
    for i in 1 to 20 loop tick(clock); end loop;

    -- divide by zero, so the flag should come up
    A <= "0101"; B <= "0000"; wait for 40 ns;
    for i in 1 to 20 loop tick(clock); end loop;

    wait;
  end process;

end architecture sim;
