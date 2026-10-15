Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter3bit IS
  PORT(
    i_resetBar : IN  STD_LOGIC;
    i_load     : IN  STD_LOGIC;   -- loads "100", the four passes
    i_decr     : IN  STD_LOGIC;   -- counts down by one
    i_clock    : IN  STD_LOGIC;
    o_Value    : OUT STD_LOGIC_VECTOR(2 downto 0));
END counter3bit;

ARCHITECTURE rtl OF counter3bit IS -- internal signals
  SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(2 downto 0);
  SIGNAL b  : STD_LOGIC_VECTOR(2 downto 0);
  SIGNAL en : STD_LOGIC;

  COMPONENT dff
    PORT( i_resetBar, i_d, i_enable, i_clock : IN STD_LOGIC;
          o_q, o_qBar : OUT STD_LOGIC);
  END COMPONENT;
BEGIN

en <= i_load or i_decr;

-- counting down, a bit flips when every bit under it is already zero.
-- the constant we load is "100", so only bit 2 takes a one from the load.
b(2) <= i_load or (i_decr and (int_Value(2) xor (int_notValue(1) and int_notValue(0))));
b(1) <= i_decr and (int_Value(1) xor int_notValue(0));
b(0) <= i_decr and int_notValue(0);

  msb: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(2),
              i_enable => en, i_clock => i_clock,
              o_q => int_Value(2), o_qBar => int_notValue(2));

  ssb: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(1),
              i_enable => en, i_clock => i_clock,
              o_q => int_Value(1), o_qBar => int_notValue(1));

  lsb: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(0),
              i_enable => en, i_clock => i_clock,
              o_q => int_Value(0), o_qBar => int_notValue(0));

  -- Output Driver
  o_Value <= int_Value;
END rtl;
