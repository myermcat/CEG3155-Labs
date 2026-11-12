-- top entity. ports are the ones in table 3 of the handout, so they are the
-- board pins. the fsm sits in the middle, the counting block times the
-- periods, and the change detector tells it when to reload.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY trafficLightController IS
  PORT( -- ports
    CLOCK     : IN  STD_LOGIC;                      -- E3, 100 MHz
    RESETBAR  : IN  STD_LOGIC;                      -- C12, CPU RESETN
    LOAD_FSM  : IN  STD_LOGIC;                      -- SW0
    MSC_MAX   : IN  STD_LOGIC_VECTOR(3 downto 0);   -- SW1 to SW4
    SSC_MAX   : IN  STD_LOGIC_VECTOR(3 downto 0);   -- SW5 to SW8
    CAPTEUR   : IN  STD_LOGIC;                      -- BTNU, the car sensor
    MSTL      : OUT STD_LOGIC_VECTOR(2 downto 0);   -- LD16
    SSTL      : OUT STD_LOGIC_VECTOR(2 downto 0);   -- LD17
    SEG       : OUT STD_LOGIC_VECTOR(6 downto 0);   -- cathodes, active low
    AN        : OUT STD_LOGIC_VECTOR(7 downto 0));  -- anodes, active low
END trafficLightController;

ARCHITECTURE struct OF trafficLightController IS
  signal select, exp, 

BEGIN

END struct;
