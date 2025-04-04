-- ==================================================
-- Module : DecimalCounter
-- Description : Compteur décimal avec 24 sorties. 
--               Le compteur s'incrémente ou se décrémente 
--               selon 'direction' sur les fronts montants de 'clock'.
--               Il s'arrête à 0 et 24.
-- Auteur : ChatGPT
-- Date : 2025-04-04
-- Take 53 LE
-- ==================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DecimalCounter is
    Port (
        clock     : in  STD_LOGIC;
        direction : in  STD_LOGIC;
        outputs   : out STD_LOGIC_VECTOR(23 downto 0)
    );
end DecimalCounter;

architecture Behavioral of DecimalCounter is
    signal count : INTEGER range 0 to 24 := 0;

begin
    process(clock)
    begin
        if rising_edge(clock) then
            if direction = '0' then
                if count < 24 then
                    count <= count + 1;
                end if;
            else
                if count > 0 then
                    count <= count - 1;
                end if;
            end if;
        end if;
    end process;

    -- Génération des sorties : un seul bit actif correspondant à la valeur du compteur
    process(count)
    begin
        outputs <= (others => '0'); -- Initialisation à 0
        if count > 0 and count <= 24 then
            outputs(count - 1) <= '1';
        end if;
    end process;

end Behavioral;
