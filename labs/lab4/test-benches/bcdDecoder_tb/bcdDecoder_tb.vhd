-- four scan codes through the split. 1C is the a key, F0 the break prefix,
-- 00 and FF are the two ends of the range.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bcdDecoder_tb IS
END bcdDecoder_tb;

ARCHITECTURE sim OF bcdDecoder_tb IS

  COMPONENT bcdDecoder IS
    PORT(
      i_scanCode : IN  STD_LOGIC_VECTOR(7 downto 0);
      o_bcd1     : OUT STD_LOGIC_VECTOR(3 downto 0);
      o_bcd2     : OUT STD_LOGIC_VECTOR(3 downto 0));
  END COMPONENT;

  SIGNAL scanCode : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
  SIGNAL bcd1     : STD_LOGIC_VECTOR(3 downto 0);
  SIGNAL bcd2     : STD_LOGIC_VECTOR(3 downto 0);

BEGIN

  DUT: bcdDecoder PORT MAP(
    i_scanCode => scanCode,
    o_bcd1     => bcd1,
    o_bcd2     => bcd2
  );

  stimulus: PROCESS
  BEGIN
    WAIT FOR 20 ns;
    scanCode <= "00011100";   -- 1C, expect 1 and C
    WAIT FOR 20 ns;
    scanCode <= "11110000";   -- F0, expect F and 0
    WAIT FOR 20 ns;
    scanCode <= "11111111";   -- FF
    WAIT FOR 20 ns;
    scanCode <= "00000000";   -- 00
    WAIT FOR 20 ns;
    WAIT;
  END PROCESS;

END sim;
