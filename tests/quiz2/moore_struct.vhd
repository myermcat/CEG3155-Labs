LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY fsm IS
  PORT (i_clk, i_resetb : IN STD_LOGIC);
    i_load : IN STD_LOGIC;
    i_w : IN STD_LOGIC;
    o_z : OUT STD_LOGIC));
END fsm;

ARCHITECTURE MooreS OF fsm IS

SIGNAL int_nY1, int_nY2: STD_LOGIC;
SIGNAL int_pY1, int_pY2: STD_LOGIC;
SIGNAL int_notpY1, int_notpY2: STD_LOGIC;
COMPONENT enARdFF_2
  PORT(
    i_resetBar : IN STD_LOGIC;
    i_d : IN STD_LOGIC;
    i_enable : IN STD_LOGIC;
    i_clock : IN STD_LOGIC;
    o_q, o_qBar : OUT STD_LOGIC);
END COMPONENT;

BEGIN
ff2: enARdFF_2
  PORT MAP (i_resetBar => i_resetb,
            i_d => int_nY2,
            i_enable => i_load,
            i_clock => i_clk,
            o_q => int_pY2,
            o_qBar => int_notpY2);
ff1: enARdFF_2
  PORT MAP (i_resetBar => i_resetb,
            i_d => int_nY1,
            i_enable => i_load,
            i_clock => i_clk,
            o_q => int_pY1,
            o_qBar => int_notpY1);
Int_nY2 <= i_w AND (int_pY1 OR int_pY2);
Int_nY1 <= i_w AND int_notpY2 AND int_notpY1;
o_z <= int_pY2;
end MooreS;