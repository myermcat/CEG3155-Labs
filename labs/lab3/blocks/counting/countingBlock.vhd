-- one block for all three periods. loads whichever one i_select names, counts
-- down, raises o_exp at zero and stops there instead of rolling over, which is
-- what lets s0 sit at expired waiting for a car. reloads when i_reload goes up.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY countingBlock IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_reload   : IN  STD_LOGIC;
    i_select   : IN  STD_LOGIC_VECTOR(1 downto 0);
    i_mscMax   : IN  STD_LOGIC_VECTOR(3 downto 0);
    i_sscMax   : IN  STD_LOGIC_VECTOR(3 downto 0);
    i_yc       : IN  STD_LOGIC_VECTOR(3 downto 0);
    o_exp      : OUT STD_LOGIC;
    o_count    : OUT STD_LOGIC_VECTOR(3 downto 0)); -- for the bcd display
END countingBlock;

ARCHITECTURE rtl OF countingBlock IS
  signal int_enable, int_exp : std_logic;
  signal o_mux, int_count : std_logic_vector(3 downto 0);

  component periodMux
    port(
      i_select : in std_logic_vector(1 downto 0);
      i_mscMax, i_sscMax, i_yc : in std_logic_vector(3 downto 0);
      o_value : out std_logic_vector(3 downto 0) 
    );
  end component;

  component downCounter4
    port(
      i_clock, i_resetBar, i_load, i_enable : in std_logic;
      i_value : in std_logic_vector(3 downto 0);
      o_count : out std_logic_vector(3 downto 0)
    );
  end component;

BEGIN

  mux : periodMux
    port map (
      i_select => i_select,
      i_mscMax => i_mscMax,
      i_sscMax => i_sscMax,
      i_yc => i_yc,
      o_value => o_mux
    );

  counter : downCounter4
    port map (
      i_clock => i_clock,
      i_resetBar => i_resetBar,
      i_load => i_reload,
      i_enable => int_enable,
      i_value => o_mux,
      o_count => int_count
    );

  int_exp <= not (int_count(3) or int_count(2) or int_count(1) or int_count(0));
  int_enable <= not(int_exp);

  o_exp <= int_exp;
  o_count <= int_count;

END rtl;
