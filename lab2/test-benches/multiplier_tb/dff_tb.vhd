-- the flip flop everything else is built from.
-- checks the three things it has to do: clear on reset whatever the clock is
-- doing, capture on a rising edge when enabled, and hold when it is not.

library ieee;
use ieee.std_logic_1164.all;

entity dff_tb is
end entity dff_tb;

architecture sim of dff_tb is
  signal resetBar, d, enable, clock, q, qBar : std_logic := '0';
begin

  dut : entity work.dff(rtl)
    port map ( i_resetBar => resetBar, i_d => d, i_enable => enable,
               i_clock => clock, o_q => q, o_qBar => qBar );

  stimulus : process
  begin
    resetBar <= '0'; d <= '1'; enable <= '1'; clock <= '0'; wait for 20 ns;
    clock <= '1'; wait for 20 ns;   -- reset wins over the edge, q stays 0
    clock <= '0'; wait for 20 ns;

    resetBar <= '1'; wait for 20 ns;
    clock <= '1'; wait for 20 ns;   -- now it captures the 1
    clock <= '0'; wait for 20 ns;

    d <= '0'; wait for 20 ns;
    clock <= '1'; wait for 20 ns;   -- and the 0
    clock <= '0'; wait for 20 ns;

    d <= '1'; enable <= '0'; wait for 20 ns;
    clock <= '1'; wait for 20 ns;   -- enable low, so it holds at 0
    clock <= '0'; wait for 20 ns;

    resetBar <= '0'; wait for 20 ns; -- async, no edge needed
    wait;
  end process;

end architecture sim;
