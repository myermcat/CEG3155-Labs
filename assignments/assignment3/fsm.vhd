LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fsm IS
  PORT(
    i_clk, i_resetb : in  std_logic;
    i_w             : in  std_logic_vector(2 downto 0);  -- r1 r2 r3
    o_g1, o_g2, o_g3 : out std_logic);
END fsm;

ARCHITECTURE rtl OF fsm IS
  type state_type is (A, B, C, D, E, F, G);
  signal presentState, nextState : state_type;
  signal oneWent, twoWent : std_logic;

BEGIN

  -- next state
  process(presentState, i_w, oneWent, twoWent)
  begin

    case presentState is
        when A => if i_w = "000" then
                nextState <= A;
            elsif i_w = "100" or i_w = "110" then
                nextState <= B;
            elsif  i_w = "010" then
                nextState <= C;
            elsif i_w = "001" then
                nextState <= D;
            elsif i_w = "011" then
                nextState <= G;
            else
                nextState <= F;
            end if;
        when B => if i_w(2) = '1' then
                nextState <= B;
            else
                nextState <= A;
            end if;
        when C => if i_w(1) = '1' then
                nextState <= C;
            else
                nextState <= A;
            end if;
        when D => if i_w(0) = '1' then
                nextState <= D;
            else
                nextState <= A;
            end if;
        -- device 3 already asked, so we only look at 1 and 2 here
        when E => if (i_w(2) = '1' and oneWent = '0') then
                nextState <= F;
            elsif (i_w(1) = '1' and twoWent = '0') then
                nextState <= G;
            else
                nextState <= D;
            end if;
        when F => if i_w(2) = '1' then
                nextState <= F;
            else
                nextState <= E;
            end if;
        when G => if i_w(1) = '1' then
                nextState <= G;
            else
                nextState <= E;
            end if;
        when others => nextState <= A;

    end case;
  end process;

  -- state register, and the two flags go with it
  process(i_clk, i_resetb)
  begin
    if (i_resetb = '0') then
        presentState <= A;
        oneWent <= '0';
        twoWent <= '0';
    elsif (i_clk'event and i_clk = '1') then
        presentState <= nextState;
        if (nextState = F) then
            oneWent <= '1';
        elsif (nextState = G) then
            twoWent <= '1';
        elsif (nextState = D or nextState = A) then
            oneWent <= '0';
            twoWent <= '0';
        end if;
    end if;
  end process;

  -- one grant per device
  process (presentState)
  begin
    o_g1 <= '0';
    o_g2 <= '0';
    o_g3 <= '0';
    case presentState is
        when B => o_g1 <= '1';
        when F => o_g1 <= '1';
        when C => o_g2 <= '1';
        when G => o_g2 <= '1';
        when D => o_g3 <= '1';
        when others => null;
    end case;
  end process;

END rtl;
