library ieee;
use ieee.std_logic_1164.all;

entity fullAdder_tb is
end entity fullAdder_tb;

architecture sim of fullAdder_tb is
  signal ain: std_logic;
  signal bin: std_logic;
  signal cin: std_logic;
  signal cout: std_logic;
  signal si: std_logic;
  signal pi: std_logic;
  signal gi: std_logic;

begin
  dut : entity work.fullAdder 
    port map (ain, bin, cin, si, pi, gi, cout); -- order of how theyre declared in the entity, not architecture HERE!

  stimulus : process
  begin
    
    ain <= '0'; bin <= '0'; cin <= '0'; wait for 20 ns;
    ain <= '0'; bin <= '0'; cin <= '1'; wait for 20 ns;
    ain <= '0'; bin <= '1'; cin <= '0'; wait for 20 ns;
    ain <= '0'; bin <= '1'; cin <= '1'; wait for 20 ns;
    ain <= '1'; bin <= '0'; cin <= '0'; wait for 20 ns;
    ain <= '1'; bin <= '0'; cin <= '1'; wait for 20 ns;
    ain <= '1'; bin <= '1'; cin <= '0'; wait for 20 ns;
    ain <= '1'; bin <= '1'; cin <= '1'; wait for 20 ns;

    wait;
  end process;
end architecture sim;