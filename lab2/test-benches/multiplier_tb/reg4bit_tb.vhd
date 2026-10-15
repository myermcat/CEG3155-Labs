-- register A. load a value, hold it with the load low, load another.

library ieee;
use ieee.std_logic_1164.all;

entity reg4bit_tb is
end entity reg4bit_tb;

architecture sim of reg4bit_tb is
  signal resetBar, load, clock : std_logic := '0';
  signal d, q : std_logic_vector(3 downto 0);
begin

  dut : entity work.reg4bit(rtl)
    port map ( i_resetBar => resetBar, i_load => load,
               i_clock => clock, i_Value => d, o_Value => q );

  stimulus : process
  begin
    resetBar <= '0'; load <= '0'; d <= "0000"; clock <= '0'; wait for 20 ns;
    resetBar <= '1'; wait for 20 ns;

    d <= "1011"; load <= '1'; wait for 20 ns;
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;  -- q = 1011

    d <= "0110"; load <= '0'; wait for 20 ns;
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;  -- holds 1011

    load <= '1'; wait for 20 ns;
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;  -- q = 0110

    resetBar <= '0'; wait for 20 ns;                             -- back to 0000
    wait;
  end process;

end architecture sim;
