-- drives the datapath by hand, with no control logic attached, so we can see
-- each register and the adder do their own job. the sequence below is one
-- multiplication, -3 times 5, stepped one state at a time.

Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY multDatapath_tb IS
END multDatapath_tb;

ARCHITECTURE sim OF multDatapath_tb IS
  SIGNAL clock, resetBar : STD_LOGIC := '0';
  SIGNAL A, B : STD_LOGIC_VECTOR (3 downto 0) := "0000";
  SIGNAL selA, loadA, selShigh, loadShigh, selSlow, loadSlow : STD_LOGIC := '0';
  SIGNAL shiftSright, loadCount, decrCount                   : STD_LOGIC := '0';
  SIGNAL loadAxorB, resetAxorB, selAddX, selAddY, subSel     : STD_LOGIC := '0';
  SIGNAL A3, S3, S0, S1, count0, count1, AxorB : STD_LOGIC;
  SIGNAL S : STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL done : BOOLEAN := false;
BEGIN

  dut: ENTITY work.multDatapath(struct)
    PORT MAP ( i_resetBar => resetBar, i_clock => clock,
               i_A => A, i_B => B,
               i_selA => selA, i_loadA => loadA,
               i_selShigh => selShigh, i_loadShigh => loadShigh,
               i_selSlow => selSlow, i_loadSlow => loadSlow,
               i_shiftSright => shiftSright,
               i_loadCount => loadCount, i_decrCount => decrCount,
               i_loadAxorB => loadAxorB, i_resetAxorB => resetAxorB,
               i_selAddX => selAddX, i_selAddY => selAddY, i_subSel => subSel,
               o_A3 => A3, o_S3 => S3, o_S0 => S0, o_S1 => S1,
               o_count0 => count0, o_count1 => count1, o_AxorB => AxorB, o_S => S );

  clock <= not clock after 10 ns when not done else '0';

  stimulus: PROCESS
    -- every state drops its control signals after the edge, so the next state
    -- starts from a clean set.
    PROCEDURE step IS
    BEGIN
      WAIT UNTIL rising_edge(clock);
      WAIT FOR 1 ns;
      selA <= '0'; loadA <= '0'; selShigh <= '0'; loadShigh <= '0';
      selSlow <= '0'; loadSlow <= '0'; shiftSright <= '0';
      loadCount <= '0'; decrCount <= '0';
      loadAxorB <= '0'; resetAxorB <= '0';
      selAddX <= '0'; selAddY <= '0'; subSel <= '0';
      WAIT FOR 4 ns;
    END PROCEDURE;
  BEGIN
    resetBar <= '0';
    WAIT FOR 25 ns;
    resetBar <= '1';
    A <= "1101";          -- -3
    B <= "0101";          --  5
    WAIT FOR 5 ns;

    -- s0. A takes the operand, S high takes zero, S low takes B, count takes 4
    selA <= '1'; loadA <= '1'; loadShigh <= '1'; loadSlow <= '1';
    loadCount <= '1'; resetAxorB <= '1';
    step;

    -- s1. the sign flag
    loadAxorB <= '1';
    step;

    -- flipA. A is negative, so A takes the negation of itself
    selAddY <= '0'; subSel <= '1'; loadA <= '1';
    step;

    -- B is positive, so no flipB. four passes of the loop follow.
    -- pass 1, S(0) is 1, so s2 then s3
    selAddX <= '1'; loadShigh <= '1'; selShigh <= '1';
    step;
    shiftSright <= '1'; decrCount <= '1';
    step;

    -- pass 2, S(0) is 0, so s3 only
    shiftSright <= '1'; decrCount <= '1';
    step;

    -- pass 3, S(0) is 1
    selAddX <= '1'; loadShigh <= '1'; selShigh <= '1';
    step;
    shiftSright <= '1'; decrCount <= '1';
    step;

    -- pass 4, S(0) is 0
    shiftSright <= '1'; decrCount <= '1';
    step;

    -- s4. the signs differed, so the product is negated
    selAddY <= '1'; subSel <= '1';
    loadShigh <= '1'; selShigh <= '1'; loadSlow <= '1'; selSlow <= '1';
    step;

    ASSERT S = "11110001"
      REPORT "expected -15, got something else" SEVERITY error;
    REPORT "datapath finished, the product is in S";

    done <= true;
    WAIT;
  END PROCESS stimulus;

END sim;
