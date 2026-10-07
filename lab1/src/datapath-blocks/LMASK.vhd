Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY LMASK IS
  PORT( -- ports
    i_resetBar, i_load : IN  STD_LOGIC;
    i_shift, i_tick    : IN  STD_LOGIC;
    i_clock            : IN  STD_LOGIC;
    o_Value            : OUT STD_LOGIC_VECTOR (7 downto 0));
END LMASK;

ARCHITECTURE rtl OF LMASK IS -- internal signals
  SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL a : STD_LOGIC; -- i_enable for the whole register
  SIGNAL b : STD_LOGIC_VECTOR (7 downto 0); -- i_value per ff
  CONSTANT i_const : STD_LOGIC_VECTOR (7 downto 0) := "00000001";

  COMPONENT dff
    PORT( i_resetBar, i_d, i_enable, i_clock : IN STD_LOGIC;
          o_q, o_qBar : OUT STD_LOGIC);
  END COMPONENT;
BEGIN
a <= i_tick and (i_load or i_shift); -- i_enable

b(7) <= (i_const(7) and i_load) or (i_shift and int_Value(6));
b(6) <= (i_const(6) and i_load) or (i_shift and int_Value(5));
b(5) <= (i_const(5) and i_load) or (i_shift and int_Value(4));
b(4) <= (i_const(4) and i_load) or (i_shift and int_Value(3));
b(3) <= (i_const(3) and i_load) or (i_shift and int_Value(2));
b(2) <= (i_const(2) and i_load) or (i_shift and int_Value(1)); -- i_Value
b(1) <= (i_const(1) and i_load) or (i_shift and int_Value(0));
b(0) <= (i_const(0) and i_load) or (i_shift and int_Value(7)); -- for rotation

  msb: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(7), -- current bit (7)
              i_enable => a, i_clock => i_clock,
              o_q => int_Value(7), o_qBar => int_notValue(7));

  bit6: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(6),
              i_enable => a, i_clock => i_clock,
              o_q => int_Value(6), o_qBar => int_notValue(6));

  bit5: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(5),
              i_enable => a, i_clock => i_clock,
              o_q => int_Value(5), o_qBar => int_notValue(5));

  bit4: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(4),
              i_enable => a, i_clock => i_clock,
              o_q => int_Value(4), o_qBar => int_notValue(4));

  bit3: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(3),
              i_enable => a, i_clock => i_clock,
              o_q => int_Value(3), o_qBar => int_notValue(3));

  bit2: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(2),
              i_enable => a, i_clock => i_clock,
              o_q => int_Value(2), o_qBar => int_notValue(2));

  bit1: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(1),
              i_enable => a, i_clock => i_clock,
              o_q => int_Value(1), o_qBar => int_notValue(1));

  lsb: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(0),
              i_enable => a, i_clock => i_clock,
              o_q => int_Value(0), o_qBar => int_notValue(0));

  -- Output Driver
  o_Value <= int_Value;
END rtl;