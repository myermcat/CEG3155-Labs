-- testbench for the whole ALU.
-- GClock is the push button on the board, so here we toggle it by hand and
-- give the multiplier and the divider enough presses to finish.

library ieee;
use ieee.std_logic_1164.all;

entity alu_tb is
end entity alu_tb;

architecture sim of alu_tb is
  signal GClock, GReset, CLK100MHZ : std_logic := '0';
  signal OperandA, OperandB        : std_logic_vector(3 downto 0) := "0000";
  signal OperationSelect           : std_logic_vector(1 downto 0) := "00";
  signal MuxOut                    : std_logic_vector(7 downto 0);
  signal CarryOut, ZeroOut, OverflowOut : std_logic;
  signal seg                       : std_logic_vector(6 downto 0);
  signal an                        : std_logic_vector(7 downto 0);

begin

  dut : entity work.alu(struct)
    port map ( GClock => GClock, GReset => GReset, CLK100MHZ => CLK100MHZ,
               OperandA => OperandA, OperandB => OperandB,
               OperationSelect => OperationSelect,
               MuxOut => MuxOut, CarryOut => CarryOut,
               ZeroOut => ZeroOut, OverflowOut => OverflowOut,
               seg => seg, an => an );

  -- the 100 MHz oscillator. only the display uses it, but it has to run or the
  -- scan never moves.
  oscillator : process
  begin
    CLK100MHZ <= '0'; wait for 5 ns;
    CLK100MHZ <= '1'; wait for 5 ns;
  end process;

  stimulus : process

    -- one press of the button, with the inputs already settled
    procedure press is
    begin
      GClock <= '1'; wait for 40 ns;
      GClock <= '0'; wait for 40 ns;
    end procedure;

    -- set up an operation and let the combinational part settle
    procedure apply (a, b : std_logic_vector(3 downto 0);
                     op   : std_logic_vector(1 downto 0)) is
    begin
      OperandA <= a; OperandB <= b; OperationSelect <= op;
      wait for 40 ns;
    end procedure;

    -- the multiplier takes about eleven states, so give it fifteen presses
    procedure runSequential is
    begin
      for i in 1 to 15 loop press; end loop;
    end procedure;

  begin
    GReset <= '0'; wait for 100 ns;     -- hold reset
    GReset <= '1'; wait for 40 ns;

    -- add: 3 + 2 = 5
    apply("0011", "0010", "00");
    -- add: 6 + 3 = 9, does not fit, so it wraps to -7 and overflow goes up
    apply("0110", "0011", "00");
    -- add: -7 + 1 = -6
    apply("1001", "0001", "00");

    -- subtract: 2 - 1 = 1
    apply("0010", "0001", "01");
    -- subtract: 2 - 5 = -3. this is the one that borrows, so CarryOut drops
    apply("0010", "0101", "01");
    -- subtract: -8 - 1 = -9, does not fit, so it wraps and overflow goes up
    apply("1000", "0001", "01");
    -- subtract: -2 - -2 = 0, ZeroOut should go up
    apply("1110", "1110", "01");

    -- multiply, positive by positive: 3 * 2 = 6
    apply("0011", "0010", "10"); runSequential;
    -- multiply, negative by negative: -3 * -2 = 6
    apply("1101", "1110", "10"); runSequential;
    -- multiply, one of each: -3 * 2 = -6
    apply("1101", "0010", "10"); runSequential;

    -- divide, once the real divider is in
    apply("0110", "0010", "11"); runSequential;

    wait;
  end process;

end architecture sim;
