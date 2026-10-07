-- Testbench for dff, the enabled D flip flop with asynchronous reset.
library ieee;
use ieee.std_logic_1164.all;

entity dff_tb is
end entity dff_tb;

architecture sim of dff_tb is
  signal clk    : std_logic := '0';
  signal reset  : std_logic := '0';
  signal enable : std_logic := '1';
  signal d      : std_logic := '0';
  signal q      : std_logic;
  signal qBar   : std_logic;
begin
  dut : entity work.dff
    port map (i_clock => clk, i_resetBar => reset, i_enable => enable, i_d => d, o_q => q, o_qBar => qBar);

  clk <= not clk after 5 ns;   -- 100 MHz, same as the Nexys A7 oscillator

  stimulus : process
  begin
    wait for 20 ns;  reset <= '1';
    wait for 20 ns;  d <= '1';
    wait for 20 ns;
    assert q = '1' report "FAIL: q did not follow d" severity failure;
    d <= '0';
    wait for 20 ns;
    assert q = '0' report "FAIL: q did not clear" severity failure;
    
    wait for 20 ns;
    d <= '0';
    wait for 20 ns; enable <= '0';
    wait for 20 ns;  d <= '0';
    wait for 20 ns;
    d <= '1';
    wait for 20 ns;
    

    wait;
  end process;
end architecture sim;
