LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY rippleCarry8bit IS
  PORT(
    a, b: in std_logic_vector (7 downto 0);
    cin: in std_logic;
    s: out std_logic_vector (7 downto 0);
    overflow: out std_logic;
    cout: out std_logic);
END rippleCarry8bit;

ARCHITECTURE rtl OF rippleCarry8bit IS  
signal c: std_logic_vector (8 downto 0); -- internal cout
signal internal_s: std_logic_vector (7 downto 0); -- to avoid driving output into overflow

  component fullAdder
    port(ain, bin, cin: in std_logic;
          si, pi, gi, cout: out std_logic);
  end component;
BEGIN

  overflow <= (a(7) xnor b(7)) and (a(7) xor internal_s(7));
  c(0) <= cin; 

  FAbit7: fullAdder
    port map(ain => a(7),
              bin => b(7),
              cin => c(7),
              si => internal_s(7), 
              pi => OPEN,
              gi => OPEN,
              cout => c(8));

  FAbit6: fullAdder
    port map(ain => a(6),
              bin => b(6),
              cin => c(6),
              si => internal_s(6),
              pi => OPEN,
              gi => OPEN,
              cout => c(7));

  FAbit5: fullAdder
    port map(ain => a(5),
              bin => b(5),
              cin => c(5),
              si => internal_s(5), 
              pi => OPEN,
              gi => OPEN,
              cout => c(6));

  FAbit4: fullAdder
    port map(ain => a(4),
              bin => b(4),
              cin => c(4),
              si => internal_s(4), 
              pi => OPEN,
              gi => OPEN,
              cout => c(5));

  FAbit3: fullAdder
    port map(ain => a(3),
              bin => b(3),
              cin => c(3),
              si => internal_s(3), 
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

  cout <= c(8);
  s <= internal_s;

END rtl;
