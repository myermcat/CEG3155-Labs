LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY fsm IS
  PORT (i_clk, i_resetb : IN STD_LOGIC;
        i_w : IN STD_LOGIC;
        o_z : OUT STD_LOGIC);
END fsm;

ARCHITECTURE MooreC OF fsm IS

TYPE state_type is (A, B, C);
SIGNAL presentState, nextState : state_type;

BEGIN

-- Processus combinationnel pour mettre à jour les variables de
-- prochain état
PROCESS (presentState, i_w)
BEGIN
  CASE presentState is
    WHEN A => IF i_w = '0' THEN
                nextState <= A;
              ELSE
                nextState <= B;
              END IF;
    WHEN B => IF i_w = '0' THEN
                nextState <= A;
              ELSE
                nextState <= C;
              END IF;
    WHEN C => IF i_w = '0' THEN
                nextState <= A;
              ELSE
                nextState <= C;
              END IF;
    WHEN OTHERS => nextState <= A;
  END CASE;
END PROCESS;

-- Processus séquentiel pour maintenir le
-- présent état
PROCESS (i_clk, i_resetb)
BEGIN
  IF (i_resetb = '0') THEN
    presentState <= state_type'LEFT -- or A
  ELSIF (i_clk'EVENT AND i_clk = '1') THEN
    presentState <= nextState;
  END IF;
END PROCESS;

-- Processus combinationnel pour mettre à jour les sorties de
-- système (Moore)
PROCESS (presentState)
BEGIN
  CASE presentState is
    WHEN A => o_z <= '0';
    WHEN B => o_z <= '0';
    WHEN C => o_z <= '1';
    WHEN OTHERS => o_z <= '0';
  END CASE;
END PROCESS;
END MooreC;