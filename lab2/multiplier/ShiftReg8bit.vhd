Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ShiftReg8bit IS
  PORT( -- ports
    i_resetBar : in std_logic;
    loadSlow, loadShigh : IN  STD_LOGIC;
    i_shift: in std_logic;
    i_clock            : IN  STD_LOGIC;
    i_Value: in std_logic_vector (7 downto 0);
    o_Value            : OUT STD_LOGIC_VECTOR (7 downto 0));
END ShiftReg8bit;

ARCHITECTURE rtl OF ShiftReg8bit IS -- internal signals
  SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL b : STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL enHigh, enLow : std_logic;

  COMPONENT dff
    PORT( i_resetBar, i_d, i_enable, i_clock : IN STD_LOGIC;
          o_q, o_qBar : OUT STD_LOGIC);
  END COMPONENT;
BEGIN

enHigh <= loadShigh or i_shift;
enLow <= loadSlow or i_shift;

b(7) <= (i_Value(7) and loadShigh); -- for rotation
b(6) <= (i_Value(6) and loadShigh) or (i_shift and int_Value(7));
b(5) <= (i_Value(5) and loadShigh) or (i_shift and int_Value(6));
b(4) <= (i_Value(4) and loadShigh) or (i_shift and int_Value(5));

b(3) <= (i_Value(3) and loadSlow) or (i_shift and int_Value(4));
b(2) <= (i_Value(2) and loadSlow) or (i_shift and int_Value(3)); -- i_Value
b(1) <= (i_Value(1) and loadSlow) or (i_shift and int_Value(2));
b(0) <= (i_Value(0) and loadSlow) or (i_shift and int_Value(1)); 

  msb: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(7), -- current bit (7)
              i_enable => enHigh, i_clock => i_clock,
              o_q => int_Value(7), o_qBar => int_notValue(7));

  bit6: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(6),
              i_enable => enHigh, i_clock => i_clock,
              o_q => int_Value(6), o_qBar => int_notValue(6));

  bit5: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(5),
              i_enable => enHigh, i_clock => i_clock,
              o_q => int_Value(5), o_qBar => int_notValue(5));

  bit4: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(4),
              i_enable => enHigh, i_clock => i_clock,
              o_q => int_Value(4), o_qBar => int_notValue(4));

  bit3: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(3),
              i_enable => enLow, i_clock => i_clock,
              o_q => int_Value(3), o_qBar => int_notValue(3));

  bit2: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(2),
              i_enable => enLow, i_clock => i_clock,
              o_q => int_Value(2), o_qBar => int_notValue(2));

  bit1: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(1),
              i_enable => enLow, i_clock => i_clock,
              o_q => int_Value(1), o_qBar => int_notValue(1));

  lsb: dff
    PORT MAP (i_resetBar => i_resetBar, i_d => b(0),
              i_enable => enLow, i_clock => i_clock,
              o_q => int_Value(0), o_qBar => int_notValue(0));

  -- Output Driver
  o_Value <= int_Value;
END rtl;