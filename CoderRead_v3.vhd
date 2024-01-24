--------------------------------------------------------------------------------
-- O.N - 05/05/20
-- take XX LE
-- Rotary encoder and push button control
--
-- invert ta/tb for good direction.(31/03/18 version)
-- add fast test output
-- add test outputs
-- Version 1 : Add "ROT_Speed" output that indicate to counter if encoder
-- is turned fast to use bigger counter increment.
-- Version 2 : Add Raz_BP input to force BP output low for voltage setting only
-- (for SER/PAR tracking mode)
--
--Version 3 (05/05/2020) :
-- Add 1s pulse output is the push button of encoder is pressed for 5s
--(to be used for individual channel on/off setting).
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

 entity CoderRead_v3 is
    Port (
          Clk50k    : in  std_logic; -- 50kHz clock
          Clk400    : in  std_logic; -- 400Hz clock
	      nTa	    : in  std_logic; -- coder track A
          nTb       : in  std_logic; -- coder track B
          nPush     : in  std_logic; -- coder push button
          Push_ext1 : in  std_logic; -- external push button 1
          Push_ext2 : in  std_logic; -- external push button 2
          Raz_BP    : in  std_logic; -- reset BP_out output to force voltage setting mode (for track SER/PAR)
          DblPush   : buffer std_logic; -- Double push detection (toggle signal)
          BP1s      : buffer std_logic; -- 1s Push button detection 
          BP_out    : buffer std_logic; -- Push button output (toggle signal)
          DIR       : out std_logic; -- Rotary encoder rotating direction signal
          Pulses    : buffer std_logic; -- Rotary encoder output pulses (fast or slow)
          Pbip      : out std_logic; -- encoder pulses for rotary bips
          Push_Out  : out std_logic; -- filtered direct Push button output (active high)
          BP_AND    : buffer std_logic;  -- Signal indicate simultaneous push buttons are active
          ROT_Speed : buffer std_logic  -- Fast encoder turn indicator (0= Normal 1= Fast)
         -- TESTS OUTPUTS
--          Rotate_test   : out std_logic ;
--          Pulse_test    : out std_logic ;
--          Direction_test : out std_logic;
--          Cnt_test    : out integer range 0 to 255
    );
 end CoderRead_v3;

architecture Attenuator of CoderRead_v3 is

signal rotary_in        : STD_LOGIC_vector (1 downto 0)  ; -- Vector of the two encoder tracks
signal delay_rotary_q1  : STD_LOGIC  ; --
signal Direction				: STD_LOGIC  ; --
signal Rotate			      : STD_LOGIC  ; --

signal Tmp              : STD_LOGIC  ; --
signal Pulse            : STD_LOGIC  ; --
signal timeout          : integer range 0 to 63 :=0 ;-- timeout counter for slow/fast increment modes.
signal end_timeout      : STD_LOGIC  ; --

signal Push 			      : STD_LOGIC  ; --
signal Tmp_D			      : STD_LOGIC  ; --
signal Push_D			      : STD_LOGIC  ; --

signal Mult_push        : STD_LOGIC  ; --
signal Release_Push     : integer range 0 to 255 :=0 ; -- multiple push release delay

signal Long_push_count  : integer range 0 to 255 :=0 ; -- long push detection counter
signal Tmp1s            : STD_LOGIC  ; --
signal Tmp2             : STD_LOGIC  ; --
signal Detect_ENAB      : STD_LOGIC  ; --



signal count_dualp      : integer range 0 to 255 :=0 ; --double push detection counter
signal Dual             : STD_LOGIC  ; --

signal count_test	  : integer range 0 to 255 :=0 ; --test


begin
---- test outputs
--Rotate_test   <= Rotate ;
--Pulse_test    <= Pulse ;


--------------------------------------------------------------------------------
-- New rotary encoder function from Xilinx app note
-- (Works fine !)
-- Note: The encoder used is a PEC12R-4225F-S0024 from Bourns.
-- There is 24 pulses / rev with 12 detents(crank).
--
--------------------------------------------------------------------------------
rotary_filter: process(Clk50k)
begin
  if Clk50k'event and Clk50k='1' then
      rotary_in <= nTa & nTb;
  case rotary_in is
    when "00" =>  Rotate <= '0';
                  Direction <= Direction;
    when "01" =>  Rotate <= Rotate;
                  Direction <= '0';
    when "10" =>  Rotate <= Rotate;
                  Direction <= '1';
    when "11" =>  Rotate <= '1';
                  Direction <= Direction;
    when others => Rotate <= Rotate;
                  Direction <= Direction;
  end case;
end if;
end process rotary_filter;


Pulses <= Rotate ;
DIR    <= Direction ;
Pbip   <= Rotate  ;

