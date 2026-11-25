LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY half_adder IS
  PORT(
    a, b : in  std_logic;
    s, cout    : out std_logic);
END half_adder;

ARCHITECTURE dataflow OF half_adder IS
  -- signal declarations, components
  -- signal int_q     : std_logic;
  -- signal int_value : std_logic_vector(3 downto 0);
  
BEGIN

  s <= a xor b;
  cout <= a and b;

END dataflow;
