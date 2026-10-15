-- one bit comparator. atomic, like dff and fullAdder, so it is behavioural
-- (nothing underneath it to instantiate)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY comparator1 IS
  PORT(
    i_a, i_b : IN  STD_LOGIC;
    o_gt     : OUT STD_LOGIC;    -- a greater than b
    o_eq     : OUT STD_LOGIC);   -- a equal to b
END comparator1;

ARCHITECTURE rtl OF comparator1 IS
BEGIN

END rtl;
