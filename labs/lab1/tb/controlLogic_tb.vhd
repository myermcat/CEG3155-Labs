library ieee;
use ieee.std_logic_1164.all;

entity controlLogic_tb is
end entity controlLogic_tb;

architecture sim of controlLogic_tb is
  signal resetBar, clock, tick, Lft, Rgt : std_logic;
  signal loadA, shiftA, loadB, shiftB    : std_logic;
  signal selC                            : std_logic_vector(1 downto 0);
begin

  dut : entity work.controlLogic(struct)
    port map ( i_resetBar => resetBar,
               i_clock    => clock,
               i_tick     => tick,
               i_Left     => Lft,
               i_Right    => Rgt,
               o_loadA    => loadA,
               o_shiftA   => shiftA,
               o_loadB    => loadB,
               o_shiftB   => shiftB,
               o_selC     => selC );

  stimulus : process
  begin
    clock <= '0'; resetBar <= '0'; tick <= '0'; Lft <= '0'; Rgt <= '0';
    wait for 20 ns;                 -- reset holds the machine in s0

    resetBar <= '1'; tick <= '1';
    Lft <= '1'; Rgt <= '1';
    wait for 20 ns;
    clock <= '1';  wait for 20 ns;  -- leave s0, enter s1 (both)
    clock <= '0';  wait for 20 ns;

    Lft <= '1'; Rgt <= '0';
    wait for 20 ns;
    clock <= '1';  wait for 20 ns;  -- enter s2 (left only)
    clock <= '0';  wait for 20 ns;

    Lft <= '0'; Rgt <= '1';
    wait for 20 ns;
    clock <= '1';  wait for 20 ns;  -- enter s3 (right only)
    clock <= '0';  wait for 20 ns;

    Lft <= '0'; Rgt <= '0';
    wait for 20 ns;
    clock <= '1';  wait for 20 ns;  -- enter s4 (neither)
    clock <= '0';  wait for 20 ns;

    -- enable low: the machine must hold s4 across a clock edge
    tick <= '0';
    Lft <= '1'; Rgt <= '1';
    wait for 20 ns;
    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;

    -- enable back on: it should now move to s1
    tick <= '1';
    wait for 20 ns;
    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;

    wait;
  end process;
end architecture sim;
