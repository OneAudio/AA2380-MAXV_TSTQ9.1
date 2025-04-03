library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UnsignedToSigned is
    port (
        U_in  : in  unsigned(23 downto 0); -- Entrée non signée 24 bits
        S_out : out signed(23 downto 0)    -- Sortie signée 24 bits
    );
end entity UnsignedToSigned;

architecture Behavioral of UnsignedToSigned is
begin
    S_out <= signed(U_in); -- Conversion directe d'unsigned vers signed
end architecture Behavioral;
