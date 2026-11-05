library ieee;
use ieee.std_logic_1164.all;

entity datapath_tb is
end entity datapath_tb;

architecture sim of datapath_tb is
  signal resetBar, clock, tick            : std_logic;
  signal loadA, shiftA, loadB, shiftB     : std_logic;
  signal selC                             : std_logic_vector(1 downto 0);
  signal display                          : std_logic_vector(7 downto 0);
begin

  dut : entity work.datapath(struct)
    port map ( i_resetBar => resetBar,
               i_clock    => clock,
               i_tick     => tick,
               i_loadA    => loadA,
               i_shiftA   => shiftA,
               i_loadB    => loadB,
               i_shiftB   => shiftB,
               i_selC     => selC,
               o_Display  => display );

  stimulus : process
  begin
    -- every input driven at time zero
    clock <= '0'; resetBar <= '0'; tick <= '0';
    loadA <= '0'; shiftA <= '0'; loadB <= '0'; shiftB <= '0';
    selC  <= "00";
    wait for 20 ns;

    -- release reset, load both masks with their constants
    resetBar <= '1'; tick <= '1'; loadA <= '1'; loadB <= '1';
    wait for 20 ns;
    clock <= '1';  wait for 20 ns;   -- load edge
    clock <= '0';  wait for 20 ns;
    loadA <= '0'; loadB <= '0';
    wait for 20 ns;

    -- selC walks the four cases with the masks held still
    -- 00 left, 01 right, 10 both, 11 blank
    selC <= "00";  wait for 20 ns;
    selC <= "01";  wait for 20 ns;
    selC <= "10";  wait for 20 ns;
    selC <= "11";  wait for 20 ns;

    -- both shifting, display showing the OR, four steps
    selC <= "10";
    shiftA <= '1'; shiftB <= '1';
    wait for 20 ns;
    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;
    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;
    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;
    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;

    -- left only: selC = 00, B frozen
    shiftB <= '0'; selC <= "00";
    wait for 20 ns;
    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;

    -- neither: display blank, nothing moves
    shiftA <= '0'; selC <= "11";
    wait for 20 ns;
    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;

    wait;
  end process;
end architecture sim;
