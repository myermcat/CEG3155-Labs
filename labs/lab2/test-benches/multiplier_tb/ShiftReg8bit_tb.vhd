-- register S. the one with two loads and a shift chain across both halves.
-- load each half on its own, shift the whole eight bits, and hold.

library ieee;
use ieee.std_logic_1164.all;

entity ShiftReg8bit_tb is
end entity ShiftReg8bit_tb;

architecture sim of ShiftReg8bit_tb is
  signal resetBar, loadSlow, loadShigh, shift, clock : std_logic := '0';
  signal d, q : std_logic_vector(7 downto 0);

  procedure tick (signal clk : out std_logic) is
  begin
    clk <= '1'; wait for 20 ns; clk <= '0'; wait for 20 ns;
  end procedure;

begin

  dut : entity work.ShiftReg8bit(rtl)
    port map ( i_resetBar => resetBar, loadSlow => loadSlow,
               loadShigh => loadShigh, i_shift => shift,
               i_clock => clock, i_Value => d, o_Value => q );

  stimulus : process
  begin
    resetBar <= '0'; d <= "00000000"; clock <= '0'; wait for 20 ns;
    resetBar <= '1'; wait for 20 ns;

    -- low half only. the top four stay at 0
    d <= "11110110"; loadSlow <= '1'; wait for 20 ns;
    tick(clock);
    loadSlow <= '0'; wait for 20 ns;                      -- q = 00000110

    -- high half only. the bottom four keep what they had
    d <= "10110000"; loadShigh <= '1'; wait for 20 ns;
    tick(clock);
    loadShigh <= '0'; wait for 20 ns;                     -- q = 10110110

    -- shift right eight times. a zero comes in at the top each time and bit 4
    -- walks across into bit 3, which is the wire between the two halves
    shift <= '1'; wait for 20 ns;
    for i in 1 to 8 loop tick(clock); end loop;
    shift <= '0'; wait for 20 ns;                         -- q = 00000000

    -- both loads at once, which is what s3 and s4 do
    d <= "10100101"; loadSlow <= '1'; loadShigh <= '1'; wait for 20 ns;
    tick(clock);
    loadSlow <= '0'; loadShigh <= '0'; wait for 20 ns;    -- q = 10100101

    -- nothing asserted, so it holds
    tick(clock); tick(clock);
    wait;
  end process;

end architecture sim;
