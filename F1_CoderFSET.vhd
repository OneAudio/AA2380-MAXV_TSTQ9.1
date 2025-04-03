-----------------------------------------------------------------
-- ON le 06/03/2025   -- 
-- Rotary encoder with push button function
-- 
-- Allow to adjust the NCO output frequency 
-- tested with I2S interface and FFT software
-- 
------------------------------------------------------------------
-- Take 100 LE 
-- 12 bits output wide counter increment size.
-- Number of count/coder crank can be set by short press of 
-- push-buttom in step of : 
-- 1 (375Hz) - 4 (1500Hz) - 16(6000Hz) - 64(24kHz)  
-- A long push (1s) intitiate a NCO reset.
-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
 
 entity F1_CoderFSET is

Port ( 
           clk    : in  std_logic; -- input clock 24.576MHz
           Ta	  : in  std_logic; -- encoder track a input
           Tb	  : in  std_logic; -- encoder track b input
           push   : in  std_logic; -- encoder push switch input
           RAZ    : out std_logic; -- reset output with push button
           NCO    : out std_logic_vector (11 downto 0); -- NCO step output word
          --TEST OUTPUTS
          clkslowo : out std_logic; -- 3kHz LF clock
          short    : out std_logic
           ); 
 end F1_CoderFSET;
 
architecture select_mode of F1_CoderFSET is
  
  signal clkslow        : STD_LOGIC  ; -- low frequency clock for filtering
  signal countA         : integer range 0 to 4095 ; -- counter of frequency divider (24.576M/(2*4096)= 3 kHz)
  signal rotary_in      : STD_LOGIC_vector (1 downto 0)  ; -- Vector of the two encoder tracks
  signal delay_rotary_q1: STD_LOGIC  ; --
  signal Dir            : STD_LOGIC  ; -- push button press for more than 1s.
  signal Rotate         : STD_LOGIC  ; -- pulse output of encoder

  signal StepSize       :integer range 1 to 64 ; -- number count by encoder inrcement (in LSB) 
  signal Stepsizecount  : integer range 0 to 3;
    
  signal NCOcount       : integer range 0 to 4095  := 1 ; -- NCO counter

  signal counter        : integer range 0 to 2047 := 0;
  signal pulse_long      : STD_LOGIC := '0';
  signal pulse_short     : STD_LOGIC := '0';
   
begin



-----------------------------------------------------------------
-- Generate low frequency clock "clkslow"
-- invert clockslow each 4096 count to get 3kHz output with 24.576M clk
-----------------------------------------------------------------
process (clk)
begin 
--Clockslow <= clkslow ; -- output the 375Hz clock
    if  rising_edge(clk) then
        countA <= countA +1 ; 
        if  countA = 4095 then  -- normal value is 250000 !
            clkslow <= not clkslow ; -- invert clkslow each half period
        end if;
    end if;
end process;

clkslowo <= clkslow;

----------------------------------------------------------
-- Long and short push detection for NCO reset and NCO step increment
-- Long push is > 680 ms.
-- short push must be > 43 ms
---------------------------------------------------------
process(clkslow)
begin
        if rising_edge(clkslow) then
            if push = '1' then
                --
                if counter = 128 then
                    pulse_short <= '1';
                else
                    pulse_short <= '0';
                end if;
                --
                if counter < 2047 then
                    counter <= counter + 1;
                end if;
                if counter = 2047-1 then
                    pulse_long <= '1';
                else
                    pulse_long <= '0';
                end if;
            else
                counter   <=  0 ;
                pulse_long <= '0';
                pulse_short <= '0';
            end if;
        end if;
    end process;

RAZ <= pulse_long; -- reset pulse output
short <= pulse_short; -- reset pulse output

----------------------------------------------------------
-- New rotary encoder function from Xilinx app note
-- (Works fine !)
----------------------------------------------------------
rotary_filter: process(clkslow)
begin
  if clkslow'event and clkslow='1' then
      rotary_in <= Ta & Tb;
  case rotary_in is
    when "00" =>  Rotate <= '0';         
                  Dir <= Dir;
    when "01" =>  Rotate <= Rotate;
                  Dir <= '0';
    when "10" =>  Rotate <= Rotate;
                  Dir <= '1';
    when "11" =>  Rotate <= '1';
                  Dir <= Dir; 
    when others => Rotate <= Rotate; 
                  Dir <= Dir; 
  end case;
end if;
end process rotary_filter;

-- TestP <= Rotate ;
-- TestD <= Dir ;
 ----------------------------------------------------------
-- Increment step size bewtween 4 values (1-4-16 or 64)
-- at each short push.
----------------------------------------------------------
process (pulse_short,pulse_long,Stepsize,Stepsizecount)
begin
    if    pulse_long='1'   then
          Stepsizecount <= 0;
    elsif rising_edge(pulse_short) then
          Stepsizecount <= Stepsizecount+1;
    end if;
    case  Stepsizecount is
        when 0 => Stepsize <= 1 ;
        when 1 => Stepsize <= 4 ;
        when 2 => Stepsize <= 16 ;
        when 3 => Stepsize <= 64 ;
    end case;
end process;
 ----------------------------------------------------------
-- Increment or decrement NCO counter with encoder
-- step is defined by Stepsize value.
----------------------------------------------------------
process (Rotate,Dir,NCOcount)
begin 
  if  rising_edge(Rotate) and Dir ='0' then
      if    NCOcount > StepSize then
            NCOcount  <= NCOcount-StepSize  ; -- decrement counter
      else
            NCOcount  <= NCOcount ; -- value unchanged
      end if;
  elsif 	rising_edge(Rotate) and Dir ='1' then
      if    NCOcount < (4096-StepSize) then  -- limit count to 256 (?)
            NCOcount  <= NCOcount+StepSize  ; -- increment counter 
      else
            NCOcount  <= NCOcount ; -- value unchanged
      end if; 
  end if; 			
NCO <= std_logic_vector(to_unsigned(NCOcount,12)) ; -- convert integer to std logic vector
end process;
-----------------------------------------------------------------------------
end select_mode;
