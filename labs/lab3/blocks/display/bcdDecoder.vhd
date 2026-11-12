-- bonus. splits the current count into two decimal digits for the display.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bcdDecoder IS
  PORT( -- ports
    i_count : IN  STD_LOGIC_VECTOR(3 downto 0);
    o_bcd1  : OUT STD_LOGIC_VECTOR(3 downto 0);  -- left digit, the tens
    o_bcd2  : OUT STD_LOGIC_VECTOR(3 downto 0)); -- right digit, the units
END bcdDecoder;

ARCHITECTURE structural OF bcdDecoder IS
  SIGNAL a, b, c, d : STD_LOGIC;

BEGIN
  a <= i_count(3);
  b <= i_count(2);
  c <= i_count(1);
  d <= i_count(0);

  o_bcd1(3) <= '0';
  o_bcd1(2) <= '0';
  o_bcd1(1) <= '0';
  o_bcd1(0) <= a AND (b OR c);

  o_bcd2(3) <= a AND NOT b AND NOT c;

  o_bcd2(2) <= b AND (c OR NOT a);

  o_bcd2(1) <= (c AND NOT a)
           OR (a AND b AND NOT c);

  o_bcd2(0) <= d;

END structural;
