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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.lfsr_pkg.ALL; 

entity F0_NCO_dithered is
    Port ( 
        clk         : in std_logic;  -- Horloge 24.576 MHz
        rst         : in std_logic;  -- Reset asynchrone
        en_Dither   : in std_logic;-- enable dithering noise output
        DithVal 	: in integer range 0 to 3; --effective dither bits (range 0 to 7)
        phase_inc   : in unsigned(11 downto 0);  -- Incrément de phase 12 bits (375 Hz à 1536 kHz)
        phase_lut   : out unsigned(6 downto 0);  -- Index LUT (7 bits)
        -- test outputs
        dither_in    	: buffer signed(3 downto 0); --
        DitherNoise24	: out 	signed(23 downto 0) --Dither noise output (signed 24 bits)
        
    );
end F0_NCO_dithered;

architecture Behavioral of F0_NCO_dithered is
    signal phase_acc       : signed(19 downto 0) := (others => '0');  -- Accumulateur de phase 24 bits
    signal dither_ext      : signed(19 downto 0);  -- Dither étendu
    signal phase_with_dith : signed(19 downto 0);  -- Phase avec dither
    signal phase_inc_ext   : signed(19 downto 0);  -- Phase_inc étendu avec échelle
    --signal dither_in       : signed(3 downto 0); 

begin

--- LFSR noise generator for dithering
process(clk,DithVal,en_Dither,dither_in)
-- variable for lfsr
--variable 	rand_temp 		: std_logic_vector (23 downto 0):=(0 => '1',others => '0');
variable rand_temp : std_logic_vector (23 downto 0) := (others => '1');

variable 	temp 			: std_logic := '0';
begin
---------------------------------------------------------------------------------
----- LFSR Generation (use work.lfsr package !)
---------------------------------------------------------------------------------
if(rising_edge(clk)) then
	--
	--rand_temp := x"111111"; -- shift register of lfsr is initialized with all "1"
		--
	temp := xor_gates(rand_temp);
	rand_temp(23 downto 1) := rand_temp(22 downto 0);
	rand_temp(0) := temp;
	--
end if;

-- Keep 4 bits random value register.
-- The random value is shifted to the Set_Dither value to keep only the desired number of output dither bit.
-- The random_out register is signed and the MSB is always the sign.
	if 	en_Dither='1'	then
		dither_in <= shift_right(signed(rand_temp(3 downto 0)),(3-DithVal));
	else
		-- No dither noise if Set_Dither=0
		dither_in <= x"0"; -- set to 0 when en_Dither value is 0
	end if;

-- décalage de 8 bits du dither et passage sur 20 bits avant ajout dans l'accumulateur de phase.
dither_ext <= resize((dither_in & x"00"),20);--
-- resize with sign extension
DitherNoise24 <= resize(dither_in, 24); -- resizing before addition to keep sign.
end process;


-- Extension de phase_inc et multiplication par 16 (décalage de 4 bits)
-- pour obtenir les bonnes fréquences mini/maxi d'incrément.
phase_inc_ext <= "0000" & signed(phase_inc) & x"0" ; --   
	  
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
