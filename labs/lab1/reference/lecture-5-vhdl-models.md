# The VHDL the course gave us

Every model here is retyped from the slides. The lecture slides put code in two columns and
some of it is a picture, so none of it extracts cleanly from the PDF. Nothing has been added.

| section | from |
|---|---|
| Testbenches | Lecture 3, slides 23 and 24 |
| Structural modelling | Lecture 3, slides 17 and 18 |
| Multiplexers | Lecture 5, slides 18 and 20 |
| Flip flops, registers, counters | Lecture 5, slides 21, 23, 25 and 28 |

---

# The testbench pattern, from Lecture 3 slide 24

The only testbench in the course material. Note three things it does that differ from the
models above: the entity is **empty**, the design under test is instantiated **directly** as
`entity work.name(architecture)` with no COMPONENT declaration, and the port map is
**positional**, with no arrows.

```vhdl
entity test_bench is
end entity test_bench;

architecture test_reg4 of test_bench is
  signal d0, d1, d2, d3, en, clk, q0, q1, q2, q3 : bit;
begin
  dut : entity work.reg4(behav)
    port map ( d0, d1, d2, d3, en, clk, q0, q1, q2, q3 );

  stimulus : process is
  begin
    d0 <= '1';  d1 <= '1';  d2 <= '1';  d3 <= '1';  wait for 20 ns;
    en <= '0';  clk <= '0';  wait for 20 ns;
    en <= '1';  wait for 20 ns;
    clk <= '1';  wait for 20 ns;
    d0 <= '0';  d1 <= '0';  d2 <= '0';  d3 <= '0';  wait for 20 ns;
    en <= '0';  wait for 20 ns;
    ...
    wait;
  end process stimulus;
end architecture test_reg4;
```

The shape is: declare a signal for every port, instantiate the thing being tested, then one
process that drives the inputs and waits between changes. The final bare `wait;` stops the
process for good, which is what ends the simulation.

Lecture 3 slide 23 says what a testbench is for: an architecture holding an instance of the
design, applying test sequences at the inputs and examining the output values, either by
looking at a simulator or with a process that checks correctness.

## Writing one for your own block

The four parts, in the order they appear:

**1. An empty entity.** A testbench has no ports, because nothing connects to it. It is the top
of its own hierarchy.

```vhdl
entity myblock_tb is
end entity myblock_tb;
```

**2. One signal per port of the thing you are testing**, declared before `begin`. Give them the
types the block's ports have, so a `STD_LOGIC_VECTOR(7 downto 0)` port needs a vector signal.

**3. One instance**, connecting each port to its signal. Formal on the left, actual on the
right, and the architecture name in brackets after the entity:

```vhdl
dut : entity work.myblock(rtl)
  port map ( i_first => firstSignal, o_result => resultSignal );
```

`dut` means device under test. It is only a label, so call it what you like.

**4. A stimulus process** that drives the inputs, with `wait for` between the changes so the
design has simulated time to react. It ends with a bare `wait;`, which suspends the process
for good and lets the simulation finish.

## Two things about the lecture's example

**It drives the clock by hand.** Look at slide 24 again: `clk <= '0'; wait for 20 ns;` then
later `clk <= '1'; wait for 20 ns;`. There is no separate clock generator anywhere in the
course material. Writing `clk <= not clk after 5 ns;` as a concurrent statement outside the
process is the usual shortcut and it works, but it is not something the lectures show.

**There is no checking in it.** The process drives inputs and stops. Nothing compares the
outputs against anything. Slide 23 says a testbench applies test sequences at the inputs and
examines the output values "either with a simulator, or with a process which verifies correct
operation", and the course only ever shows the first. So you run it, open the waveform, and
read the outputs yourself.

---

---

## Slide 21: enabled, asynchronous reset D flip flop  (`enARdFF_2`)

The atom. Everything else in the lecture is built from it.

```vhdl
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY enARdFF_2 IS
  PORT(
    i_resetBar : IN  STD_LOGIC;
    i_d        : IN  STD_LOGIC;
    i_enable   : IN  STD_LOGIC;
    i_clock    : IN  STD_LOGIC;
    o_q, o_qBar : OUT STD_LOGIC);
END enARdFF_2;

ARCHITECTURE rtl OF enARdFF_2 IS
  SIGNAL int_q : STD_LOGIC;
BEGIN
  oneBitRegister:
  PROCESS(i_resetBar, i_clock)
  BEGIN
    IF (i_resetBar = '0') THEN
      int_q <= '0';
    ELSIF (i_clock'EVENT and i_clock = '1') THEN
      IF (i_enable = '1') THEN
        int_q <= i_d;
      END IF;
    END IF;
  END PROCESS oneBitRegister;

  -- Output Driver
  o_q    <= int_q;
  o_qBar <= not(int_q);
END rtl;
```

