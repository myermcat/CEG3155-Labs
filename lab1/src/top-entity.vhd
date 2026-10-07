Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY lightDisplay IS
  PORT(
    i_GClock   : IN  STD_LOGIC;                       -- 100 MHz board oscillator
    i_GResetBar: IN  STD_LOGIC;                       -- active low global reset
    i_Left     : IN  STD_LOGIC;                       -- switch
    i_Right    : IN  STD_LOGIC;                       -- switch
    o_Display  : OUT STD_LOGIC_VECTOR (7 downto 0));  -- the eight LEDs
END lightDisplay;

ARCHITECTURE struct OF lightDisplay IS
  SIGNAL int_slowClock : STD_LOGIC;                   -- 1 Hz square wave from clk_div
  SIGNAL int_previous  : STD_LOGIC;                   -- its value one clock ago
  SIGNAL int_tick      : STD_LOGIC;                   -- one cycle enable pulse
  SIGNAL int_loadA, int_shiftA : STD_LOGIC;
  SIGNAL int_loadB, int_shiftB : STD_LOGIC;
  SIGNAL int_selC : STD_LOGIC_VECTOR (1 downto 0);
BEGIN

  -- the divider provided with the course. Only its slowest output is used,
  -- the rest are left unconnected.
  divider: ENTITY work.clockDivider(a)
    PORT MAP ( clock_25Mhz  => i_GClock,
               clock_1MHz   => OPEN,
               clock_100KHz => OPEN,
               clock_10KHz  => OPEN,
               clock_1KHz   => OPEN,
               clock_100Hz  => OPEN,
               clock_10Hz   => OPEN,
               clock_1Hz    => int_slowClock );

  -- edge detector. int_previous holds the slow clock as it was one 100 MHz
  -- cycle ago, so int_tick is high for exactly one cycle on each rising edge
  -- of the slow clock. Every register below runs on the free standing 100 MHz
  -- clock and advances only on those cycles, which is the clock enable
  -- technique the laboratory requires.
  history: ENTITY work.dff(rtl)
    PORT MAP ( i_resetBar => i_GResetBar,
               i_d        => int_slowClock,
               i_enable   => '1',
               i_clock    => i_GClock,
               o_q        => int_previous,
               o_qBar     => OPEN );

  int_tick <= int_slowClock and not(int_previous);

  control: ENTITY work.controlLogic(struct)
    PORT MAP ( i_resetBar => i_GResetBar,
               i_clock    => i_GClock,
               i_tick     => int_tick,
               i_Left     => i_Left,
               i_Right    => i_Right,
               o_loadA    => int_loadA,
               o_shiftA   => int_shiftA,
               o_loadB    => int_loadB,
               o_shiftB   => int_shiftB,
               o_selC     => int_selC );

  path: ENTITY work.datapath(struct)
    PORT MAP ( i_resetBar => i_GResetBar,
               i_clock    => i_GClock,
               i_tick     => int_tick,
               i_loadA    => int_loadA,
               i_shiftA   => int_shiftA,
               i_loadB    => int_loadB,
               i_shiftB   => int_shiftB,
               i_selC     => int_selC,
               o_Display  => o_Display );

END struct;
