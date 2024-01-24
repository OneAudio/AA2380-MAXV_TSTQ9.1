--------------------------------------------------------------------------------
-- O.N - 07/05/20	********EPSUX3V2***********
-- take XX LE		-- New function for individual channel on/off operation --
--  NOT TESTED !!
-- This function generate individual bit to switch on/off each outputs of then
-- PSU (each PCB). 
-- It generate also a muxed enable "EN_CH1_SYNC" synch to CN word.
-- This allow to set all OFF channels to zero setting and to display
-- dimmed setting value instead.
--
-- NOTE : that individual on/off setting must be disable in serial/parallel modes.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

 entity EnablePowerX3_V0 is
    Port (
        CN				: in  std_logic_vector (2 downto 0) ; -- Channel selection word
		DBL_PUSH		: in  std_logic_vector (2 downto 0) ; -- Toggled double push encoder bits		  
		ENABLE_PW 		: in  std_logic ; -- MAster ENable Power front panel switch
		EN_POWER_CH1	: out std_logic ; -- Bit to enable CH1 output board (hardware enable)
		EN_POWER_CH2	: out std_logic ; -- Bit to enable CH2 output board (hardware enable)
		EN_POWER_CH3	: out std_logic ; -- Bit to enable CH3 output board (hardware enable)
		EN_CH1_SYNC		: out std_logic ; -- Channels enable bit muxed with CN.
		
		--TEST OUTPUTS
          
    );
 end EnablePowerX3_V0;

architecture behavorial of EnablePowerX3_V0 is

begin
--------------------------------------------------------
-- Table of CN values vs channel selection (4 bits wide)
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
-- CN0  --> Voltage DAC channel * Right  display slave 2
-- CN1  --> Voltage DAC channel * Middle display slave 1
-- CN2  --> Voltage DAC channel * LEFT   display MASTER
-- CN3  --> Current DAC channel * Right  display slave 2
-- CN4  --> Current DAC channel * Middle display slave 1
-- CN5  --> Current DAC channel * LEFT   display MASTER  
-- CN6  --> Voltage ADC channel * Right  display slave 2 
-- CN7  --> Voltage ADC channel * Middle display slave 1
-- CN8  --> Voltage ADC channel * LEFT   display MASTER  
-- CN9  --> Current ADC channel * Right  display slave 2 
-- CN10 --> Current ADC channel * Middle display slave 1
-- CN11 --> Current ADC channel * LEFT   display MASTER 
--------------------------------------------------------------------------------

process (DBL_PUSH,ENABLE_PW) is
begin
	if ENABLE_PW = '1'	then
	-- Harware enable with each button encoder double-push 
	EN_POWER_CH1	<= DBL_PUSH(0) ; --Enable CH1
	EN_POWER_CH2	<= DBL_PUSH(1) ;
	EN_POWER_CH3	<= DBL_PUSH(2) ;
	else
	EN_POWER_CH1	<= '0' ; --Disable  CH1
	EN_POWER_CH2	<= '0' ; --Disable  CH2
	EN_POWER_CH3	<= '0' ; --Disable  CH3
	end if;
end process;


process (CN,DBL_PUSH,ENABLE_PW) is
begin
	case CN is
	when '000'	=> EN_CH1_SYNC <= EN_POWER_CH1 ;
	when '001'	=> EN_CH1_SYNC <= EN_POWER_CH2 ;
	when '010'	=> EN_CH1_SYNC <= EN_POWER_CH3 ;	
	when '011'	=> EN_CH1_SYNC <= '0' ;
	end case;
end process;

end architecture;








