LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY fsm is
    port(
        i_clk, i_resetb: in std_logic;
        i_w1, i_w2: in std_logic;
        o_z: out std_logic);
end fsm;

architecture MooreB of fsm is

type state_type is (A, B, C, D, E);
signal presentState, nextState: state_type;

begin

    process(presentState, i_w1, i_w2)
    begin
        case presentState is
            when A => if i_w1 /= i_w2 then 
                    nextState <= A;
                else
                    nextState <= B;
                end if;
            when B => if i_w1 /= i_w2 then 
                    nextState <= A;
                else
                    nextState <= C;
                end if;
            when C => if i_w1 /= i_w2 then
                    nextState <= A;
                else
                    nextState <= D;
                end if;
            when D => if i_w1 /= i_w2 then 
                    nextState <= A;
                else
                    nextState <= E;
                end if;
            when E => if i_w1 /= i_w2 then
                    nextState <= A;
                else
                    nextState <= E;
                end if;
            when others => nextState <=A;
        end case;
    end process;


    process (i_clk, i_resetb)
    begin
        if(i_resetb = '0') then
            presentState <= A;
        elsif (i_clk'event and i_clk = '1') then -- rising edge
            presentState <= nextState;
        end if;
    end process;

    process(presentState)
    begin
        case presentState is
            when A => o_z <= '0';
            when B => o_z <= '0';
            when C => o_z <= '0';
            when D => o_z <= '0';
            when E => o_z <= '1';
            when others => o_z <= '0';
        end case;
    end process;
    end MooreB;