--------------------------------------------------------------------------------
-- Detect rotary turn speed to select fast or slow pulses mode
--------------------------------------------------------------------------------
pulses_speed: process (Clk400,nTa,timeout,pulse,end_timeout,Rotate)
begin
  -- single pulse generator at rising edge of nTa
  if  Pulse = '1' then
      Tmp <= '0';
  elsif rising_edge(Rotate) then
      Tmp <= '1' ;
  end if;
  if  rising_edge(Clk400) then
      if  Tmp='1' then
          Pulse <= '1';--
      else
          Pulse <= '0';--
      end if;
  end if;
  if    pulse='1' then
        timeout <= 0 ; -- reset timout counter
  elsif rising_edge(Clk400) then
        if  timeout= 63 then -- end timout reached for 63x1/400 = 157.5ms
            end_timeout <= '0' ;
        else
            timeout <= timeout +1 ; --increment
            end_timeout <= '1' ;
        end if;
  end if;
--  if  rising_edge(pulse) then
      ROT_Speed <= end_timeout ; --
--  end if;
end process pulses_speed;



----- TEST ONLY
--process (Pulses,Count_test,Direction,ROT_Speed)
--begin
--    if  rising_edge(Pulses)  then
--        Direction_test <= Direction;
--    end if;
--    if  rising_edge(Pulses)  then
--          if ROT_Speed='0'  then
--              if  Direction='0'  then
--                  Count_test <= Count_test -1 ;
--              else
--                  Count_test <= Count_test +1 ;
--              end if;
--          else
--              if  Direction='0'  then
--                  Count_test <= Count_test -5 ;
--              else
--                  Count_test <= Count_test +5 ;
--              end if;
--          end if;
--        Direction_test <= Direction;
--        Cnt_test <= Count_test ;
--    end if;
--end process;
------- TEST END




--------------------------------------------------------------------------------
-- Detect short,long (1s), and double push of encoder button
-- 1) short push toggle BP_out
-- 2) 1s push get a single pulse BP_1s
-- 3) dual fast push toggle "DblPush" output
--------------------------------------------------------------------------------
Push_Out <= Push ;
detect_push: process (Clk400,nPush,Push,count_dualp,Tmp_D,Push_D,DblPush,BP1s,Tmp1s,BP_AND,Detect_ENAB,Dual,Raz_BP)
begin
  -- invert and synchronize push button of encoder.
  if  rising_edge(Clk400) then
      Push <= not nPush ;
  end if;
  --
  if     Push='0' then --
         Long_push_count <= 0; -- reset counter
         Tmp1s <= '0';
  else
      if rising_edge(Clk400) and Detect_ENAB='1'  then
         if   Long_push_count=255 then
              Tmp1s <= '1'; -- long push is detected
         else
              Long_push_count <= Long_push_count+1 ; -- increment counter
              Tmp1s <= '0';
         end if;
      end if;
  end if;
  --- Generate a single pulse from Tmp_1s when 1s push is detected
  if      BP1s = '1' then
          Tmp2 <= '0';
  elsif   rising_edge(Tmp1s) then
          Tmp2 <= '1' ;
  end if;
  if  rising_edge(Clk400) then
      if  Tmp2='1' then
          BP1s <= '1';--
      else
          BP1s <= '0';--
      end if;
  end if;

  Detect_ENAB <= BP_AND nor Tmp1s ; --

  -- BP_out output toggle when button is released
  -- But only if Raz_BP input is low , otherwise = 0 !
  if      Raz_BP='1'  then
          BP_out <= '0'; -- reset BP_out if Raz_BP is active.
  elsif   falling_edge(Push) and Detect_ENAB='1' then
          BP_out <= not BP_out ; -- invert BP_out
  end if;

  -- detect first and second rising edge of "Push" in count_dualp window.
  if  count_dualp < 200 then
      if  rising_edge(Push) then
          Tmp_D <= '1' ;
          if  Tmp_D ='1' then
              Push_D <= '1' ;
          end if;
      end if;
  else
      Tmp_D       <='0' ;
      Push_D      <='0' ;
  end if;
  --  Start to count as soon first push is initiated
  if  rising_edge(Clk400) then
      if  Tmp_D='1' then -- start counting
          count_dualp <= count_dualp +1 ; -- increment counter
      else
          count_dualp <= 0  ; -- reset counter
      end if;
      -- if two push detected  before count_dualp reach 200 , invert DblPush
      Dual <= Push_D and Push ;
  end if;
  --
  if rising_edge(Dual)  then
      DblPush <= not DblPush ; -- invert
  end if;

end process detect_push ;



--------------------------------------------------------------------------------
-- Detect if others active push button are pushed and :
-- 1/ Disable long push detect function
-- 2/ Generate signal for function using dual button push mode (BP_AND)
--------------------------------------------------------------------------------

multiple_push: process (Clk400,Push,Push_ext1,Push_ext2,Release_Push)
begin
Mult_push <= Push and Push_ext1 and Push_ext2 ;  --> I THINK THERE IS A BUG HERE !! WE NEED TO CHECK ONLY TWO BUTTON PRESSED AT SAME TIME, NOT THREE !!!
    if  rising_edge(Clk400) then
        -- reset counter if all push are active, otherwise start to count
        if     Mult_push ='1' then
               Release_Push <= 0 ; -- reset counter
               BP_AND <= '1' ;
        else
            if  Release_Push=255 then
                BP_AND <= '0' ;
            else
                BP_AND <= '1' ;
                Release_Push <= Release_Push + 1 ; -- increment counter
            end if;
        end if;
    end if;
end process multiple_push ;

end architecture;
