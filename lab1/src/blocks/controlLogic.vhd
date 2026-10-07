Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controlLogic IS
  PORT(
    i_resetBar : IN  STD_LOGIC;
    i_clock    : IN  STD_LOGIC;
    i_tick     : IN  STD_LOGIC;
    i_Left     : IN  STD_LOGIC;
    i_Right    : IN  STD_LOGIC;
    o_loadA    : OUT STD_LOGIC;
    o_shiftA   : OUT STD_LOGIC;
    o_loadB    : OUT STD_LOGIC;
    o_shiftB   : OUT STD_LOGIC;
    o_selC     : OUT STD_LOGIC_VECTOR (1 downto 0));
END controlLogic;

ARCHITECTURE struct OF controlLogic IS
  SIGNAL int_s : STD_LOGIC_VECTOR (4 downto 0);   -- the one hot state
  SIGNAL int_d : STD_LOGIC_VECTOR (4 downto 0);   -- their D inputs
BEGIN

  -- transition equations, read off the AND gates on the control logic drawing
  int_d(0) <= '0';                              -- s0 is entered only by reset
  int_d(1) <= i_Left and i_Right;               -- both
  int_d(2) <= i_Left and not(i_Right);          -- left only
  int_d(3) <= not(i_Left) and i_Right;          -- right only
  int_d(4) <= not(i_Left) and not(i_Right);     -- neither

  -- the five state flip flops, one per state
  state0: ENTITY work.dffset(rtl)
    PORT MAP ( i_resetBar => i_resetBar,
               i_d        => int_d(0),
               i_enable   => i_tick,
               i_clock    => i_clock,
               o_q        => int_s(0),
               o_qBar     => OPEN );

  state1: ENTITY work.dff(rtl)
    PORT MAP ( i_resetBar => i_resetBar,
               i_d        => int_d(1),
               i_enable   => i_tick,
               i_clock    => i_clock,
               o_q        => int_s(1),
               o_qBar     => OPEN );

  state2: ENTITY work.dff(rtl)
    PORT MAP ( i_resetBar => i_resetBar,
               i_d        => int_d(2),
               i_enable   => i_tick,
               i_clock    => i_clock,
               o_q        => int_s(2),
               o_qBar     => OPEN );

  state3: ENTITY work.dff(rtl)
    PORT MAP ( i_resetBar => i_resetBar,
               i_d        => int_d(3),
               i_enable   => i_tick,
               i_clock    => i_clock,
               o_q        => int_s(3),
               o_qBar     => OPEN );

  state4: ENTITY work.dff(rtl)
    PORT MAP ( i_resetBar => i_resetBar,
               i_d        => int_d(4),
               i_enable   => i_tick,
               i_clock    => i_clock,
               o_q        => int_s(4),
               o_qBar     => OPEN );

  -- output decode, read off the OR gates on the drawing
  o_loadA   <= int_s(0);
  o_loadB   <= int_s(0);
  o_shiftA  <= int_s(1) or int_s(2);
  o_shiftB  <= int_s(1) or int_s(3);
  o_selC(0) <= int_s(0) or int_s(3) or int_s(4);
  o_selC(1) <= int_s(0) or int_s(1) or int_s(4);

END struct;
