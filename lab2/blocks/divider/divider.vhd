-- Signed divider, laboratory 2.
-- Stub. Drives zeros so the ALU above it elaborates and simulates while the
-- real design is being written. Replace the architecture, not the entity.
--
-- S(7..4) is the remainder, S(3..0) is the quotient, matching the pseudocode.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY divider IS
  PORT(
    i_clock        : IN  STD_LOGIC;
    i_resetBar     : IN  STD_LOGIC;
    i_A            : IN  STD_LOGIC_VECTOR (3 downto 0);   -- dividend
    i_B            : IN  STD_LOGIC_VECTOR (3 downto 0);   -- divisor
    o_S            : OUT STD_LOGIC_VECTOR (7 downto 0);   -- remainder & quotient
    o_divideByZero : OUT STD_LOGIC);
END divider;

ARCHITECTURE stub OF divider IS
BEGIN
  o_S            <= "00000000";
  o_divideByZero <= '0';
END stub;
