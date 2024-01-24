-----------------------------------------------------------------
-- Clock divider test module
------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TESTclkdivider is
--
port(

  enable	      : in  std_logic; -- enable input
  CLKIN         : in  std_logic; -- clock input
  DIVOUT        : out std_logic_vector(23 downto 0) ; --
  DIVOUTx       : out std_logic_vector(23 downto 0) ;  --
  SyCLOK        : out std_logic
);

end TESTclkdivider ;

architecture Behavioral of TESTclkdivider is

signal  clk_divider1 : unsigned (23 downto 0); -- clock divider counter
signal  clk_divider2 : unsigned (23 downto 0); -- clock divider counter
signal  QA           : std_logic ;

begin

------------------------------------------------------------------
-- CLOCK divider Normal (with skew)
------------------------------------------------------------------
p_clk_divider: process(CLKIN,enable,clk_divider1)
begin
	if enable = '1' then
		if  rising_edge(CLKIN) then
		    clk_divider1   <= clk_divider1 + 1 ;
		end if;
	else
    clk_divider1 <= x"000000" ; -- clear counter if enable is low.
	end if;
  DIVOUT    <= std_logic_vector(clk_divider1) ; --
end process p_clk_divider;

------------------------------------------------------------------
-- CLOCK divider Modified  (no skew)
------------------------------------------------------------------
p2_clk_divider: process(CLKIN,enable,clk_divider2)
begin
	if enable = '1' then
		if  rising_edge(CLKIN) then
        DIVOUTx <= std_logic_vector(clk_divider2) ;
		    clk_divider2   <= clk_divider2 + 1 ;
		end if;
	else
    clk_divider2 <= x"000000" ; -- clear counter if enable is low.
  end if;
  --
  -- if  falling_edge(CLKIN)  then
  -- end if;
end process p2_clk_divider;
-------------------------------------------
------------------------------------------------------------------
-- CLOCK with enable
------------------------------------------------------------------
CKenab: process(CLKIN,enable,QA)
begin

		if  falling_edge(CLKIN) then
        QA <= enable ;
    end if;
		SyCLOK <= QA and CLKIN ;

end process CKenab;
-------------------------------------------


end Behavioral ;
