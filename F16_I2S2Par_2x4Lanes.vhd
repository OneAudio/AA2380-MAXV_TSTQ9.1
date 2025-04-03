-----------------------------------------------------------------
-- AA2380V1 OSVA PROJECT.
-- Date: 25/03/2025	Designer: O.N
-----------------------------------------------------------------
-- Intel MAXV 5M570 CPLD	Take 108 LE.
-- Function F16 :  F16_I2S2Par_2x4Lanes.vhd
-- 
-- 2x4 Lanes serial Parrallel to  interface
------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity F16_I2S2Par_2x4Lanes is
--
port(
	-- INPUTS
	MCLKI		: in  std_logic ; --main fast clock
	CLK8FS		: in  std_logic ; -- main clock 8FS
	LRCK		: in  std_logic ; -- Output sampling rate clock
	SDATA4L		: in  std_logic_vector(3 downto 0);   -- I2S data 4 lanes
	SDATA4R		: in  std_logic_vector(3 downto 0);   -- I2S data 4 lanes
	
	-- OUTPUTS
	DATAL		: out  std_logic_vector(23 downto 0) ; -- Left channel parallel data in
	DATAR		: out  std_logic_vector(23 downto 0) ; -- Right channel parallel data in
	-- I2S_LRCK	: out  std_logic ; -- I2S Left/Right clock
	-- I2S_BCLK	: out  std_logic ; -- I2S bit clock 
	
	Synchpulse	: buffer  std_logic
	-- LRCKd1_test : out  std_logic ;
	-- LRCKd2_test : out  std_logic 
);
 
end F16_I2S2Par_2x4Lanes;

architecture Behavioral of F16_I2S2Par_2x4Lanes is

signal  SR_DATA		: std_logic_vector(23 downto 0)  ; -- Data to be shifted
signal  Lshift		: std_logic_vector(23 downto 0)  ; -- shift register output
signal  Rshift		: std_logic_vector(23 downto 0)  ; -- shift register output
signal counter		: integer range  0 to 7;

-- signal Synchpulse	: std_logic  ;
signal LRCKd1		: std_logic  := '0'  ;
signal LRCKd2		: std_logic  := '0'  ;

begin


-- I2S_LRCK <= LRCK 	; -- send LRCK to I2S_LRCK
-- I2S_BCLK <= CLK8FS	; -- I2S Bit clock is equal to 64xFS
-- LRCKd1_test <=  LRCKd1;
-- LRCKd2_test <=  LRCKd2;
------------------------------------------------------------------
-- Generate I2s control signal for shift register 
------------------------------------------------------------------
process (MCLKI,LRCKd1,LRCKd2,LRCK)	is
begin
	-- 
	if 	rising_edge(MCLKI)	then
		LRCKd1 <= LRCK ;
		LRCKd2 <= LRCKd1;
	end if;
	Synchpulse <= LRCK and not(LRCKd2);
end process;
	
--------------------------------------------------------------------------------
-- shift of data 
--------------------------------------------------------------------------------
process (CLK8FS,Synchpulse,Lshift,Rshift)
begin
	-- Shift are made on each falling_edge of 64FS cloc
    if  Synchpulse='1' then
            DATAL  <= Lshift ; -- load Left channel data to be transmitted
			DATAR  <= Rshift ; -- load Right channel data to be transmitted
			counter <= 0 ; --reset
    elsif rising_edge(CLK8FS) then
		counter <= counter+1 ;
		case counter is
			when 0 => Lshift(23 downto 20) <= SDATA4L ;
					  Rshift(23 downto 20) <= SDATA4R ;
			when 1 => Lshift(19 downto 16) <= SDATA4L ;
					  Rshift(19 downto 16) <= SDATA4R ;
			when 2 => Lshift(15 downto 12) <= SDATA4L ;
					  Rshift(15 downto 12) <= SDATA4R ;
			when 3 => Lshift(11 downto 8)  <= SDATA4L ;
					  Rshift(11 downto 8)  <= SDATA4R ;
			when 4 => Lshift(7 downto 4) <= SDATA4L ;
					  Rshift(7 downto 4) <= SDATA4R ;
			when 5 => Lshift(3 downto 0) <= SDATA4L ;
					  Rshift(3 downto 0) <= SDATA4R ;
			when others => null ;
		end case;
	end if;
end process;


end architecture ;














