--------------------------------------------------------------------
-- ON le 27/08/2019 -- AA2380 OSVA analyzer
--------------------------------------------------------------------
-- Intel MAXV 5M570 CPLD	Take xx LE.
-- Function F11 :  F11_USBstreamer.vhd
--------------------------------------------------------------------
-- Link module to send data to USBstreamer board (from miniDSP).
-- Note: Module is also compatible with the new MCH-Streamer that support
-- higher sampling rate (I2S 384kHZ/32bits) and Linux support.
--
--
--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity F11_USBstreamer is
Port (
	-- INPUTS
	MCLKI		:in			std_logic ; -- Audio Master clock (slave mode)
	BCLKI		:in			std_logic ; -- I2S bit clock (slave mode)
	LRCKI		:in			std_logic ; -- I2S  Left/Right clock (slave mode)
	PLL_SYNC	:in			std_logic ; -- USB streamer 300Hz locked PLL indicator
	
	-- OUTPUTS
	I2S_DATA1	:out		STD_LOGIC ;-- stereo I2S data output 1/4, SR = 192kHz max
	I2S_DATA2	:out		STD_LOGIC ;-- stereo I2S data output 2/4, SR = 192kHz max
	I2S_DATA3	:out		STD_LOGIC ;-- stereo I2S data output 2/4, SR = 192kHz max
	I2S_DATA4	:out		STD_LOGIC ;-- stereo I2S data output 4/4, SR = 192kHz max
	MCLK0		:out		STD_LOGIC  -- Audio Master clock 
	
);
end F11_USBstreamer;

architecture Behavioral of F11_USBstreamer is




begin


process ()
begin
	
	
	
end process;


end Behavioral;
