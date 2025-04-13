-------------------------------------------------------
-- ON le 19/08/2019 -- Use generic inputs
-------------------------------------------------------
-- Intel MAXV 5M570 CPLD	Take 43 LE.
-- Function F7 :  F7_Ready.vhd
-------------------------------------------------------
-- Generate ready signal after a delay from main clock.
-- You can choose :
-- ==> CLKVAL in Hz (input clock frequency)
-- ==> DELAY  in ms (output delay in ms).
-- ==> FSLOW in Hz (slow frequency output).
-- 
-- Note: Take 52 LE for :
-- CLKVAL=1562500 Hz, FSLOW=50Hz and DELAY=100ms
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity F7_Ready is
Generic(
CLKVAL	:	natural := 50000000;	-- input frequency in Hz
Fhig	:	natural := 1000000	;	-- output Fo1 frequency in Hz.
Fmid	:	natural := 10000	;	-- output Fo2 frequency in Hz.
Flow	:	natural := 1		;	-- output Fo3 frequency in Hz.
DELAY	:	natural := 500		 	-- ready output delay in ms
); 
    Port (
        CLKIN		:in			STD_LOGIC ;-- input clock 
        READY  		:buffer		STD_LOGIC ;-- Ready output signal (active high)
		CLKFH		:buffer		STD_LOGIC :='1'; -- output slow clock (derivated from CLKIN).
		CLKFM		:buffer		STD_LOGIC :='1'; -- output slow clock (derivated from CLKIN).
		CLKFL		:buffer		STD_LOGIC :='1';-- output slow clock (derivated from CLKIN).
		tog1	: out integer range 0 to (CLKVAL/2);
		tog2	: out integer range 0 to (Fhig/2) ;
		tog3	: out integer range 0 to (Fmid/2);
		slc1	: out integer range 0 to CLKVAL :=0 ; 
		slc2	: out integer range 0 to Fhig :=0 ; 
		slc3	: out integer range 0 to Fmid :=0  
        );
end F7_Ready;

architecture Behavioral of F7_Ready is
signal counter	: integer range 0 to Fmid :=0 ; -- max count value
signal cnt		: integer range 0 to Fmid :=0	; -- cnt value of timer.
signal toggle1	: integer range 0 to (CLKVAL/2) :=0 ; -- toggle bit
signal toggle2	: integer range 0 to (Fhig/2) :=0 ; -- toggle bit
signal toggle3	: integer range 0 to (Fmid/2) :=0 ; -- toggle bit
signal slowcnt1	: integer range 0 to CLKVAL :=0 ; -- CLKSLOW toggle counter
signal slowcnt2	: integer range 0 to Fhig :=0 ; -- CLKSLOW toggle counter
signal slowcnt3	: integer range 0 to Fmid :=0 ; -- CLKSLOW toggle counter

begin

tog1 <= toggle1 ;
tog2 <= toggle2 ;
tog3 <= toggle3 ;
slc1 <= slowcnt1 ;
slc2 <= slowcnt2 ;
slc3 <= slowcnt3 ;


toggle1	<=	(CLKVAL / (2 * Fhig))-1 ; -- Calculate number of CLKVAL period before to toggle
--
toggle2	<=	(Fhig / (2 * Fmid))-1 ; --
cnt 	<=  (Fmid*DELAY)/1000 ; -- calculate number of clkval period to reach delay
--
toggle3	<=	(Fmid / (2 * Flow))-1 ; -- 

process (CLKIN,ready,slowcnt1,toggle1,CLKFH)
begin
	if rising_edge(CLKIN) then
		-- slow clock from clkin
		if  slowcnt1=toggle1	then
			CLKFH <= not CLKFH ; -- invert CLKSLOW
			slowcnt1 <= 0 ; -- reset slowcnt counter
		else
			slowcnt1 <= slowcnt1 + 1 ; -- increment slowcnt counter
		end if;
	end if;
	if falling_edge(CLKFM) then
		-- ready single pulse at startup
		if  counter < (cnt-1) then
			Ready   <= '0' ;-- Ready signal not active
			counter <= counter +1; -- increment counter
	    else
		 	Ready <= '1'; -- Ready active
		end if;
	end if;
end process;

process (CLKFH,slowcnt2,toggle2,CLKFM)
begin
	if rising_edge(CLKFH) then
		-- slow clock from clkin
		if  slowcnt2=toggle2	then
			CLKFM <= not CLKFM ; -- invert CLKSLOW
			slowcnt2 <= 0 ; -- reset slowcnt counter
		else
			slowcnt2 <= slowcnt2 + 1 ; -- increment slowcnt counter
		end if;
	end if;
end process;

process (CLKFM,slowcnt3,toggle3,CLKFL)
begin
	if rising_edge(CLKFM) then
		-- slow clock from clkin
		if  slowcnt3=toggle3	then
			CLKFL <= not CLKFL ; -- invert CLKSLOW
			slowcnt3 <= 0 ; -- reset slowcnt counter
		else
			slowcnt3 <= slowcnt3 + 1 ; -- increment slowcnt counter
		end if;
	end if;
end process;

end Behavioral;
