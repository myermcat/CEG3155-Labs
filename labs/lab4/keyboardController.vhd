-- top entity. ports are the board pins.
-- the filter cleans the keyboard clock, the state machine walks the frame,
-- the counter tells it how many bits have gone in, and the shift register
-- holds the scan code for the display.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY keyboardController IS
  PORT( -- ports
    globalClock       : IN  STD_LOGIC;                      -- E3, 100 MHz
    globalReset         : IN  STD_LOGIC;                      -- C12, CPU RESETN
    keyboardClock : IN  STD_LOGIC;                      -- F4, PS2 clock
    keyboardData    : IN  STD_LOGIC;                      -- B2, PS2 data
    ModeSwitch     : IN  STD_LOGIC;                      -- J15, SW0
    BCD1           : OUT STD_LOGIC_VECTOR(3 downto 0);   -- LD15 to LD12
    BCD2           : OUT STD_LOGIC_VECTOR(3 downto 0);   -- LD7 to LD4
    SEG            : OUT STD_LOGIC_VECTOR(6 downto 0);   -- cathodes, active low
    DP             : OUT STD_LOGIC;                      -- H15
    AN             : OUT STD_LOGIC_VECTOR(7 downto 0);   -- anodes, active low
    LED_KEY_HELD   : OUT STD_LOGIC;                      -- LD0, H17
    LED_CHORD      : OUT STD_LOGIC);                     -- LD1, K15
END keyboardController;

ARCHITECTURE struct OF keyboardController IS
BEGIN

END struct;
