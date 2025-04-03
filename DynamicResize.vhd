library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DynamicResize is
    port (
        A     : in  signed(7 downto 0);  -- Entrée signée sur 8 bits
        SetD  : in  integer range 1 to 8; -- Nombre de bits à conserver
        Y     : out signed(7 downto 0)   -- Sortie signée redimensionnée
    );
end entity DynamicResize;

architecture Behavioral of DynamicResize is
begin
    process(A, SetD)
    begin
        -- Redimensionner dynamiquement avec resize
        -- Nous utilisons resize pour ajuster la taille du vecteur tout en préservant le signe
        Y <= resize(A, SetD); -- redimensionnement de A à la taille de SetD
    end process;
end architecture Behavioral;
