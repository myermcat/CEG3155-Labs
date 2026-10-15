-- the counter that gives the loop its four passes.
-- load 4, count down to 0, then check it wraps and that it holds when neither
-- load nor decrement is on.

library ieee;
use ieee.std_logic_1164.all;

entity counter3bit_tb is
end entity counter3bit_tb;

architecture sim of counter3bit_tb is
  signal resetBar, load, decr, clock : std_logic := '0';
  signal q : std_logic_vector(2 downto 0);
begin

  dut : entity work.counter3bit(rtl)
    port map ( i_resetBar => resetBar, i_load => load, i_decr => decr,
               i_clock => clock, o_Value => q );

  stimulus : process
  begin
    resetBar <= '0'; load <= '0'; decr <= '0'; clock <= '0'; wait for 20 ns;
    resetBar <= '1'; wait for 20 ns;

    load <= '1'; wait for 20 ns;
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;  -- q = 100

    load <= '0'; decr <= '1'; wait for 20 ns;
    for i in 1 to 5 loop                        -- 3, 2, 1, 0, then wraps to 7
      clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;
    end loop;

    decr <= '0'; wait for 20 ns;
    clock <= '1'; wait for 20 ns; clock <= '0'; wait for 20 ns;  -- holds at 7
    wait;
  end process;

end architecture sim;
