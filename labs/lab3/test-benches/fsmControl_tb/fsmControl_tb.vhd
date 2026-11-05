LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fsmControl_tb IS
END fsmControl_tb;

ARCHITECTURE sim OF fsmControl_tb IS
    signal clock, resetBar, enable, sscs, i_exp : std_logic := '0';
    signal mstl, sstl, o_select : std_logic;
BEGIN

    -- device under test
    dut : entity fsmControl(rtl)
        port map (
            i_clock => clock,    
            i_resetBar => resetBar,
            i_enable => enable,
            i_sscs => sscs, 
            i_exp => i_exp,
            o_mstl => mstl,
            o_sstl => sstl,
            o_select => o_select
        );

    stimulus : process
    begin
        resetBar <= '0'; wait for 20 ns;
    
    end process;

END sim;
