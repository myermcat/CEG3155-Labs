-- the digital filter on the keyboard clock. eight flip flops sample the raw
-- clock on every global clock edge, one AND fires when all eight read one and
-- another when all eight read zero, and those set and reset a latch.
-- so the filtered clock only moves after the raw one has held a level for
-- eighty nanoseconds, and a reflection shorter than that never gets through.
--
-- figure 13 draws the latch as a gate loop. we register it off the global clock
-- instead, so there is no combinational loop and no waiver to ask vivado for.
-- the cost is that the filtered clock moves one global period after the eight
-- samples agree.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY digitalFilter IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;   -- globalClock, the 100 MHz global clock
    i_resetBar : IN  STD_LOGIC;
    i_raw      : IN  STD_LOGIC;   -- keyboardClock, straight off the pin
    o_filtered : OUT STD_LOGIC);  -- the clean clock the rest of the design runs on
END digitalFilter;

ARCHITECTURE rtl OF digitalFilter IS
signal and1, and0, d, d_prev : std_logic;
signal shR_out : std_logic_vector(7 downto 0);

component dff
  port(
    i_resetBar, i_d, i_enable, i_clock : in std_logic;
    o_q, o_qBar : out std_logic);
end component;

component shiftRegister
  port(
    i_clock, i_resetBar, i_shift, i_serial : in std_logic;
    o_value : out std_logic_vector(7 downto 0)
  );
end component;

BEGIN

shR: shiftRegister
  port map(
    i_clock => i_clock,
    i_resetBar => i_resetBar,
    i_shift => '1',
    i_serial => i_raw,
    o_value => shR_out
  );

and1 <= shR_out(7) and shR_out(6) and shR_out(5) and shR_out(4)
    and shR_out(3) and shR_out(2) and shR_out(1) and shR_out(0); -- s

and0 <= not(shR_out(7) or shR_out(6) or shR_out(5) or shR_out(4)
         or shR_out(3) or shR_out(2) or shR_out(1) or shR_out(0)); -- r

d <= (not(and1) and not(and0) and d_prev) or and1;

sr_ff: dff
  port map(
    i_resetBar => i_resetBar,
    i_d => d,
    i_enable => '1',
    i_clock => i_clock,
    o_q => d_prev,
    o_qBar => open
  );

  o_filtered <= d_prev;

END rtl;
