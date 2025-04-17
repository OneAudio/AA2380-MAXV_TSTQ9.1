----------------------------------------------------------------------------------
-- The 19/01/24 O.Narce
-- Version of LUT_Quarter wih 128 data points instead of 64 (double)
-- Amplitude is -6dB FS
-- Take 188 LE
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity LUT_QuarterII is

    Port (CLOCK     : in  STD_LOGIC ;
          LUT_Addr  : in  STD_LOGIC_vector(6 downto 0); -- lockup table input data address
          SIN_OUT   : out signed(23 downto 0); -- output LUT table values (sine)
          COS_OUT   : out signed(23 downto 0); -- output LUT table values (cosine)
          SYNC_OUT  : out STD_LOGIC  -- square wave sync output of sine wave (sync to sine)
          -- TEST OUTPUTS :
          --MSB_addr : buffer STD_LOGIC ;
          --XOUT1     : buffer  signed(23 downto 0);
          --XOUT2     : buffer  signed(23 downto 0);
          --LUTtronc : buffer integer range 0 to 32
          );
        
end LUT_QuarterII;

architecture Behavioral of LUT_QuarterII is
 
signal DecAddr   :integer range 0 to 32 ; -- modified address 
signal LUTtronc  :integer range 0 to 32 ;--
signal MSB_addr  :STD_LOGIC ; --
signal XOUT1      : signed(23 downto 0);
signal XOUT2      : signed(23 downto 0);

 
begin

LUTtronc <=to_integer(unsigned(LUT_Addr(5 downto 0))); -- 
MSB_addr <= LUT_Addr(6);-- MSB (5);-- MSB bit of address word
-----------------------------------------------------------------------
-- Address decoding to use only 1/4 of sine wave lockup table
-----------------------------------------------------------------------
process(MSB_addr,LUTtronc,XOUT1,XOUT2,LUT_Addr)
begin
    if  MSB_addr='0' then
    -- first half wave of sine (0..pi), positive values of wave (unchanged LUT value)
        if  LUTtronc>32 then
            DecAddr <= 64-LUTtronc ;--
        else
            DecAddr <= LUTtronc ;--
        end if;
    SIN_OUT <= XOUT1;--
    SYNC_OUT <= '1'; -- Synch high
    else 
    -- second half of wave, all LUT value are inverted to get negative value,
    -- to do this, all bit are inverted and 1 is added to get negative value.
        if  LUTtronc>32 then
            DecAddr <= 64-LUTtronc  ;--
        else
            DecAddr <= LUTtronc ;--
        end if;
    SIN_OUT <= -(XOUT1);-- inverted value
    SYNC_OUT <= '0'; -- Synch high
    end if;
    --
    -- For cosine output, the negative value are when both most MSB are high, but at same time (xor)
    if  (LUT_Addr(6)='1' xor LUT_Addr(5)='1') then -- the 2 MSB of address are high, not both 
        COS_OUT <= -(XOUT2);--inverted value
    else
        COS_OUT <= XOUT2;-- inverted value
    end if;
end process;

-----------------------------------------------------------------------
-- LUT table with 1/4 sine period data (0 to pi/2)
-- Here is 1/4 period data points for each sine/cosine cycle
-- sine and cosine use same values but mirror shift.
-----------------------------------------------------------------------
process(CLOCK,DecAddr)
begin
    if  CLOCK'event and CLOCK='1' then
        case DecAddr is  -- 
            when 0  => XOUT1 <= x"000000"; --24 bits signed value
            when 1  => XOUT1 <= x"0647D9";
            when 2  => XOUT1 <= x"0C8BD3";
            when 3  => XOUT1 <= x"12C810";
            when 4  => XOUT1 <= x"18F8B8";
            when 5  => XOUT1 <= x"1F19F9";
            when 6  => XOUT1 <= x"25280C";
            when 7  => XOUT1 <= x"2B1F35";
            when 8  => XOUT1 <= x"30FBC5";
            when 9  => XOUT1 <= x"36BA20";
            when 10 => XOUT1 <= x"3C56BA";
            when 11 => XOUT1 <= x"41CE1E";
            when 12 => XOUT1 <= x"471CED";
            when 13 => XOUT1 <= x"4C3FE0";
            when 14 => XOUT1 <= x"5133CD";
            when 15 => XOUT1 <= x"55F5A5";
            when 16 => XOUT1 <= x"5A827A";
            when 17 => XOUT1 <= x"5ED77D"; 
            when 18 => XOUT1 <= x"62F202";
            when 19 => XOUT1 <= x"66CF81";
            when 20 => XOUT1 <= x"6A6D99";
            when 21 => XOUT1 <= x"6DCA0D";
            when 22 => XOUT1 <= x"70E2CC";
            when 23 => XOUT1 <= x"73B5EC";
            when 24 => XOUT1 <= x"7641AF";
            when 25 => XOUT1 <= x"788484";
            when 26 => XOUT1 <= x"7A7D05";
            when 27 => XOUT1 <= x"7C29FC";
            when 28 => XOUT1 <= x"7D8A5F";
            when 29 => XOUT1 <= x"7E9D56";
            when 30 => XOUT1 <= x"7F6237";
            when 31 => XOUT1 <= x"7FD888";
            when 32 => XOUT1 <= x"7FFFFF";
            when others => XOUT1 <= x"000000";
        end case;
        --- Cosine output (same data as Sine, but mirrored)
        case DecAddr is  --
            when 0  => XOUT2 <= x"800000"; --24 bits signed value
            when 1  => XOUT2 <= x"7FD888";
            when 2  => XOUT2 <= x"7F6237";
            when 3  => XOUT2 <= x"7E9D56";
            when 4  => XOUT2 <= x"7D8A5F";
            when 5  => XOUT2 <= x"7C29FC";
            when 6  => XOUT2 <= x"7A7D05";
            when 7  => XOUT2 <= x"788484";
            when 8  => XOUT2 <= x"7641AF";
            when 9  => XOUT2 <= x"73B5EC";
            when 10 => XOUT2 <= x"70E2CC";
            when 11 => XOUT2 <= x"6DCA0D";
            when 12 => XOUT2 <= x"6A6D99";
            when 13 => XOUT2 <= x"66CF81";
            when 14 => XOUT2 <= x"62F202";
            when 15 => XOUT2 <= x"5ED77D";
            when 16 => XOUT2 <= x"5A827A";
            when 17 => XOUT2 <= x"55F5A5"; 
            when 18 => XOUT2 <= x"5133CD";
            when 19 => XOUT2 <= x"4C3FE0";
            when 20 => XOUT2 <= x"471CED";
            when 21 => XOUT2 <= x"41CE1E";
            when 22 => XOUT2 <= x"3C56BA";
            when 23 => XOUT2 <= x"36BA20";
            when 24 => XOUT2 <= x"30FBC5";
            when 25 => XOUT2 <= x"2B1F35";
            when 26 => XOUT2 <= x"25280C";
            when 27 => XOUT2 <= x"1F19F9";
            when 28 => XOUT2 <= x"18F8B8";
            when 29 => XOUT2 <= x"12C810";
            when 30 => XOUT2 <= x"0C8BD3";
            when 31 => XOUT2 <= x"0647D9";
            when 32 => XOUT2 <= x"000000";
            when others => XOUT2 <= x"000000";
        end case;
    end if;                           
end process;                       
                                   
end Behavioral;                    

















