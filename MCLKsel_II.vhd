-----------------------------------------------------------------
-- OnE Audio Projects
-- O.N - 14/02/2025
-- take 4 LE
--
-- MCLK selection with  divider by 2 or 6 of internal MCLK
-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

 entity MCLKsel_II is
    Port (
          MCLK_49M152  : in  std_logic; -- 49.152 MHz on board MCLK  for 48/96/192/384Hz sampling rates
          MCLK_EXT     : in  std_logic; -- external input MCLK
          SEL_DIV3	   : in  std_logic; -- enable on-board MCLK divider (0->:2 , 1->:6)
          SEL_EXT	   : in  std_logic; -- MCLK source selection (0= internal, 1= external)
          MCLKO        : out  std_logic -- MCLK output 
    );
 end MCLKsel_II;

architecture MCLKselect of MCLKsel_II is

signal count : integer range 0 to 2:=0 ; -- Compteur de 2 bits
signal MCLKDIV : std_logic;


begin
----------------------------------------------------------------------
--  MCLK selection and divide by 2 or 6 the MCLKDIV signal
----------------------------------------------------------------------
process(SEL_EXT,MCLKDIV,MCLK_EXT)
begin
    --
    if  SEL_EXT ='0' then
        MCLKO  <= MCLKDIV   ;
    else
        MCLKO  <= MCLK_EXT  ;

    end if;
end process ;

process(SEL_DIV3,count,MCLK_49M152)
    begin
        if rising_edge(MCLK_49M152) then
            if SEL_DIV3 = '0' then
                -- Diviser par 2
                MCLKDIV <= not MCLKDIV; -- Inverse la sortie pour obtenir une fréquence divisée par 2
            else
                -- Diviser par 3
                if count = 2 then -- 2 en binaire
                    count <= 0 ;
                    MCLKDIV <= not MCLKDIV; -- Inverse la sortie pour obtenir une fréquence divisée par 3
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;
end architecture MCLKselect ;
