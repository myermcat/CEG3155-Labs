-- Divider datapath. Registers, the paths between them, the devices on those
-- paths, and the multiplexers where paths meet. No logic of its own.
--
-- From the pseudocode, the registers are A, B, S, i, SA, SB and
-- Divide_by_zero. The control signals and status signals below come from the
-- detailed ASM chart, so fill the port list once that chart is finished.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dividerDatapath IS
  PORT(
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_A        : IN  STD_LOGIC_VECTOR (3 downto 0);
    i_B        : IN  STD_LOGIC_VECTOR (3 downto 0);
    -- control signals in, one per register and multiplexer, by rule 9
    -- status signals out: SA, SB, B is zero, S(7..4) >= B, i > 1
    o_S        : OUT STD_LOGIC_VECTOR (7 downto 0));
END dividerDatapath;

ARCHITECTURE struct OF dividerDatapath IS
BEGIN

END struct;
