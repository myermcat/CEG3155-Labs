Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY muxOut IS
  PORT(
    i_zero, i_one, i_two, i_three : IN  STD_LOGIC_VECTOR (7 downto 0);
    i_sel         : IN  STD_LOGIC_VECTOR (1 downto 0);
    o_Value       : OUT STD_LOGIC_VECTOR (7 downto 0));
END muxOut;

ARCHITECTURE rtl OF muxOut IS
BEGIN
  o_Value <= i_zero when i_sel = "00" else
             i_one when i_sel = "01" else
             i_two when i_sel = "10" else
             i_three;
END rtl;