----------------------------------------------------------------------------
---- Create Date:    13:06:08 07/28/2010 								----		
---- Design Name: lfsr													----				
---- Project Name: lfsr_randgen										   	----	
---- Description: 														----	
----  A random number generator based on linear feedback shift         	----
----  register(LFSR).A LFSR is a shift register whose input bit is a    ----
----  linear function of its previous state.The detailed documentation  ----	
----  is available in the file named manual.pdf.   						----	
---- This file is a part of the lfsr_randgen project at                 ----
---- http://www.opencores.org/						                    ----
---- Author(s):                                                         ----
----   Vipin Lal, lalnitt@gmail.com                                     ----
----                                                                    ----
----------------------------------------------------------------------------
--- Modified by ON the 22/06/17											----
--- output is now signed 2's complement.								----
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.lfsr_pkg.ALL; 

entity lfsr is
   generic (width : integer := 24);
port (	clk : in std_logic;
		set_seed : in std_logic; 
		seed : in std_logic_vector(width-1 downto 0);
		rand_out : out signed(width-1 downto 0)  		
	);
end lfsr;

architecture Behavioral of lfsr is

begin

process(clk)

variable rand_temp : std_logic_vector (width-1 downto 0):=(0 => '1',others => '0');
variable temp : std_logic := '0';

begin

if(rising_edge(clk)) then

if(set_seed = '1') then
rand_temp := seed;
end if;

temp := xor_gates(rand_temp);
rand_temp(width-1 downto 1) := rand_temp(width-2 downto 0);
rand_temp(0) := temp;

end if;
rand_out <= signed (not rand_temp(width-1) & rand_temp (width-2 downto 0)); -- offset binary to signed conversion


end process;

end Behavioral;

