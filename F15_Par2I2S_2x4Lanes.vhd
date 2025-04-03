-----------------------------------------------------------------
-- AA2380V1 OSVA PROJECT.
-- Date: 25/03/2025	Designer: O.N
-----------------------------------------------------------------
-- Intel MAXV 5M570 CPLD	Take 51 LE.
-- Function F5 :  F5_Parr_to_I2S.vhd
-- 
-- Parrallel to I2S generator
-- From Philips semiconductor "I2S bus specification" document.
------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity F15_Par2I2S_2x4Lanes is
--
port(
	-- INPUTS
	MCLK		: in  std_logic ; -- main clock 64FS
	LRCK		: in  std_logic ; -- Output sampling rate clock
	DATAL		: in  std_logic_vector(23 downto 0) ; -- Left channel parallel data in
	DATAR		: in  std_logic_vector(23 downto 0) ; -- Right channel parallel data in
	-- OUTPUTS
	I2S_LRCK		: out  std_logic ; -- I2S Left/Right clock
	I2S_BCLK		: out  std_logic ; -- I2S bit clock 
	I2S4L_SDATAL		: out  std_logic_vector(3 downto 0);   -- I2S data 4 lanes
	I2S4L_SDATAR		: out  std_logic_vector(3 downto 0);   -- I2S data 4 lanes
	LOADSR_test			: out  std_logic;
	LR_SELECT_test 	: out  std_logic;
	OREX_test		: out  std_logic
);
 
end F15_Par2I2S_2x4Lanes;

architecture Behavioral of F15_Par2I2S_2x4Lanes is

signal	LR_SELECT	: std_logic  ; -- Left/Right data selection bit
signal	OREX		: std_logic  ; -- xor bit
signal	LOADSR		: std_logic  ; -- shift register load signal
signal  SR_DATA		: std_logic_vector(23 downto 0)  ; -- Data to be shifted
signal  Lshift		: std_logic_vector(23 downto 0)  ; -- shift register output
signal  Rshift		: std_logic_vector(23 downto 0)  ; -- shift register output

begin

LOADSR_test <= LOADSR;
LR_SELECT_test <=LR_SELECT;
OREX_test <= OREX;
------------------------------------------------------------------
-- Generate I2s control signal for shift register 
------------------------------------------------------------------

I2S_LRCK <= LRCK 	; -- send LRCK to I2S_LRCK
I2S_BCLK <= MCLK	; -- I2S Bit clock is equal to 64xFS

process (MCLK,LR_SELECT,OREX)	is
begin
	-- synchronize to 64FS
	if 	rising_edge(MCLK)	then
		LR_SELECT	<= LRCK		;
		OREX		<= LR_SELECT;
	end if;
	-- Generate load pulse
	LOADSR <= not(OREX) and LR_SELECT ; -- generate load signal of shift register
	-- MUX of Left/Right data

end process;
	
--------------------------------------------------------------------------------
-- shift of data 
--------------------------------------------------------------------------------
process (MCLK)
begin
	-- Shift are made on each falling_edge of 64FS clock
    if falling_edge(MCLK) then
        if  LOADSR='1' then
            Lshift  <= DATAL ; -- load Left channel data to be transmitted
			Rshift  <= DATAR ; -- load Right channel data to be transmitted
        else
            Lshift  <= Lshift(19 downto 0) & "0000" ;-- shift data
			Rshift  <= Rshift(19 downto 0) & "0000" ;-- shift data
        end if;
    end if;
end process;
I2S4L_SDATAL <= Lshift(23 downto 20); -- MSB of shift register is serial data out
I2S4L_SDATAR <= Rshift(23 downto 20); -- MSB of shift register is serial data out	

end architecture ;














