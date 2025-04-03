--------------------------------------------
-- ON le 05/03/2025  - Size: 35 LE
-- NCO module with dither input
--
-- Parameters :
----------------
-- Input main clock frequency : 24.576 MHz
-- LUT address width : 7 bits
-- Phase accumulator width : 20 bits
-- Phase increment resolution : 375 Hz  (=>Fmini)
-- Maximum NCO frequency : 1 536 000 Hz (=>Fmaxi)
-- Phase increment width : 12 bits
-- Dither input width : 4 bits signed (+7/-8)
-- 
----------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity F0_NCO is
    Port ( 
        clk        : in  std_logic;  -- Horloge 24.576 MHz
        rst        : in  std_logic;  -- Reset asynchrone
        phase_inc  : in  unsigned(11 downto 0);  -- Incrément de phase 12 bits (375 Hz à 1536 kHz)
        dither_in  : in  signed(3 downto 0);  -- Entrée externe du dither (4 bits signés)
        phase_lut  : out unsigned(6 downto 0)  -- Index LUT (7 bits)
        -- test outputs
        -- dither_ext_test : out signed(19 downto 0);
        -- phase_acc_test  : out unsigned(19 downto 0)
    );
end F0_NCO;

architecture Behavioral of F0_NCO is
    signal phase_acc       : signed(19 downto 0) := (others => '0');  -- Accumulateur de phase 24 bits
    signal dither_ext      : signed(19 downto 0);  -- Dither étendu
    signal phase_with_dith : signed(19 downto 0);  -- Phase avec dither
    signal phase_inc_ext   : signed(19 downto 0);  -- Phase_inc étendu avec échelle

begin

-- Extension de phase_inc et multiplication par 16 (décalage de 4 bits)
-- pour obtenir les bonnes fréquences mini/maxi d'incrément.
phase_inc_ext <= "0000" & signed(phase_inc) & x"0" ; --   
	  
-- décalage de 8 bits du dither et passage sur 20 bits avant ajout dans l'accumulateur de phase.
dither_ext <= resize((dither_in & x"00"),20);--
	  
-- Accumulateur de phase synchrone (avec phase_inc ajusté)
process(clk, rst)
begin
    if rst = '1' then
        phase_acc <= (others => '0');
    elsif rising_edge(clk) then
        phase_acc       <= phase_acc + phase_inc_ext ;  -- Incrément ajusté
        --dither_ext    <= resize(dither_in, 24) ;  -- 
        phase_with_dith <= phase_acc + dither_ext; --ajout du dither
        phase_lut      <= unsigned(phase_with_dith(19 downto 13));  -- troncation des 7 MSB pour l'index de la LUT
    end if;
end process;

end Behavioral;