---

## Slide 23: three bit register, parallel load  (`threeBitRegister`)

Three flip flops side by side. Each takes its own bit of the input. One `i_load` enables
all three at once, so the whole word arrives in one clock.

```vhdl
ENTITY threeBitRegister IS
  PORT(
    i_resetBar, i_load : IN  STD_LOGIC;
    i_clock            : IN  STD_LOGIC;
    i_Value            : IN  STD_LOGIC_VECTOR(2 downto 0);
    o_Value            : OUT STD_LOGIC_VECTOR(2 downto 0));
END threeBitRegister;

ARCHITECTURE rtl OF threeBitRegister IS
  SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(2 downto 0);
  COMPONENT enARdFF_2
    PORT(
      i_resetBar : IN  STD_LOGIC;
      i_d        : IN  STD_LOGIC;
      i_enable   : IN  STD_LOGIC;
      i_clock    : IN  STD_LOGIC;
      o_q, o_qBar : OUT STD_LOGIC);
  END COMPONENT;
BEGIN
  msb: enARdFF_2
    PORT MAP (i_resetBar => i_resetBar,
              i_d        => i_Value(2),
              i_enable   => i_load,
              i_clock    => i_clock,
              o_q        => int_Value(2),
              o_qBar     => int_notValue(2));

  ssb: enARdFF_2
    PORT MAP (i_resetBar => i_resetBar,
              i_d        => i_Value(1),
              i_enable   => i_load,
              i_clock    => i_clock,
              o_q        => int_Value(1),
              o_qBar     => int_notValue(1));

  lsb: enARdFF_2
    PORT MAP (i_resetBar => i_resetBar,
              i_d        => i_Value(0),
              i_enable   => i_load,
              i_clock    => i_clock,
              o_q        => int_Value(0),
              o_qBar     => int_notValue(0));

  -- Output Driver
  o_Value <= int_Value;
END rtl;
```

---

## Slide 25: three bit shift register  (`threeBitShiftRegister`)

Same three flip flops, this time wired in a chain. Each `i_d` comes from the previous stage's
`o_q`, and a single bit enters at the top.

```vhdl
ENTITY threeBitShiftRegister IS
  PORT(
    i_resetBar, i_load : IN  STD_LOGIC;
    i_clock            : IN  STD_LOGIC;
    i_Value            : IN  STD_LOGIC;
    o_Value            : OUT STD_LOGIC);
END threeBitShiftRegister;

ARCHITECTURE rtl OF threeBitShiftRegister IS
  SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(2 downto 0);
  COMPONENT enARdFF_2
    PORT( i_resetBar, i_d, i_enable, i_clock : IN STD_LOGIC;
          o_q, o_qBar : OUT STD_LOGIC);
  END COMPONENT;
BEGIN
  msb: enARdFF_2
    PORT MAP (i_resetBar => i_resetBar, i_d => i_Value,
              i_enable => i_load, i_clock => i_clock,
              o_q => int_Value(2), o_qBar => int_notValue(2));

  ssb: enARdFF_2
    PORT MAP (i_resetBar => i_resetBar, i_d => int_Value(2),
              i_enable => i_load, i_clock => i_clock,
              o_q => int_Value(1), o_qBar => int_notValue(1));

  lsb: enARdFF_2
    PORT MAP (i_resetBar => i_resetBar, i_d => int_Value(1),
              i_enable => i_load, i_clock => i_clock,
              o_q => int_Value(0), o_qBar => int_notValue(0));

  -- Output Driver
  o_Value <= int_Value(0);
END rtl;
```

---

## Slide 28: two bit counter  (`counter`)

**The most useful one for Laboratory 1.** It shows how next state logic is written: as plain
concurrent signal assignments, feeding the `i_d` inputs of the flip flops. No multiplexer
component, no adder component, no process.

