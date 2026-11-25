LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

Entity example is 
    port (
        d, a, b: in std_logic;
        q2 : out std_logic;
        global_resetb, global_clk: in std_logic;
    );
end example;

Architecture struct of example is
    signal q1, i1, i2: std_logic;
    
component arDFF -- dff
    port (
        i_resetBar: in std_logic; 
        i_d: in std_logic; 
        i_clock: in std_logic;
        o_q, o_qBar: out std_logic);
end component; 

component and2 -- and gate
    port (i_a, i_b: in std_logic; 
            o_z: out std_logic);
end component;

begin

    dff1 : arDFF port map (i_resetBar => global_resetb, i_d => d, i_clock => global_clk,  o_q => q1,  o_qBar => not(q1));  
    dff2 : arDFF port map (i_resetBar => global_resetb, i_d => i1, i_clock => global_clk,  o_q => i2,  o_qBar => not(i2));
    and1 : and2 port map (i_a => q1, i_b => a, o_z =>i1);
    and2 : and2 port map (i_a => i2, i_b => b, o_z =>q2);

END struct;