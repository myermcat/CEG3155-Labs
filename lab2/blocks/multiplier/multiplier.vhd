-- signed 4x4 multiplier. datapath plus control, nothing else.
-- product comes out as 8 bits, S(7..4) over S(3..0).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY multiplier IS
  PORT(
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_A        : IN  STD_LOGIC_VECTOR (3 downto 0);
    i_B        : IN  STD_LOGIC_VECTOR (3 downto 0);
    o_S        : OUT STD_LOGIC_VECTOR (7 downto 0));
END multiplier;

ARCHITECTURE struct OF multiplier IS

  -- control to datapath
  SIGNAL selA, loadA, selShigh, loadShigh, selSlow, loadSlow : STD_LOGIC;
  SIGNAL shiftSright, loadCount, decrCount                   : STD_LOGIC;
  SIGNAL loadAxorB, resetAxorB, selAddX, selAddY, subSel     : STD_LOGIC;

  -- datapath back to control
  SIGNAL A3, S3, S0, count0, AxorB : STD_LOGIC;

  COMPONENT multDatapath
    PORT( i_resetBar, i_clock : IN STD_LOGIC;
          i_A, i_B : IN STD_LOGIC_VECTOR (3 downto 0);
          i_selA, i_loadA, i_selShigh, i_loadShigh, i_selSlow, i_loadSlow : IN STD_LOGIC;
          i_shiftSright, i_loadCount, i_decrCount : IN STD_LOGIC;
          i_loadAxorB, i_resetAxorB, i_selAddX, i_selAddY, i_subSel : IN STD_LOGIC;
          o_A3, o_S3, o_S0, o_count0, o_AxorB : OUT STD_LOGIC;
          o_S : OUT STD_LOGIC_VECTOR (7 downto 0));
  END COMPONENT;

  COMPONENT multControl
    PORT( i_resetBar, i_clock : IN STD_LOGIC;
          i_A3, i_S3, i_S0, i_count0, i_AxorB : IN STD_LOGIC;
          o_selA, o_loadA, o_selShigh, o_loadShigh, o_selSlow, o_loadSlow : OUT STD_LOGIC;
          o_shiftSright, o_loadCount, o_decrCount : OUT STD_LOGIC;
          o_loadAxorB, o_resetAxorB, o_selAddX, o_selAddY, o_subSel : OUT STD_LOGIC);
  END COMPONENT;

BEGIN

  path: multDatapath
    PORT MAP ( i_resetBar => i_resetBar, i_clock => i_clock,
               i_A => i_A, i_B => i_B,
               i_selA => selA, i_loadA => loadA,
               i_selShigh => selShigh, i_loadShigh => loadShigh,
               i_selSlow => selSlow, i_loadSlow => loadSlow,
               i_shiftSright => shiftSright,
               i_loadCount => loadCount, i_decrCount => decrCount,
               i_loadAxorB => loadAxorB, i_resetAxorB => resetAxorB,
               i_selAddX => selAddX, i_selAddY => selAddY, i_subSel => subSel,
               o_A3 => A3, o_S3 => S3, o_S0 => S0,
               o_count0 => count0, o_AxorB => AxorB,
               o_S => o_S );

  control: multControl
    PORT MAP ( i_resetBar => i_resetBar, i_clock => i_clock,
               i_A3 => A3, i_S3 => S3, i_S0 => S0,
               i_count0 => count0, i_AxorB => AxorB,
               o_selA => selA, o_loadA => loadA,
               o_selShigh => selShigh, o_loadShigh => loadShigh,
               o_selSlow => selSlow, o_loadSlow => loadSlow,
               o_shiftSright => shiftSright,
               o_loadCount => loadCount, o_decrCount => decrCount,
               o_loadAxorB => loadAxorB, o_resetAxorB => resetAxorB,
               o_selAddX => selAddX, o_selAddY => selAddY, o_subSel => subSel );

END struct;
