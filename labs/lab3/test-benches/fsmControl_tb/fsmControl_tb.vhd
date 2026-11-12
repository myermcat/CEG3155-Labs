-- the four states in order, and the case the whole design turns on: the count
-- finishes with no car, the machine holds in the main green, and the car then
-- moves it on the next edge with no extra wait.

library ieee;
use ieee.std_logic_1164.all;

entity fsmControl_tb is
end entity fsmControl_tb;

architecture sim of fsmControl_tb is
  signal clock, resetBar, enable, sscs, exp : std_logic := '0';
  signal mstl, sstl : std_logic_vector(2 downto 0);
  signal sel : std_logic_vector(1 downto 0);
begin

  dut : entity work.fsmControl(rtl)
    port map ( i_clock => clock, i_resetBar => resetBar, i_enable => enable,
               i_sscs => sscs, i_exp => exp,
               o_mstl => mstl, o_sstl => sstl, o_select => sel );

  stimulus : process
  begin
    resetBar <= '0'; enable <= '0'; sscs <= '0'; exp <= '0'; clock <= '0';
    wait for 20 ns;
    resetBar <= '1'; enable <= '1'; wait for 20 ns;   -- s0, main green

    -- nothing has expired, so the machine holds
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;   -- s0

    -- the count runs out with no car, and it still holds
    exp <= '1'; wait for 20 ns;
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;   -- s0
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;   -- s0

    -- the car arrives late, so the light changes on the next edge
    sscs <= '1'; wait for 20 ns;
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;   -- s1, main yellow

    -- the yellow is still running
    sscs <= '0'; exp <= '0'; wait for 20 ns;
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;   -- s1

    -- the rest of the ring, one period each
    exp <= '1'; wait for 20 ns;
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;   -- s2, side green
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;   -- s3, side yellow
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;   -- s0, main green

    -- a car already waiting when the main green comes back, so it leaves at once
    sscs <= '1'; wait for 20 ns;
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;   -- s1
    wait;
  end process;

end architecture sim;
