-- the bonus adder on its own, so the waveform shows it computing the same
-- answers the ripple one does. same pairs as the four bit adder's testbench.

library ieee;
use ieee.std_logic_1164.all;

entity carryLookAdder_tb is
end entity carryLookAdder_tb;

architecture sim of carryLookAdder_tb is
  signal a, b, s : std_logic_vector(3 downto 0);
  signal cin, cout, overflow : std_logic := '0';
begin

  dut : entity work.carryLookAdder(rtl)
    port map ( a => a, b => b, cin => cin, s => s,
               overflow => overflow, cout => cout );

  stimulus : process
  begin
    -- plain adds
    a <= "0010"; b <= "0001"; cin <= '0'; wait for 20 ns;   -- 2 + 1 = 3
    a <= "0110"; b <= "0101"; wait for 20 ns;               -- 6 + 5, overflows
    a <= "1001"; b <= "0001"; wait for 20 ns;               -- -7 + 1 = -6
    a <= "0110"; b <= "0011"; wait for 20 ns;               -- 6 + 3, overflows

    -- with a carry in, which is how the subtract path uses it
    cin <= '1'; wait for 20 ns;
    a <= "0010"; b <= "1110"; wait for 20 ns;               -- 2 + (-2) + 1
    a <= "1111"; b <= "1111"; wait for 20 ns;
    a <= "0000"; b <= "1111"; wait for 20 ns;
    wait;
  end process;

end architecture sim;