```vhdl
ENTITY counter IS
  PORT(
    i_resetBar, i_load : IN  STD_LOGIC;
    i_clock            : IN  STD_LOGIC;
    o_Value            : OUT STD_LOGIC_VECTOR(1 downto 0));
END counter;

ARCHITECTURE rtl OF counter IS
  SIGNAL int_a, int_na, int_b, int_nb : STD_LOGIC;
  SIGNAL int_notA, int_notB : STD_LOGIC;
  COMPONENT enARdFF_2
    PORT( i_resetBar, i_d, i_enable, i_clock : IN STD_LOGIC;
          o_q, o_qBar : OUT STD_LOGIC);
  END COMPONENT;
BEGIN
  -- Concurrent Signal Assignment
  int_na <= int_a xor int_b;
  int_nb <= not(int_b);

  msb: enARdFF_2
    PORT MAP (i_resetBar => i_resetBar, i_d => int_na,
              i_enable => i_load, i_clock => i_clock,
              o_q => int_a, o_qBar => int_notA);

  lsb: enARdFF_2
    PORT MAP (i_resetBar => i_resetBar, i_d => int_nb,
              i_enable => i_load, i_clock => i_clock,
              o_q => int_b, o_qBar => int_notB);

  -- Output Driver
  o_Value <= int_a & int_b;
END rtl;
```

Lecture 5 also carries an S-R latch, an enabled S-R latch, a D latch, a plain D flip flop,
a J-K flip flop, a T flip flop and a comparator, all in the same shape.

---

# Multiplexers, from Lecture 5 slides 18 and 20

**The course never writes a mux as its own entity.** It writes it as a concurrent signal
assignment with `when ... else`, placed between `BEGIN` and `END` like any other concurrent
statement. Both examples below come from flip flop architectures, where the mux picks what
reaches the D input.

## Slide 18: a four to one, inside the JK flip flop

```vhdl
int_jk <= i_j & i_k;

int_muxOutput <= int_q    when int_jk = "00" else
                 '0'      when int_jk = "01" else
                 '1'      when int_jk = "10" else
                 int_qBar;
```

The two select bits are gathered into one vector with `&` first, so the branches can compare
against a string literal.

## Slide 20: a two to one, inside the T flip flop

```vhdl
int_muxOutput <= int_q when i_t = '0' else
                 int_qBar;
```

The last branch is a bare `else` with no condition, which makes the choice complete and leaves
no case undriven. The same shape works for vectors, so a mux choosing between two
`STD_LOGIC_VECTOR(7 downto 0)` signals is written exactly this way.

---

# Structural modelling, from Lecture 3 slides 17 and 18

**This is the reference for a file that wires several different blocks together**, which is
what the datapath, the control logic and the top entity all are. Everything above instantiates
one kind of component many times. This instantiates two kinds and joins them with an internal
signal.

## Slide 17: the pieces first

```vhdl
entity d_latch is
  port ( d, clk : in bit;  q : out bit );
end entity d_latch;

architecture basic of d_latch is
begin
  latch_behavior : process is
  begin
    if clk = '1' then
      q <= d after 2 ns;
    end if;
    wait on clk, d;
  end process latch_behavior;
end architecture basic;


entity and2 is
  port ( a, b : in bit;  y : out bit );
end entity and2;

architecture basic of and2 is
begin
  and2_behavior : process is
  begin
    y <= a and b after 2 ns;
    wait on a, b;
  end process and2_behavior;
end architecture basic;
```

## Slide 18: then a register built from them

```vhdl
architecture struct of reg4 is
  signal int_clk : bit;
begin
  bit0 : entity work.d_latch(basic)
    port map ( d0, int_clk, q0 );
  bit1 : entity work.d_latch(basic)
    port map ( d1, int_clk, q1 );
  bit2 : entity work.d_latch(basic)
    port map ( d2, int_clk, q2 );
  bit3 : entity work.d_latch(basic)
    port map ( d3, int_clk, q3 );
  gate : entity work.and2(basic)
    port map ( en, clk, int_clk );
end architecture struct;
```

**The three things to take from slide 18:**

Different kinds of block are instantiated in the same architecture, four latches and one gate.

`int_clk` is an internal signal that carries the gate's output to the latches. That is how one
block feeds another, and it is how the control logic's outputs reach the datapath.

Direct entity instantiation, `entity work.name(architecture)`, with no COMPONENT declaration.
The synthesis models in Lecture 5 declare COMPONENT instead, so both styles appear in the
course and either is acceptable.
