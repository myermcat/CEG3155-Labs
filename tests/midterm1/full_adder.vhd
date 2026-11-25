LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY full_adder IS
  PORT(
    a, b, cin : in  std_logic;
    s, cout    : out std_logic);
END full_adder;

ARCHITECTURE rtl OF full_adder IS
  
  component half_adder
  port(a, b : in std_logic;
        s, cout : out std_logic);
  end component;

  -- internal wires
  signal s1, cout1, cout2 : std_logic;

  
BEGIN

  HA1 : half_adder port map (a => a, b => b, s => s1, cout => cout1);
  HA2 : half_adder port map (a => s1, b => cin, s => s, cout => cout2);
  
  cout <= cout1 or cout2;

END rtl;
