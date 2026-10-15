library ieee;
USE ieee.std_logic_1164.ALL;

entity multControl is
    port(
        i_resetBar : in std_logic;
        i_clock : in std_logic;


    )
end multControl;

architecture struct of multControl is
    signal int_s : std_logic_vector(6 downto 0); -- one hot state
    signal int_d : std_logic_vector(6 downto 0); -- their d inputs

    -- equations how to get to each state
    int_d(0) <= 
    int_d(1) <=
    int_d(2) <=
    int_d(3) <=
    int_d(4) <=
    int_d(5) <=
    int_d(6) <=

    -- 5 state flip flops, one per state

    state0: entity work.dff(rtl)
        port map(
            i_resetBar => i_resetBar,
            i_d => int_d(0),
            i_enable => '1',
            i_clock => i_clock,
            o_q => int_s(0),
            o_qBar => open );

    state1: entity work.dff(rtl)
        port map(
            i_resetBar => i_resetBar,
            i_d => int_d(1),
            i_enable => '1',
            i_clock => i_clock,
            o_q => int_s(0),
            o_qBar => open );

    flipA: entity work.dff(rtl)
        port map(
            i_resetBar => i_resetBar,
            i_d => int_d(2),
            i_enable => '1',
            i_clock => i_clock,
            o_q => int_s(0),
            o_qBar => open );

    flipB: entity work.dff(rtl)
        port map(
            i_resetBar => i_resetBar,
            i_d => int_d(3),
            i_enable => '1',
            i_clock => i_clock,
            o_q => int_s(0),
            o_qBar => open );

    s2: entity work.dff(rtl)
        port map(
            i_resetBar => i_resetBar,
            i_d => int_d(4),
            i_enable => '1',
            i_clock => i_clock,
            o_q => int_s(0),
            o_qBar => open );

    s3: entity work.dff(rtl)
        port map(
            i_resetBar => i_resetBar,
            i_d => int_d(5),
            i_enable => '1',
            i_clock => i_clock,
            o_q => int_s(0),
            o_qBar => open );

    s4: entity work.dff(rtl)
        port map(
            i_resetBar => i_resetBar,
            i_d => int_d(6),
            i_enable => '1',
            i_clock => i_clock,
            o_q => int_s(0),
            o_qBar => open );


-- output decode
o_loadSlow = 
o_loadShigh = 
o_selSlow = 
o_selShigh = 
o_subSel = 
o_selAddY = 
o_loadA = int_s(0)

o_selA = int_s(0);
o_loadCount = int_s(0);
o_resetAxorB = int_s(0);
o_loadAxorB = int_s(1);
o_selAddX = int_s(4);
o_shiftSright = int_s(5);
o_decrCount = int_s(5);
 

end struct;