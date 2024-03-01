--------------------------------------------------------------------------------
-- Ressource : -- https://www.fpga4student.com/2017/08/how-to-generate-clock-enable-signal.html
-- fpga4student.com: FPGA projects, Verilog projects, VHDL projects,
-- Generate clock enable signal instead of creating another clock domain
-- Assume that the input clock : CK98M304
--------------------------------------------------------------------------------
-- O.N - 27/02/2024 -- take ??? LE
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
library  IEEE;
use  IEEE.STD_LOGIC_1164.ALL;
use  ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity  F0_ClockEnable_BETA1  is
port(
    CK98M304      :	in  std_logic   ;          -- Main input clock (98.304MHz)  
    -- -- 128xFso clock (BCK)
    CK24M576      :	out std_logic   ;  --  kHz clock
    CK12M288      :	out std_logic   ;  --  kHz clock 
    CK06M144      :	out std_logic   ;  --  kHz clock 
    CK03M072      :	out std_logic   ;  --  kHz clock 
    CK01536K      :	out std_logic   ;  --  kHz clock
    -- -- Fso clock (LRCK)
    CK00768K      :	out std_logic   ;  --  kHz clock 
    CK00384K      :	out std_logic   ;  --  kHz clock 
    CK00192K      :	out std_logic   ;  --  kHz clock 
    CK00096K      :	out std_logic   ;  --  kHz clock  
    CK00048K      :	out std_logic   ;  --  kHz clock  
    CK00024K      :	out std_logic   ;  --  kHz clock  
    CK00012K      :	out std_logic      --  kHz clock
    );
end  F0_ClockEnable_BETA1;

ARCHITECTURE DESCRIPTION OF F0_ClockEnable_BETA1 IS

signal   counter1     : integer range 0 to 3    ;
signal   counter2     : integer range 0 to 7    ;
signal   counter3     : integer range 0 to 15   ;
signal   counter4     : integer range 0 to 31   ;
signal   counter5     : integer range 0 to 63   ;
signal   counter6     : integer range 0 to 127  ;
signal   counter7     : integer range 0 to 255  ;
signal   counter8     : integer range 0 to 511  ;
signal   counter9     : integer range 0 to 1023 ;
signal   counter10    : integer range 0 to 2047 ;
signal   counter11    : integer range 0 to 4095 ;
signal   counter12    : integer range 0 to 8191 ;
signal   clken1       : std_logic;
signal   clken2       : std_logic;
signal   clken3       : std_logic;
signal   clken4       : std_logic;
signal   clken5       : std_logic;
signal   clken6       : std_logic;
signal   clken7       : std_logic;
signal   clken8       : std_logic;
signal   clken9       : std_logic;
signal   clken10      : std_logic;
signal   clken11      : std_logic;
signal   clken12      : std_logic;


begin

------------------------------------------------------------------
--
------------------------------------------------------------------
process(CK98M304)
begin
  if(rising_edge(CK98M304)) then
    --
    if(counter1 =3 ) then
      clken1 <= '1';
      counter1 <= 0 ;
    else
      clken1 <= '0';
      counter1 <= counter1 + 1 ;
    end if;
    --
    if(counter2 =7 ) then
      clken2 <= '1';
      counter2 <= 0 ;
    else
      clken2 <= '0';
      counter2 <= counter2 + 1 ;
    end if;
    --
    if(counter3 =15 ) then
      clken3 <= '1';
      counter3 <= 0 ;
    else
      clken3 <= '0';
      counter3 <= counter3 + 1 ;
    end if;
    --
    if(counter4 =31 ) then
      clken4 <= '1';
      counter4 <= 0 ;
    else
      clken4 <= '0';
      counter4 <= counter4 + 1 ;
    end if;
    --
    if(counter5 =63 ) then
      clken5 <= '1';
      counter5 <= 0 ;
    else
      clken5 <= '0';
      counter5 <= counter5 + 1 ;
    end if;
    --
    if(counter6 =127 ) then
      clken6 <= '1';
      counter6 <= 0 ;
    else
      clken6 <= '0';
      counter6 <= counter6 + 1 ;
    end if;
    --
    if(counter7 =255 ) then
      clken7 <= '1';
      counter7 <= 0 ;
    else
      clken7 <= '0';
      counter7 <= counter7 + 1 ;
    end if;
    --
    if(counter8 =511 ) then
      clken8 <= '1';
      counter8 <= 0 ;
    else
      clken8 <= '0';
      counter8 <= counter8 + 1 ;
    end if;
    --
    if(counter9 =1023 ) then
      clken9 <= '1';
      counter9 <= 0 ;
    else
      clken9 <= '0';
      counter9 <= counter9 + 1 ;
    end if;
    --
    if(counter10 =2047 ) then
      clken10 <= '1';
      counter10 <= 0 ;
    else
      clken10 <= '0';
      counter10 <= counter10 + 1 ;
    end if;
    --
    if(counter11 =4095 ) then
      clken11 <= '1';
      counter11 <= 0 ;
    else
      clken11 <= '0';
      counter11 <= counter11 + 1 ;
    end if;
    --
    if(counter12 =8191 ) then
      clken12 <= '1';
      counter12 <= 0 ;
    else
      clken12 <= '0';
      counter12 <= counter12 + 1 ;
    end if;
  end if;
end process;

------------------------------------------------------------------
-- Use the same clock and the slow clock enable signal above 
-- to drive another part of the design to avoid domain crossing issues
------------------------------------------------------------------
process(CK98M304)
begin
  if(rising_edge(CK98M304)) then
  --
    if(clken1 = '1') then
        CK24M576 <= '1'; --
    else
        CK24M576 <= '0'; --
    end if;
    --
    if(clken2 = '1') then
        CK12M288 <= '1'; --
    else
        CK12M288 <= '0'; --
    end if;
    --
    if(clken3 = '1') then
        CK06M144 <= '1'; --
    else
        CK06M144 <= '0'; --
    end if;
    --
    if(clken4 = '1') then
        CK03M072 <= '1'; --
    else
        CK03M072 <= '0'; --
    end if;
    --
    if(clken5 = '1') then
        CK01536K <= '1'; --
    else
        CK01536K <= '0'; --
    end if;
    --
    if(clken6 = '1') then
        CK00768K <= '1'; --
    else
        CK00768K <= '0'; --
    end if;
    --
    if(clken7 = '1') then
        CK00384K <= '1'; --
    else
        CK00384K <= '0'; --
    end if;
    --
    if(clken8 = '1') then
        CK00192K <= '1'; --
    else
        CK00192K <= '0'; --
    end if;
    --
    if(clken9 = '1') then
        CK00096K <= '1'; --
    else
        CK00096K <= '0'; --
    end if;
    --
    if(clken10 = '1') then
        CK00048K <= '1'; --
    else
        CK00048K <= '0'; --
    end if;
    --
    if(clken11 = '1') then
        CK00024K <= '1'; --
    else
        CK00024K <= '0'; --
    end if;
    --
    if(clken12 = '1') then
        CK00012K <= '1'; --
    else
        CK00012K <= '0'; --
    end if;
  end if;
end process;


END DESCRIPTION;