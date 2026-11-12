-- loads a period, counts it down, and stops at zero instead of wrapping.
-- holding at zero is what lets the main green state wait there for a car.

library ieee;
use ieee.std_logic_1164.all;

entity countingBlock_tb is
end entity countingBlock_tb;

architecture sim of countingBlock_tb is
  signal clock, resetBar, reload, exp : std_logic := '0';
  signal sel : std_logic_vector(1 downto 0) := "00";
  signal mscMax, sscMax, yc, count : std_logic_vector(3 downto 0) := "0000";
begin

  dut : entity work.countingBlock(rtl)
    port map ( i_clock => clock, i_resetBar => resetBar, i_reload => reload,
               i_select => sel, i_mscMax => mscMax, i_sscMax => sscMax,
               i_yc => yc, o_exp => exp, o_count => count );

  stimulus : process
  begin
    mscMax <= "0011"; sscMax <= "0101"; yc <= "0010";
    resetBar <= '0'; clock <= '0'; wait for 20 ns;
    resetBar <= '1'; wait for 20 ns;

    -- select the main green period and load it
    sel <= "00"; reload <= '1'; wait for 20 ns;
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;   -- count = 3
    reload <= '0'; wait for 20 ns;

    -- 2, 1, 0, then it holds at zero with exp high
    for i in 1 to 5 loop
      clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;
    end loop;

    -- the side green period is longer, and a reload restarts it
    sel <= "10"; reload <= '1'; wait for 20 ns;
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;   -- count = 5
    reload <= '0'; wait for 20 ns;
    for i in 1 to 3 loop
      clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;
    end loop;

    -- the yellow period is the shortest of the three
    sel <= "01"; reload <= '1'; wait for 20 ns;
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;   -- count = 2
    reload <= '0'; wait for 20 ns;
    for i in 1 to 3 loop
      clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;
    end loop;
    wait;
  end process;

end architecture sim;
