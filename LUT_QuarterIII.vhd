----------------------------------------------------------------------------------
-- The 17/02/25 O.Narce
-- Version of LUT_Quarter with 96 data point (24 between 0- pi/2) 
-- 96 data point to allow 1kHz sine wave generation
-- Amplitude is -6dB FS
-- Take ??? LE
--
-- NOTE : With this LUT the phase accumulator MUST be modulo 96 ! no power of 2 !
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity LUT_QuarterIII is

    Port (CLOCK     : in  STD_LOGIC ;
          LUT_Addr  : in  integer range 0 to 127; -- lockup table input data address
          SIN_OUT   : out signed(23 downto 0); -- output LUT table values (sine)
          COS_OUT   : out signed(23 downto 0); -- output LUT table values (cosine)
          SYNC_OUT  : out STD_LOGIC ; -- square wave sync output of sine wave (sync to sine)
          -- TEST OUTPUTS :
          MSB_addr : buffer STD_LOGIC ;
          --XOUT1     : buffer  signed(23 downto 0);
          --XOUT2     : buffer  signed(23 downto 0);
          LUTtronc : buffer integer range 0 to 48
          );
        
end LUT_QuarterIII;

architecture Behavioral of LUT_QuarterIII is
 
signal DecAddr   :integer range 0 to 24 ; -- modified address 
--signal LUTtronc  :integer range 0 to 48 ;--
--signal MSB_addr  :STD_LOGIC ; --
signal XOUT1      : signed(23 downto 0);
signal XOUT2      : signed(23 downto 0);

 
begin


LUTtronc <=LUT_Addr mod 48; -- 
-----------------------------------------------------------------------
-- Address decoding to use only 1/4 of sine wave lockup table
-----------------------------------------------------------------------
process(CLOCK,MSB_addr,LUTtronc,XOUT1,XOUT2,LUT_Addr)
begin
   if  CLOCK'event and CLOCK='1' then
    -- Create - MSB bit of address word
    if  LUT_Addr>48  then
        MSB_addr <= '1';
    else
        MSB_addr <= '0';
    end if;
    --
    if  MSB_addr='0' then
    -- first half wave of sine (0..pi), positive values of wave (unchanged LUT value)
        if  LUTtronc>24 then
            DecAddr <= 48-LUTtronc ;--
        else
            DecAddr <= LUTtronc ;--
        end if;
    SIN_OUT <= XOUT1;--
    SYNC_OUT <= '1'; -- Synch high
    else 
    -- second half of wave, all LUT value are inverted to get negative value,
    -- to do this, all bit are inverted and 1 is added to get negative value.
        if  LUTtronc>24 then
            DecAddr <= 48-LUTtronc  ;--
        else
            DecAddr <= LUTtronc ;--
        end if;
    SIN_OUT <= -(XOUT1);-- inverted value
    SYNC_OUT <= '0'; -- Synch high
    end if;
    --
    -- For cosine output, the negative value are when both most MSB are high, but at same time (xor)
   if  (LUTtronc>24 xor MSB_addr='1') then --  
       COS_OUT <= -(XOUT2);--inverted value
   else
       COS_OUT <= XOUT2;-- inverted value
   end if;
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
            when 1  => XOUT1 <= x"085F21";
            when 2  => XOUT1 <= x"10B515";
            when 3  => XOUT1 <= x"18F8B8";
            when 4  => XOUT1 <= x"2120FC";
            when 5  => XOUT1 <= x"2924EE";
            when 6  => XOUT1 <= x"30FBC5";
            when 7  => XOUT1 <= x"389CEA";
            when 8  => XOUT1 <= x"400000";
            when 9  => XOUT1 <= x"471CED";
            when 10 => XOUT1 <= x"4DEBE5";
            when 11 => XOUT1 <= x"546572";
            when 12 => XOUT1 <= x"5A827A";
            when 13 => XOUT1 <= x"603C49";
            when 14 => XOUT1 <= x"658C9A";
            when 15 => XOUT1 <= x"6A6D99";
            when 16 => XOUT1 <= x"6ED9EC";
            when 17 => XOUT1 <= x"72CCBA"; 
            when 18 => XOUT1 <= x"7641AF";
            when 19 => XOUT1 <= x"793502";
            when 20 => XOUT1 <= x"7BA375";
            when 21 => XOUT1 <= x"7D8A5F";
            when 22 => XOUT1 <= x"7EE7AA";
            when 23 => XOUT1 <= x"7FB9D7";
            when 24 => XOUT1 <= x"7FFFFF";
            when others => XOUT1 <= x"000000";
        end case;
        --- Cosine output (same data as Sine, but mirrored)
        case DecAddr is  --
            when 0  => XOUT2 <= x"7FFFFF"; --24 bits signed value
            when 1  => XOUT2 <= x"7FB9D7";
            when 2  => XOUT2 <= x"7EE7AA";
            when 3  => XOUT2 <= x"7D8A5F";
            when 4  => XOUT2 <= x"7BA375";
            when 5  => XOUT2 <= x"793502";
            when 6  => XOUT2 <= x"7641AF";
            when 7  => XOUT2 <= x"72CCBA";
            when 8  => XOUT2 <= x"6ED9EC";
            when 9  => XOUT2 <= x"6A6D99";
            when 10 => XOUT2 <= x"658C9A";
            when 11 => XOUT2 <= x"603C49";
            when 12 => XOUT2 <= x"5A827A";
            when 13 => XOUT2 <= x"546572";
            when 14 => XOUT2 <= x"4DEBE5";
            when 15 => XOUT2 <= x"471CED";
            when 16 => XOUT2 <= x"400000";
            when 17 => XOUT2 <= x"389CEA"; 
            when 18 => XOUT2 <= x"30FBC5";
            when 19 => XOUT2 <= x"2924EE";
            when 20 => XOUT2 <= x"2120FC";
            when 21 => XOUT2 <= x"18F8B8";
            when 22 => XOUT2 <= x"10B515";
            when 23 => XOUT2 <= x"085F21";
            when 24 => XOUT2 <= x"000000";
            when others => XOUT2 <= x"000000";
        end case;
    end if;                           
end process;                       
                                   
end Behavioral;                    

















