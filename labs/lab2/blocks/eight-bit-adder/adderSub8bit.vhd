LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY adderSub8bit IS
  PORT(
    a_in, b_in: in std_logic_vector (7 downto 0);
    s_out: out std_logic_vector (7 downto 0);
    cout: out std_logic;
    overflow: out std_logic;
    subSelect: in std_logic); -- adding or subtracting?
END adderSub8bit;

ARCHITECTURE rtl OF adderSub8bit IS  
signal b_after_xor: std_logic_vector (7 downto 0);

  component rippleCarry8bit
    port(a, b: in std_logic_vector (7 downto 0);
          s: out std_logic_vector (7 downto 0);
          cin: in std_logic;
          cout: out std_logic;
          overflow: out std_logic);
  end component;
BEGIN
  b_after_xor(0) <= b_in(0) xor subSelect;
  b_after_xor(1) <= b_in(1) xor subSelect;
  b_after_xor(2) <= b_in(2) xor subSelect;
  b_after_xor(3) <= b_in(3) xor subSelect;
  b_after_xor(4) <= b_in(4) xor subSelect;
  b_after_xor(5) <= b_in(5) xor subSelect;
  b_after_xor(6) <= b_in(6) xor subSelect;
  b_after_xor(7) <= b_in(7) xor subSelect;

  eightBitAdder: rippleCarry8bit
    port map(a => a_in,
              b => b_after_xor,
              s => s_out,
              cin => subSelect,
              cout => cout,
              overflow => overflow);

END rtl;
