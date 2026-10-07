LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY adderSubtractor IS
  PORT(
    a_in, b_in: in std_logic_vector (3 downto 0);
    s_out: out std_logic_vector (3 downto 0);
    cout: out std_logic;
    overflow: out std_logic;
    subSelect: in std_logic); -- adding or subtracting?
END adderSubtractor;

ARCHITECTURE rtl OF adderSubtractor IS  
signal b_after_xor: std_logic_vector (3 downto 0);

  component rippleCarryAdder
    port(a, b: in std_logic_vector (3 downto 0);
          s: out std_logic_vector (3 downto 0);
          cin: in std_logic;
          cout: out std_logic;
          overflow: out std_logic);
  end component;
BEGIN
  b_after_xor(0) <= b_in(0) xor subSelect;
  b_after_xor(1) <= b_in(1) xor subSelect;
  b_after_xor(2) <= b_in(2) xor subSelect;
  b_after_xor(3) <= b_in(3) xor subSelect;

  fourBitAdder: rippleCarryAdder
    port map(a => a_in,
              b => b_after_xor,
              s => s_out,
              cin => subSelect,
              cout => cout,
              overflow => overflow);

END rtl;
