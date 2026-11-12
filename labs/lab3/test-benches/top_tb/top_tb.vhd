-- the whole controller. the clock divider is left as it is, so a period of
-- four ticks takes a long time in simulation. to keep the run short we drive
-- the smallest periods the switches allow and watch the lights change.
--
-- the scenarios the lab asks for: main green with no car, a car arriving
-- before the green time runs out, a car arriving after it, and the side street
-- yielding on its own.

library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end entity top_tb;

architecture sim of top_tb is
  signal clock, resetBar, loadFsm, capteur : std_logic := '0';
  signal mscMax, sscMax : std_logic_vector(3 downto 0) := "0000";
  signal mstl, sstl : std_logic_vector(2 downto 0);
  signal seg : std_logic_vector(6 downto 0);
  signal an  : std_logic_vector(7 downto 0);
begin

  dut : entity work.trafficLightController(struct)
    port map ( CLOCK => clock, RESETBAR => resetBar, LOAD_FSM => loadFsm,
               MSC_MAX => mscMax, SSC_MAX => sscMax, CAPTEUR => capteur,
               MSTL => mstl, SSTL => sstl, SEG => seg, AN => an );

  -- the board's 100 MHz oscillator
  clock <= not clock after 5 ns;

  stimulus : process
  begin
    resetBar <= '0'; loadFsm <= '0'; capteur <= '0';
    mscMax <= "0001"; sscMax <= "0001";
    wait for 200 ns;
    resetBar <= '1'; loadFsm <= '1';

    -- main green, no car on the side street, so it holds
    wait for 40 us;

    -- a car arrives, and the ring runs: main yellow, side green, side yellow
    capteur <= '1';
    wait for 120 us;

    -- the car has gone, so the main street keeps its green
    capteur <= '0';
    wait for 60 us;

    -- a car arrives again, and the ring runs a second time
    capteur <= '1';
    wait for 120 us;

    wait;
  end process;

end architecture sim;
