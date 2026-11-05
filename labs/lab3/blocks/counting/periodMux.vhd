-- picks the period the counter loads. yellow is wired to both 01 and 11,
-- since the two yellow states ask for the same length.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY periodMux IS
  PORT( -- ports
    i_select  : IN  STD_LOGIC_VECTOR(1 downto 0);
    i_mscMax  : IN  STD_LOGIC_VECTOR(3 downto 0);  -- switches, main green
    i_sscMax  : IN  STD_LOGIC_VECTOR(3 downto 0);  -- switches, side green
    i_yc      : IN  STD_LOGIC_VECTOR(3 downto 0);  -- the fixed yellow
    o_value   : OUT STD_LOGIC_VECTOR(3 downto 0));
END periodMux;

ARCHITECTURE structural OF periodMux IS
    SIGNAL selMSC   : STD_LOGIC;
    SIGNAL selSSC   : STD_LOGIC;
    SIGNAL selYC : STD_LOGIC;

BEGIN
  selMSC <= NOT i_select(1) AND NOT i_select(0);
  selSSC <= i_select(1) AND NOT i_select(0);
  selYC <= i_select(0);

  o_value(0) <= (selMSC AND i_mscMax(0))
               OR (selSSC AND i_sscMax(0))
               OR (selYC AND i_yc(0));

  o_value(1) <= (selMSC AND i_mscMax(1))
               OR (selSSC AND i_sscMax(1))
               OR (selYC AND i_yc(1));

  o_value(2) <= (selMSC AND i_mscMax(2))
               OR (selSSC AND i_sscMax(2))
               OR (selYC AND i_yc(2));

  o_value(3) <= (selMSC AND i_mscMax(3))
               OR (selSSC AND i_sscMax(3))
               OR (selYC AND i_yc(3));
  
END structural;


