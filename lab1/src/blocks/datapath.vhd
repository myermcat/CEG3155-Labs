Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY datapath IS
  PORT(
    i_resetBar : IN  STD_LOGIC;
    i_clock    : IN  STD_LOGIC;
    i_tick     : IN  STD_LOGIC;
    i_loadA    : IN  STD_LOGIC;
    i_shiftA   : IN  STD_LOGIC;
    i_loadB    : IN  STD_LOGIC;
    i_shiftB   : IN  STD_LOGIC;
    i_selC     : IN  STD_LOGIC_VECTOR (1 downto 0);
    o_Display  : OUT STD_LOGIC_VECTOR (7 downto 0));
END datapath;

ARCHITECTURE struct OF datapath IS
  SIGNAL int_leftValue, int_rightValue : STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL int_bothValue                 : STD_LOGIC_VECTOR (7 downto 0); -- left or right
  CONSTANT blank : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
BEGIN

  leftMask: ENTITY work.LMASK(rtl)
    PORT MAP ( i_resetBar => i_resetBar,
               i_load     => i_loadA,
               i_shift    => i_shiftA,
               i_tick     => i_tick,
               i_clock    => i_clock,
               o_Value    => int_leftValue );

  rightMask: ENTITY work.RMASK(rtl)
    PORT MAP ( i_resetBar => i_resetBar,
               i_load     => i_loadB,
               i_shift    => i_shiftB,
               i_tick     => i_tick,
               i_clock    => i_clock,
               o_Value    => int_rightValue );

  int_bothValue <= int_leftValue or int_rightValue;

  outMux: ENTITY work.muxOut(rtl)
    PORT MAP ( i_zero  => int_leftValue,
               i_one   => int_rightValue,
               i_two   => int_bothValue,
               i_three => blank,
               i_sel   => i_selC,
               o_Value => o_Display );

END struct;