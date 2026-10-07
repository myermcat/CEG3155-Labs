Library ieee;
USE ieee.std_logic_1164.ALL;

entity registers_tb is
end entity registers_tb;

architecture test of registers_tb is
    signal resetBar, load, shift, tick, clock : std_logic; -- in
    signal leftOut, rightOut : std_logic_vector(7 downto 0); -- out, separate for lmask and rmask
begin
  left: entity work.LMASK(rtl)
    port map ( resetBar, load, shift, tick, clock, leftOut); -- positional, no arrows

  rigth: entity work.RMASK(rtl)
    port map ( resetBar, load, shift, tick, clock, rightOut);

  stimulus: process is
  
  begin
    -- everything driven at time zero
    clock <= '0'; resetBar <= '0'; load <= '0'; shift <= '0'; tick <= '0';
    wait for 20 ns;

    resetBar <= '1'; load <= '1'; tick <= '1';  wait for 20 ns;
    clock <= '1';  wait for 20 ns;   -- this edge loads the constant
    clock <= '0';  wait for 20 ns;

    load <= '0'; shift <= '1';       -- tick stays '1', nothing else changes
    -- eight rising edges, eight shifts
    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;
    
    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;

    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;

    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;

    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;

    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;

    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;

    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;

    -- hold test: clock keeps running, enable drops
    tick <= '0';
    clock <= '1';  wait for 20 ns;
    clock <= '0';  wait for 20 ns;

    wait;
  end process stimulus;
end architecture test;
