--------------------------------------------
-- ON le 24/02/2025
-- NCO module, XX bits wide
-- with dither noise input
--
-- Size: LE
----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity NCOII is
port (
  CLOCK                      : in  std_logic; -- internal NCO clock
  NCO_RST                    : in  std_logic; -- NCO reset input (asynchronous)
  i_sync_reset               : in  std_logic; -- NCO reset input (synchronous of selected NCO clock)
  iFCW                       : in  std_logic_vector(15 downto 0); -- input Frequency Control Word
  ACCout                     : out std_logic_vector(15 downto 0)  -- phase ACCumulator Output
  );
end NCOII;

architecture rtl of NCOII is

signal clock							  : std_logic;
signal r_sync_reset                : std_logic;
signal r_fcw                       : unsigned(15 downto 0);
signal r_nco                       : unsigned(15 downto 0);

begin

----------------------------------------------------------
-- NCO
----------------------------------------------------------
p_nco16 : process(CLOCK,NCO_RST)
begin
  if(NCO_RST='1') then                  --asynch reset
    r_sync_reset      <= '1';
    r_fcw             <= (others=>'0');
    r_nco             <= (others=>'0');
  elsif(rising_edge(CLOCK)) then
    r_sync_reset      <= i_sync_reset   ;  --synchronous reset
    r_fcw             <= unsigned(iFCW) ;  -- 
    if(r_sync_reset='1') then
      r_nco             <= (others=>'0');
    else
      r_nco             <= r_nco + r_fcw;-- increment ramp at each clock edge with value of iFCW
    end if;
  end if;
end process p_nco16;

ACCout            <= std_logic_vector(r_nco); --send result as logic vector

end rtl;

