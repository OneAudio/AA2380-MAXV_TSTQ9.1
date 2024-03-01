--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- O.N - 27/02/2024
-- take 13 LE
-- 
-- 
--------------------------------------------------------------------------------
-- NOTES sur les différents signaux d'horloges nécessaires :
--
-- RANGE of clocks:
-- Fso (kHz)     : 12,24,48,96,192,384,768,1536k
-- Fsox128 (MHz) : 1.536,3.072,6.144,12.288,24.576
-- NOTE: No clock if OutOfRange is active.
--
--
-- VERSION SANS CLOCK ENABLE POUR COMPARAISON
--
--------------------------------------------------------------------------------
library  IEEE;
use  IEEE.STD_LOGIC_1164.ALL;
use  ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity  F0_NOClockEnable  is
port(
    CK98M304     :	in  std_logic   ;  -- Master input clock (98.304MHz)
    -- 128xFso clock (BCK)
    CK24M576      :	out std_logic   ;  --  kHz clock
    CK12M288      :	out std_logic   ;  --  kHz clock 
    CK06M144      :	out std_logic   ;  --  kHz clock 
    CK03M072      :	out std_logic   ;  --  kHz clock 
    CK01536K      :	out std_logic   ;  --  kHz clock
    -- Fso clock (LRCK)
    CK00768K      :	out std_logic   ;  --  kHz clock 
    CK00384K      :	out std_logic   ;  --  kHz clock 
    CK00192K      :	out std_logic   ;  --  kHz clock 
    CK00096K      :	out std_logic   ;  --  kHz clock  
    CK00048K      :	out std_logic   ;  --  kHz clock  
    CK00024K      :	out std_logic   ;  --  kHz clock  
    CK00012K      :	out std_logic      --  kHz clock 
    );
end  F0_NOClockEnable;


ARCHITECTURE DESCRIPTION OF F0_NOClockEnable IS

signal MCLK_divider : unsigned (12 downto 0)    ; -- counter for clock divivier. Allow down to 12kHz clock (from 98.304M)


begin

MCLK_div : process(CK98M304,MCLK_divider)
begin
    if rising_edge(CK98M304)  then
        MCLK_divider <= MCLK_divider + 1 ; -- increment MCLK_divider counter
    end if;

CK24M576 <= MCLK_divider(1);
CK12M288 <= MCLK_divider(2);
CK06M144 <= MCLK_divider(3);
CK03M072 <= MCLK_divider(4);
CK01536K <= MCLK_divider(5);
-- 
CK00768K <= MCLK_divider(6);
CK00384K <= MCLK_divider(7);
CK00192K <= MCLK_divider(8);
CK00096K <= MCLK_divider(9);
CK00048K <= MCLK_divider(10);
CK00024K <= MCLK_divider(11);
CK00012K <= MCLK_divider(12);

end process MCLK_div ;

END DESCRIPTION;