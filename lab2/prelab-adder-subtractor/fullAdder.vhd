LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- a cell for both propagate and carry look ahead adder

entity fullAdder is
    port (ain, bin, cin: in std_logic;
          si, pi, gi, cout: out std_logic);
end fullAdder;

architecture rtl of fullAdder is
    begin
        si <= ain xor bin xor cin;
        cout <= (ain and bin) or (ain and cin) or (bin and cin);

        pi <= ain or bin;
        gi <= ain and bin;
end architecture rtl;  