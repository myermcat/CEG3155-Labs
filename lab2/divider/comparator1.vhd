-- One bit comparator. An atomic module, named as one in section 8 of the
-- handout alongside the D flip flop and the one bit adder, so it is written
-- behaviourally.

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
