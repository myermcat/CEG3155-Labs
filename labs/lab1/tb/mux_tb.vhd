library ieee;
use ieee.std_logic_1164.all;

entity mux_tb is
end entity mux_tb;

architecture sim of mux_tb is
  signal i_sel : std_logic_vector(1 downto 0);
  signal o_Value: std_logic_vector(7 downto 0);
  signal i_zero      : std_logic_vector(7 downto 0) := "00000001";
  signal i_one      : std_logic_vector(7 downto 0) := "00000010";
  signal i_two      : std_logic_vector(7 downto 0) := "00000100";
  signal i_three      : std_logic_vector(7 downto 0) := "00001000";
begin
  dut : entity work.muxOut 
    port map (i_zero, i_one, i_two, i_three, i_sel, o_Value); -- order of how theyre declared in the entity, not architecture HERE!

  stimulus : process
  begin
   i_sel <= "00"; wait for 20 ns;
   i_sel <= "01"; wait for 20 ns;
   i_sel <= "10"; wait for 20 ns;
   i_sel <= "11"; wait for 20 ns;
    

    wait;
  end process;
end architecture sim;