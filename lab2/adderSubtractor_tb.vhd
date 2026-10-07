library ieee;
use ieee.std_logic_1164.all;

entity adderSubtractor_tb is
end entity adderSubtractor_tb;

architecture sim of adderSubtractor_tb is
  signal ain, bin, s_out: std_logic_vector (3 downto 0);
  signal cout: std_logic;
  signal overflow: std_logic; 
  signal subSelect: std_logic; 

begin
  dut : entity work.adderSubtractor 
    port map (ain, bin, s_out, cout, overflow, subSelect); -- order of how theyre declared in the entity, not architecture HERE!

  stimulus : process
  begin
    
    -- add
    ain <= "0010"; bin <= "0001"; subSelect <= '0'; wait for 20 ns;
    ain <= "0110"; bin <= "0101"; subSelect <= '0'; wait for 20 ns;
    ain <= "1001"; bin <= "0001"; subSelect <= '0'; wait for 20 ns;
    ain <= "0110"; bin <= "0011"; subSelect <= '0'; wait for 20 ns;

    -- subtract
    ain <= "0010"; bin <= "0001"; subSelect <= '1'; wait for 20 ns;
    ain <= "0110"; bin <= "0101"; subSelect <= '1'; wait for 20 ns;
    ain <= "0010"; bin <= "0001"; subSelect <= '1'; wait for 20 ns;
    ain <= "0110"; bin <= "0011"; subSelect <= '1'; wait for 20 ns;

    wait;
  end process;
end architecture sim;