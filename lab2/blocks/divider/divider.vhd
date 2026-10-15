-- signed divider.
-- placeholder for now: drives zeros so the ALU above still elaborates and
-- simulates while the real one is being written. only the architecture changes.
--
-- S(7..4) is the remainder, S(3..0) is the quotient.

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
