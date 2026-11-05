-- Divider control logic, one flip flop per state.
--
-- The pseudocode has twelve state boxes, s0 to s11, so twelve flip flops.
-- s0 takes dffset so that the global reset starts the machine there; the rest
-- take dff. Every enable is tied to '1', since the divider runs at full clock
-- speed and has no tick.
--
-- Each D input is the sum of the ways of arriving at that state, and each way
-- is the product of a source state with the conditions along the path.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dividerControl IS
  PORT(
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC
    -- status signals in, control signals out
    );
END dividerControl;

ARCHITECTURE struct OF dividerControl IS
BEGIN

END struct;
