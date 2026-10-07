LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY rippleCarryAdder IS
  PORT(
    a, b: in std_logic_vector (3 downto 0);
    cin: in std_logic;
    s: out std_logic_vector (3 downto 0);
    overflow: out std_logic;
    cout: out std_logic);
END rippleCarryAdder;

ARCHITECTURE rtl OF rippleCarryAdder IS  
signal c: std_logic_vector (4 downto 0); -- internal cout
signal internal_s: std_logic_vector (3 downto 0); -- to avoid driving output into overflow

  component fullAdder
    port(ain, bin, cin: in std_logic;
          si, pi, gi, cout: out std_logic);
  end component;
BEGIN

  overflow <= (a(3) xnor b(3)) and (a(3) xor internal_s(3));
  c(0) <= cin; 

  FAbit3: fullAdder
    port map(ain => a(3),
              bin => b(3),
              cin => c(3),
              si => internal_s(3), -- we put si into s(3)
              pi => OPEN,
              gi => OPEN,
              cout => c(4));

  FAbit2: fullAdder
    port map(ain => a(2),
              bin => b(2),
              cin => c(2),
              si => internal_s(2),
              pi => OPEN,
              gi => OPEN,
              cout => c(3));

  FAbit1: fullAdder
    port map(ain => a(1),
              bin => b(1),
              cin => c(1),
              si => internal_s(1),
              pi => OPEN,
              gi => OPEN,
              cout => c(2));

  FAbit0: fullAdder
    port map( ain => a(0),
              bin => b(0),
              cin => c(0), -- c(0) we get from cin of the whole adder
              si => internal_s(0),
              pi => OPEN,
              gi => OPEN,
              cout => c(1));

  cout <= c(4);
  s <= internal_s;

END rtl;
