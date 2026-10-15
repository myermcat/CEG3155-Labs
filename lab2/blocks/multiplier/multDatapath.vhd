Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY multDatapath IS
  PORT( -- ports
    i_resetBar, i_clock : IN STD_LOGIC;
    i_A, i_B : IN STD_LOGIC_VECTOR (3 downto 0);
    i_selA, i_loadA, i_selShigh, i_loadShigh, i_selSlow, i_loadSlow : IN STD_LOGIC;
    i_shiftSright, i_loadCount, i_decrCount : IN STD_LOGIC;
    i_loadAxorB, i_resetAxorB, i_selAddX, i_selAddY, i_subSel : IN STD_LOGIC;
    o_A3, o_S3, o_S0, o_S1, o_count0, o_count1, o_AxorB : OUT STD_LOGIC;
    o_S : OUT STD_LOGIC_VECTOR (7 downto 0));
END multDatapath;

ARCHITECTURE struct OF multDatapath IS -- internal signals
  SIGNAL A         : STD_LOGIC_VECTOR (3 downto 0);
  SIGNAL S         : STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL count     : STD_LOGIC_VECTOR (2 downto 0);
  SIGNAL addX, addY, addResult : STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL nextA, nextS, nextS2  : STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL AxorB, resetBarAxorB  : STD_LOGIC;
BEGIN

  -- the one adder, doing all four jobs. X is zero or S, Y is A in the high
  -- half or S, and subSel says whether we are adding or subtracting.
  muxAddX: ENTITY work.mux(rtl)
    PORT MAP ( i_zero => "00000000", i_one => S,
               i_sel => i_selAddX, o_Value => addX );

  muxAddY: ENTITY work.mux(rtl)
    PORT MAP ( i_zero => A & "0000", i_one => S,
               i_sel => i_selAddY, o_Value => addY );

  adder: ENTITY work.adderSub8bit(rtl)
    PORT MAP ( a_in => addX, b_in => addY, s_out => addResult,
               cout => OPEN, overflow => OPEN, subSelect => i_subSel );

  -- A takes the operand in s0 and the negated operand in flipA. we negate it
  -- in the high half, since that is where the Y multiplexer puts it.
  muxA: ENTITY work.mux(rtl)
    PORT MAP ( i_zero => addResult(7 downto 4) & "0000",
               i_one  => i_A & "0000",
               i_sel => i_selA, o_Value => nextA );

  regA: ENTITY work.reg4bit(rtl)
    PORT MAP ( i_resetBar => i_resetBar, i_load => i_loadA,
               i_clock => i_clock, i_Value => nextA(7 downto 4),
               o_Value => A );

  -- S high is zero in s0 and the adder result after that. S low is B in s0 and
  -- the adder result after that. the two halves load separately.
  muxShigh: ENTITY work.mux(rtl)
    PORT MAP ( i_zero => "00000000", i_one => addResult,
               i_sel => i_selShigh, o_Value => nextS );

  muxSlow: ENTITY work.mux(rtl)
    PORT MAP ( i_zero => "0000" & i_B, i_one => addResult,
               i_sel => i_selSlow, o_Value => nextS2 );

  regS: ENTITY work.ShiftReg8bit(rtl)
    PORT MAP ( i_resetBar => i_resetBar,
               loadSlow => i_loadSlow, loadShigh => i_loadShigh,
               i_shift => i_shiftSright, i_clock => i_clock,
               i_Value => nextS(7 downto 4) & nextS2(3 downto 0),
               o_Value => S );

  -- counter of 4 passes
  counter: ENTITY work.counter3bit(rtl)
    PORT MAP ( i_resetBar => i_resetBar, i_load => i_loadCount,
               i_decr => i_decrCount, i_clock => i_clock, o_Value => count );

  -- the sign flag. s0 clears it, s1 loads the exclusive OR of the two sign
  -- bits, and it holds until the product is negated in s4.
  resetBarAxorB <= i_resetBar and not(i_resetAxorB);

  flagAxorB: ENTITY work.dff(rtl)
    PORT MAP ( i_resetBar => resetBarAxorB, i_d => A(3) xor S(3),
               i_enable => i_loadAxorB, i_clock => i_clock,
               o_q => AxorB, o_qBar => OPEN );

  -- status back to the control logic
  o_A3     <= A(3);
  o_S3     <= S(3);
  o_S0     <= S(0);
  -- the bit and the count the loop will see after the shift in s3
  o_S1     <= S(1);
  o_count0 <= not(count(2) or count(1) or count(0));
  o_count1 <= count(0) and not(count(1)) and not(count(2));
  o_AxorB  <= AxorB;
  o_S      <= S;

END struct;
