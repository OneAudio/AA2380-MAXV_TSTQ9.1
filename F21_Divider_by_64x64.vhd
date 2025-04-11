-- ============================================================================
-- Fichier     : F21_Divider_by_64x64.vhd
-- Fonction    : Diviseur de fr�quence par 64 et 64x64 (4096)
-- Description : Produit deux signaux clk_out dont la fr�quence est clk/64 et clk/4096 
--               Le signal clk_out est une onde carr�e avec un rapport cyclique de 50%.
-- Auteur      : O.N
-- Date        : 11/04/2025
-- take 14 LE
-- ============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity F21_Divider_by_64x64 is
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        clk_d64   : out STD_LOGIC;
        clk_d4096 : out STD_LOGIC

    );
end F21_Divider_by_64x64;

architecture Behavioral of F21_Divider_by_64x64 is
    signal compteur1 : unsigned(4 downto 0) := (others => '0');  -- 6 bits
    signal compteur2 : unsigned(4 downto 0) := (others => '0');  -- 6 bits
    signal clk_div1  : STD_LOGIC := '0';
    signal clk_div2  : STD_LOGIC := '0';

begin

    process(clk, rst)
    begin
        if rst = '1' then
            compteur1 <= (others => '0');
            clk_div1  <= '0';
        elsif rising_edge(clk) then
            compteur1 <= compteur1 + 1;
            if compteur1 = 31 then   -- bascule tous les 32 cycles
                clk_div1 <= not clk_div1;
            end if;
        end if;
    end process;

    clk_d64 <= clk_div1;

     process(clk_div1, rst)
    begin
        if rst = '1' then
            compteur2 <= (others => '0');
            clk_div2  <= '0';
        elsif rising_edge(clk_div1) then
            compteur2 <= compteur2 + 1;
            if compteur2 = 31 then   -- bascule tous les 32 cycles
                clk_div2 <= not clk_div2;
            end if;
        end if;
    end process;

    clk_d4096 <= clk_div2;

end Behavioral;
