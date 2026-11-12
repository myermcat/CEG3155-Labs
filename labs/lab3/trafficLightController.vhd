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
  signal tick, sscs, fsmEnable, exp, reload : std_logic;
  signal sel : std_logic_vector(1 downto 0);
  signal cnt, bcd1, bcd2 : std_logic_vector(3 downto 0);
  signal mstlOneHot, sstlOneHot : std_logic_vector(2 downto 0);

  -- the yellow period is not programmable, so it lives here
  constant YC : std_logic_vector(3 downto 0) := "0011";

  component fsmControl
    port(
      i_clock, i_resetBar, i_enable, i_sscs, i_exp : in std_logic;
      o_mstl, o_sstl : out std_logic_vector (2 downto 0);
      o_select : out std_logic_vector (1 downto 0)
    );
  end component;

  component countingBlock
    port(
      i_clock, i_resetBar, i_reload : in std_logic;
      i_select : in std_logic_vector(1 downto 0);
      i_mscMax, i_sscMax, i_yc : in std_logic_vector(3 downto 0);
      o_exp : out std_logic;
      o_count : out std_logic_vector(3 downto 0)
    );
  end component;

  component changeDetect
    port(
      i_clock, i_resetBar : in std_logic;
      i_select : in std_logic_vector(1 downto 0);
      o_changed : out std_logic -- shows state change
    );
  end component;

  component bcdDecoder
    port(
      i_count : in std_logic_vector(3 downto 0);
      o_bcd1, o_bcd2 : out std_logic_vector(3 downto 0)
    );
  end component;

BEGIN

  fsm: fsmControl
  port map(
    i_clock => 
    i_resetBar => 
    i_enable => 
    i_sscs =>
    i_exp => 
    o_mstl =>
    o_sstl =>
    o_select =>
  );

  theCounter: countingBlock
  port map(

  );

  change: changeDetect
  port map(
    i_clock =>
    i_resetBar =>
    i_select =>
    o_changed =>
  );

  bcdDec: bcdDecoder
  port map(
    i_count =>
    o_bcd1 =>
    o_bcd2 =>
  );
  
  -- the machine only steps on a tick, and only while the switch is up
  fsmEnable <= tick and LOAD_FSM;

  -- the one hot vectors drive the colour channels of the rgb leds. bit 1 is
  -- yellow and the board has no yellow diode, so we light red and green
  -- together for it and leave the blue channel off.
  MSTL(2) <= mstlOneHot(2) or mstlOneHot(1);   -- red channel
  MSTL(1) <= '0';                              -- blue channel
  MSTL(0) <= mstlOneHot(0) or mstlOneHot(1);   -- green channel

  SSTL(2) <= sstlOneHot(2) or sstlOneHot(1);
  SSTL(1) <= '0';
  SSTL(0) <= sstlOneHot(0) or sstlOneHot(1);

END struct;
