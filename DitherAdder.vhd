-------------------------------------------------------------------
-- O.Narce le 10/02/2025
-- Fait avec Le chat de Mistral AI.
--
-- Code permettant d'ajouter √† un signal d'entr√©e de 24bits 
-- compl√©ment √† 2 un signal de dither de p√©riode 24 bits
-- L'amplitude du dither peut √™tre ajuster entre 0 et 8 bits
-- par le registre d'entr√©e dither_level
--
-- A TESTER !
-- 158LE
-------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DitherAdder is
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        input_24b : in  STD_LOGIC_VECTOR(23 downto 0);
        dither_lvl: in  STD_LOGIC_VECTOR(3 downto 0); -- RÈglage du niveau de dithering (0 ‡ 8 LSB)
        output_24b: out STD_LOGIC_VECTOR(23 downto 0);
        -- test outputs
        ditherout :buffer STD_LOGIC_VECTOR(23 downto 0)
    );
end DitherAdder;

architecture Behavioral of DitherAdder is
    signal lfsr        : STD_LOGIC_VECTOR(23 downto 0) := "000000000000000000000001";
    signal dither      : STD_LOGIC_VECTOR(23 downto 0);
    signal scaled_dith : STD_LOGIC_VECTOR(23 downto 0);
    signal temp_result : STD_LOGIC_VECTOR(24 downto 0);

begin

ditherout <= dither;

    -- LFSR 24 bits pour gÈnÈrer du bruit pseudo-alÈatoire
    process(clk, rst)
    begin
        if rst = '1' then
            lfsr <= "000000000000000000000001";
        elsif rising_edge(clk) then
            lfsr <= lfsr(22 downto 0) & (lfsr(23) xor lfsr(22) xor lfsr(21) xor lfsr(16));
        end if;
    end process;
    
    -- GÈnÈration du dithering en fonction du niveau rÈglÈ
    dither <= lfsr;
    scaled_dith <= std_logic_vector(shift_right(unsigned(dither), (24 - to_integer(unsigned(dither_lvl)))));
    --scaled_dith <= std_logic_vector(shift_left(unsigned(dither), 2));
    
    -- Addition avec gestion d'overflow
    temp_result <= ('0' & input_24b) + ('0' & scaled_dith(23 downto 0));
    
    output_24b <= temp_result(23 downto 0) when temp_result(24) = '0' else
                  (others => '1'); -- Saturation en cas d'overflow
end Behavioral;

