-- Time multiplexed seven segment driver for the Nexys A7-100T.
--
-- Taken from Appendix F of the course material, which supplies this block and
-- states that it, like the clock divider, may be written behaviourally even
-- though the rest of the design must be structural. Only the library clauses
-- are added here, since the appendix prints the entity and architecture alone.
--
-- All eight digits on this board share one set of seven cathodes and are
-- enabled one at a time by eight active low anodes, so the digits are scanned
-- fast enough that the eye fuses them. Both buses are active low: a segment
-- lights when its pin is driven '0', and a digit is enabled when its anode is
-- '0'. Hence "1000000" for the digit zero rather than "0111111".
--
-- The refresh counter runs from the 100 MHz oscillator and its top two bits
-- pick the active digit, which gives a scan of roughly 760 Hz.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_controller is
  port ( clk100      : in  std_logic;                     -- 100 MHz oscillator, pin E3
         d0,d1,d2,d3 : in  std_logic_vector(3 downto 0);  -- four hex nibbles
         seg         : out std_logic_vector(6 downto 0);  -- CA to CG, active low
         an          : out std_logic_vector(7 downto 0)); -- AN0 to AN7, active low
end display_controller;

architecture rtl of display_controller is
  signal refresh : unsigned(16 downto 0) := (others => '0');
  signal sel     : std_logic_vector(1 downto 0);
  signal nyb     : std_logic_vector(3 downto 0);
begin
  process(clk100) begin
    if rising_edge(clk100) then refresh <= refresh + 1; end if;
  end process;

  sel <= std_logic_vector(refresh(16 downto 15));

  with sel select nyb <= d0 when "00", d1 when "01",
                         d2 when "10", d3 when others;

  with sel select an   <= "11111110" when "00",
                          "11111101" when "01",
                          "11111011" when "10",
                          "11110111" when others;

  with nyb select seg <=
      "1000000" when "0000", "1111001" when "0001",
      "0100100" when "0010", "0110000" when "0011",
      "0011001" when "0100", "0010010" when "0101",
      "0000010" when "0110", "1111000" when "0111",
      "0000000" when "1000", "0010000" when "1001",
      "0001000" when "1010", "0000011" when "1011",
      "1000110" when "1100", "0100001" when "1101",
      "0000110" when "1110", "0001110" when others;
end rtl;
