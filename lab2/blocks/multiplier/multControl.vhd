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
            i_enable => ??,
            i_clock => i_clock,
            o_q => int_s(0),
            o_qBar => open );