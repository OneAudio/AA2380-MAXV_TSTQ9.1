library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Utilisation de numeric_std

entity DivideByTwo is
    Port ( input : in  signed(7 downto 0);  -- Exemple avec un nombre signé 8 bits
           output : out signed(7 downto 0)
         );
end DivideByTwo;

architecture Behavioral of DivideByTwo is
begin
    -- Décalage arithmétique à droite de 1 bit
    output <= shift_right(input, 1);  
end Behavioral;
