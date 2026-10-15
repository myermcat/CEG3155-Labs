-- 4 bit signed ALU. top entity, this is what goes on the board.
-- ports are the ones in table 3 of the handout.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY alu IS
  PORT(
    GClock          : IN  STD_LOGIC;                     -- BTNC, one state per press
    GReset          : IN  STD_LOGIC;                     -- active low
    CLK100MHZ       : IN  STD_LOGIC;                     -- E3, display refresh only
    OperandA        : IN  STD_LOGIC_VECTOR (3 downto 0);
    OperandB        : IN  STD_LOGIC_VECTOR (3 downto 0);
    OperationSelect : IN  STD_LOGIC_VECTOR (1 downto 0);
    MuxOut          : OUT STD_LOGIC_VECTOR (7 downto 0);
    CarryOut        : OUT STD_LOGIC;
    ZeroOut         : OUT STD_LOGIC;
    OverflowOut     : OUT STD_LOGIC;
    seg             : OUT STD_LOGIC_VECTOR (6 downto 0); -- cathodes, active low
    an              : OUT STD_LOGIC_VECTOR (7 downto 0)); -- anodes, active low
END alu;

ARCHITECTURE struct OF alu IS

  SIGNAL subSel                      : STD_LOGIC;
  SIGNAL addSum                      : STD_LOGIC_VECTOR (3 downto 0);
  SIGNAL addCout, addOverflow        : STD_LOGIC;
  SIGNAL addResult                   : STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL multResult, divResult       : STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL result                      : STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL divByZero                   : STD_LOGIC;
  SIGNAL isMulOrDiv                  : STD_LOGIC;

  COMPONENT adderSubtractor
    PORT( a_in, b_in : IN  STD_LOGIC_VECTOR (3 downto 0);
          s_out      : OUT STD_LOGIC_VECTOR (3 downto 0);
          cout       : OUT STD_LOGIC;
          overflow   : OUT STD_LOGIC;
          subSelect  : IN  STD_LOGIC);
  END COMPONENT;

  COMPONENT multiplier
    PORT( i_clock, i_resetBar : IN STD_LOGIC;
          i_A, i_B : IN  STD_LOGIC_VECTOR (3 downto 0);
          o_S      : OUT STD_LOGIC_VECTOR (7 downto 0));
  END COMPONENT;

  COMPONENT divider
    PORT( i_clock, i_resetBar : IN STD_LOGIC;
          i_A, i_B       : IN  STD_LOGIC_VECTOR (3 downto 0);
          o_S            : OUT STD_LOGIC_VECTOR (7 downto 0);
          o_divideByZero : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT display_controller
    PORT( clk100      : IN  STD_LOGIC;
          d0,d1,d2,d3 : IN  STD_LOGIC_VECTOR (3 downto 0);
          seg         : OUT STD_LOGIC_VECTOR (6 downto 0);
          an          : OUT STD_LOGIC_VECTOR (7 downto 0));
  END COMPONENT;

BEGIN

  -- 00 adds, 01 subtracts. for 10 and 11 the adder's answer is thrown away, so
  -- we hold subSel low there and the carry and overflow flags stay quiet.
  isMulOrDiv <= OperationSelect(1);
  subSel     <= OperationSelect(0) and not OperationSelect(1);

  adder: adderSubtractor
    PORT MAP ( a_in => OperandA, b_in => OperandB,
               s_out => addSum, cout => addCout,
               overflow => addOverflow, subSelect => subSel );

  -- the sum is 4 bits and MuxOut is 8, so we copy the sign up into the top
  -- nibble. otherwise -1 would read as 0F on the display instead of FF.
  addResult <= addSum(3) & addSum(3) & addSum(3) & addSum(3) & addSum;

  mult: multiplier
    PORT MAP ( i_clock => GClock, i_resetBar => GReset,
               i_A => OperandA, i_B => OperandB, o_S => multResult );

  div: divider
    PORT MAP ( i_clock => GClock, i_resetBar => GReset,
               i_A => OperandA, i_B => OperandB,
               o_S => divResult, o_divideByZero => divByZero );

  -- 00 and 01 both come off the adder, it is the same block either way.
  -- named straight off the entity because MuxOut is already a port here and
  -- vhdl does not care about the capital letters.
  outputMux: ENTITY work.muxOut(rtl)
    PORT MAP ( i_zero => addResult, i_one => addResult,
               i_two  => multResult, i_three => divResult,
               i_sel  => OperationSelect, o_Value => result );

  MuxOut <= result;

  -- status. zero looks at the whole result, the other two only mean anything
  -- for add and subtract so we gate them off during multiply and divide.
  ZeroOut     <= not (result(7) or result(6) or result(5) or result(4) or
                      result(3) or result(2) or result(1) or result(0));
  CarryOut    <= addCout     and not isMulOrDiv;
  OverflowOut <= addOverflow and not isMulOrDiv;

  -- two hex digits of the result, the other two digits blank
  digits: display_controller
    PORT MAP ( clk100 => CLK100MHZ,
               d0 => result(3 downto 0), d1 => result(7 downto 4),
               d2 => "0000", d3 => "0000",
               seg => seg, an => an );

END struct;
