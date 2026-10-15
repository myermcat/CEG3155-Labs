Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux IS
  PORT(
    i_zero, i_one : IN  STD_LOGIC_VECTOR (7 downto 0);
    i_sel         : IN  STD_LOGIC;
    o_Value       : OUT STD_LOGIC_VECTOR (7 downto 0));
END mux;

ARCHITECTURE rtl OF mux IS
BEGIN
  o_Value <= i_zero when i_sel = '0' else
             i_one;
END rtl;