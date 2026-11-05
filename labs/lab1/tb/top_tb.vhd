library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end entity top_tb;

architecture sim of top_tb is
  signal GClock, GResetBar, Lft, Rgt : std_logic;
  signal display : std_logic_vector(7 downto 0);
begin

  dut : entity work.lightDisplay(struct)
    port map ( i_GClock    => GClock,
               i_GResetBar => GResetBar,
               i_Left      => Lft,
               i_Right     => Rgt,
               o_Display   => display );

  -- 100 MHz board oscillator, 10 ns period
  clockDriver : process
  begin
    GClock <= '0';  wait for 5 ns;
    GClock <= '1';  wait for 5 ns;
  end process;

  stimulus : process
  begin
    GResetBar <= '0';  Lft <= '1';  Rgt <= '1';
    wait for 100 ns;
    GResetBar <= '1';
    wait;
  end process;

end architecture sim;
