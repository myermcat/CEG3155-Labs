-- the counter reloads on every state change, and select changes on every
-- transition and on none of the self loops. so we hold the previous select and
-- raise o_changed when the two differ.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY changeDetect IS
  PORT( -- ports
    i_clock    : IN  STD_LOGIC;
    i_resetBar : IN  STD_LOGIC;
    i_select   : IN  STD_LOGIC_VECTOR(1 downto 0);
    o_changed  : OUT STD_LOGIC);
END changeDetect;

ARCHITECTURE structural OF changeDetect IS
  COMPONENT dff IS
    PORT(
      i_resetBar : IN  STD_LOGIC;
      i_d        : IN  STD_LOGIC;
      i_enable   : IN  STD_LOGIC;
      i_clock    : IN  STD_LOGIC;
      o_q        : OUT STD_LOGIC;
      o_qBar     : OUT STD_LOGIC
    );
  END COMPONENT;
  
  SIGNAL prevSel : STD_LOGIC_VECTOR(1 downto 0);
  SIGNAL o_xor   : STD_LOGIC_VECTOR(1 downto 0);
  
BEGIN
  DFF0 : dff
    PORT MAP(
      i_resetBar => i_resetBar,
      i_d        => i_select(0),
      i_enable   => '1',
      i_clock    => i_clock,
      o_q        => prevSel(0),
      o_qBar     => OPEN
    );

  DFF1 : dff
    PORT MAP(
      i_resetBar => i_resetBar,
      i_d        => i_select(1),
      i_enable   => '1',
      i_clock    => i_clock,
      o_q        => prevSel(1),
      o_qBar     => OPEN
    );

  o_xor(0) <= i_select(0) XOR prevSel(0);
  o_xor(1) <= i_select(1) XOR prevSel(1);

  o_changed <= o_xor(0) OR o_xor(1);

END structural;


