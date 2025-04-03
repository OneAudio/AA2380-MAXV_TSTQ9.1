----------------------------------------------------------------------------
---- 07/28/2010  Author(s):Vipin Lal, lalnitt@gmail.com 				----		
---- Design Name: lfsr													----				
---- Project Name: lfsr_randgen										   	----	
---- Description: 														----	
----  A random number generator based on linear feedback shift         	----
----  register(LFSR).A LFSR is a shift register whose input bit is a    ----
----  linear function of its previous state.The detailed documentation  ----	
----  is available in the file named manual.pdf.   						----	
---- This file is a part of the lfsr_randgen project at                 ----
---- http://www.opencores.org/						                    ----
----------------------------------------------------------------------------
--- Modified by ON the 22/06/17											----
--- output is now signed 2's complement.								----
----------------------------------------------------------------------------
---- Modified by ON the 05/03/2025 - take 36LE							----
---- 																	----
---- LFSR of 24bits length,												----
---- Here, the amount of noise is controlled by register Set_Dither.	----
---- It's value can be from 0 to 3 (2bits) in order to add 0 to 4 LSB   ----
---- of noise															----
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.lfsr_pkg.ALL; 

entity lfsr_IV is
   
port (	
	CLOCK 			: in 	std_logic;-- LFSR clock input
	set_seed 		: in 	std_logic;-- synchronous seed init input
	seed 			: in 	std_logic_vector(23 downto 0); --seed data word (must be not all 0 !)
	en_Dither		: in 	std_logic;-- enable dithering noise output
	Set_Dither		: in 	integer range 0 to 3; --effective dither bits (range 0 to 7)
   DitherNoise 	: buffer signed(3 downto 0); -- Dither noise output (signed 8 bits)
	DitherNoise24	: out 	signed(23 downto 0) --Dither noise output (signed 24 bits)
	--test outputs
    --
	);
end lfsr_IV;

architecture Behavioral of lfsr_IV is

begin

process(CLOCK,Set_Dither,DitherNoise,en_Dither)

-- variable for lfsr
variable 	rand_temp 		: std_logic_vector (23 downto 0):=(0 => '1',others => '0');
variable 	temp 			: std_logic := '0';

begin
---------------------------------------------------------------------------------
----- LFSR Generation (use work.lfsr package)
---------------------------------------------------------------------------------
if(rising_edge(CLOCK)) then
	--
	if(set_seed = '1') then
	rand_temp := seed; -- synchronous load of seed input value.
	end if;
	--
	temp := xor_gates(rand_temp);
	rand_temp(23 downto 1) := rand_temp(22 downto 0);
	rand_temp(0) := temp;
	--
end if;

-- Keep 8 bits random value register.
-- The random value is shifted to the Set_Dither value to keep only
-- the desired number of output dither bit.
-- The random_out register is signed and the MSB is always the sign.
	if 	en_Dither='1'	then
		DitherNoise <= shift_right(signed(rand_temp(3 downto 0)),(3-Set_Dither));
	else
		-- No dither noise if Set_Dither=0
		DitherNoise <= x"0"; -- set to 0 when en_Dither value is 0
	end if;
-- resize with sign extension
DitherNoise24 <= resize(DitherNoise, 24); -- resizing before addition to keep sign.


end process;

end Behavioral;

