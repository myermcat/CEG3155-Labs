library ieee;
use ieee.std_logic_1164.all;

entity adderSub8bit_tb is
end entity adderSub8bit_tb;

architecture sim of adderSub8bit_tb is
  signal ain, bin, s_out: std_logic_vector (7 downto 0);
  signal cout: std_logic;
  signal overflow: std_logic; 
  signal subSelect: std_logic; 

begin
  dut : entity work.adderSub8bit 
    port map (ain, bin, s_out, cout, overflow, subSelect); -- order of how theyre declared in the entity, not architecture HERE!

  stimulus : process
  begin
    
    -- add
    ain <= "00000010"; bin <= "00000001"; subSelect <= '0'; wait for 20 ns;
    ain <= "01100100"; bin <= "00011011"; subSelect <= '0'; wait for 20 ns;
    ain <= "01100100"; bin <= "00011100"; subSelect <= '0'; wait for 20 ns;
    ain <= "11111001"; bin <= "00000001"; subSelect <= '0'; wait for 20 ns;

    -- subtract
    ain <= "00000010"; bin <= "00000001"; subSelect <= '1'; wait for 20 ns;
    ain <= "00000101"; bin <= "00001001"; subSelect <= '1'; wait for 20 ns;
    ain <= "10000000"; bin <= "00000001"; subSelect <= '1'; wait for 20 ns;
    ain <= "11111110"; bin <= "11111110"; subSelect <= '1'; wait for 20 ns;
    ain <= "00000000"; bin <= "00000000"; subSelect <= '1'; wait for 20 ns;

    wait;
  end process;
end architecture sim;