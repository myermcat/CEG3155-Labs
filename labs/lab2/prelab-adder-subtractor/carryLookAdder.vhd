LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY carryLookAdder IS
  PORT(
    a, b: in std_logic_vector (3 downto 0);
    cin: in std_logic;
    s: out std_logic_vector (3 downto 0);
    overflow: out std_logic;
    cout: out std_logic);
END carryLookAdder;

ARCHITECTURE rtl OF carryLookAdder IS  
signal c: std_logic_vector (4 downto 0);
signal g, p: std_logic_vector (3 downto 0);
signal internal_s: std_logic_vector (3 downto 0); -- to avoid driving output into overflow

  component fullAdder
    port(ain, bin, cin: in std_logic;
          si, pi, gi, cout: out std_logic);
  end component;
BEGIN

  overflow <= (a(3) xnor b(3)) and (a(3) xor internal_s(3));
  cout <= c(4);

  c(4) <= g(3) or (p(3) and c(3));
  c(3) <= g(2) or (p(2) and c(2));
  c(2) <= g(1) or (p(1) and c(1));
  c(1) <= g(0) or (p(0) and c(0));
  c(0) <= cin;

  FAbit3: fullAdder
    port map(ain => a(3),
              bin => b(3),
              cin => c(3),
              si => internal_s(3), -- we put si into s(3)
              pi => p(3),
              gi => g(3),
              cout => OPEN);

  FAbit2: fullAdder
    port map(ain => a(2),
              bin => b(2),
              cin => c(2),
              si => internal_s(2),
              pi => p(2),
              gi => g(2),
              cout => OPEN);

  FAbit1: fullAdder
    port map(ain => a(1),
              bin => b(1),
              cin => c(1),
              si => internal_s(1),
              pi => p(1),
              gi => g(1),
              cout => OPEN);

  FAbit0: fullAdder
    port map( ain => a(0),
              bin => b(0),
              cin => c(0),
              si => internal_s(0),
              pi => p(0),
              gi => g(0),
              cout => OPEN);

  s <= internal_s;

END rtl;
