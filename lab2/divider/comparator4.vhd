-- Four bit unsigned comparator, built structurally from four comparator1
-- instances. Provides the status signal that condition box c3 tests,
-- S(7..4) >= B.
--
-- Both operands are positive by the time c3 is reached, since s2 and s3 have
-- already flipped them, so an unsigned comparison is enough.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY comparator4 IS
  PORT(
    i_a, i_b : IN  STD_LOGIC_VECTOR (3 downto 0);
    o_aGEb   : OUT STD_LOGIC);
END comparator4;

ARCHITECTURE struct OF comparator4 IS
BEGIN

END struct;
