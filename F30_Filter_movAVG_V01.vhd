--------------------------------------------------------------------------------
-- F30_Filter_movAVG_V01  -- O.N - 23/04/2025 -- take 261 LE (simulated ok) 
--------------------------------------------------------------------------------
-- 2 channels moving average filter from 1 to 128.
-- Averaging ratio is set by DFS input-> "000" average= 1 ; "111" average = 128.
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity F30_Filter_movAVG_V01 is
     Port (
         clk      : in  STD_LOGIC;-- input sampling clock
         clear    : in  STD_LOGIC;-- clear input
         DFS      : in  STD_LOGIC_VECTOR(2 downto 0) ;-- 3 bits sampling frequency word (12kHz to 1536kHz)
         DATAL    : in  STD_LOGIC_VECTOR(23 downto 0);-- Left channel data input (signed 2's complement)
         DATAR    : in  STD_LOGIC_VECTOR(23 downto 0);-- Right channel data input (signed 2's complement)
         DATALF   : out STD_LOGIC_VECTOR(23 downto 0);-- Left channel filtered data output (signed 2's complement)
         DATARF   : out STD_LOGIC_VECTOR(23 downto 0);-- Right channel filtered data output (signed 2's complement)
         valid    : out STD_LOGIC   -- logic signal that indicate valid data (when falling edge).
         -- TEST OUTPUTS
         --DivRatioT: out integer range 1 to 128;
         --acc_regLT : out signed(31 downto 0);
         --countT   : out integer range 0 to 128 
     );
end F30_Filter_movAVG_V01;

architecture Behavioral of F30_Filter_movAVG_V01 is
     signal acc_regL   : signed(31 downto 0) := (others => '0'); -- accumulator for left channel
     signal acc_regR   : signed(31 downto 0) := (others => '0'); -- accumulator for right channel
     signal avg_regL   : signed(23 downto 0) := (others => '0'); -- 
     signal avg_regR   : signed(23 downto 0) := (others => '0'); --
     signal count     : integer range 1 to 128 := 1; -- divide by N averaged samples counter
     signal valid_reg : std_logic := '0';  -- valid bit register
     signal DivRatio  : integer range 1 to 128 := 1; -- averaging ratio (1 to 128)
     signal ShiftRatio: integer range 0 to 7 := 0; -- shift register ration for dividing accululator by 2^n.
     
     begin

-- TEST OUTPUTS
-- DivRatioT   <= DivRatio ;
-- acc_regLT    <= acc_regL  ;
-- countT      <= count    ;
     process(clk,DFS)
     begin
    ShiftRatio <= to_integer(unsigned(DFS)); --
    DivRatio <= 2 ** to_integer(unsigned(DFS)); -- convert DFS to 2^n value (1 to 128 samples).

         if rising_edge(clk) then
             if clear = '1' then
                 acc_regL   <= (others => '0');
                 avg_regL   <= (others => '0');
                 acc_regR   <= (others => '0');
                 avg_regR   <= (others => '0');
                 count     <= 1;
                 valid_reg <= '0';
             else
                 if count < DivRatio then
                     acc_regL <= acc_regL + resize(signed(DATAL), 32);
                     acc_regR <= acc_regR + resize(signed(DATAR), 32);
                     count   <= count + 1;
                     valid_reg <= '0';
                 else
                     -- average = acc_reg / DivRatio = acc_regL srl 
                    avg_regL   <= resize(shift_right(acc_regL(31 downto 0),ShiftRatio),24);-- shift accumulator to n bits, and resize result for 24 bits signed
                    acc_regL   <= resize(signed(DATAL), 32);  -- load left input data
                    avg_regR   <= resize(shift_right(acc_regR(31 downto 0),ShiftRatio),24);-- shift accumulator to n bits, and resize result for 24 bits signed
                    acc_regR   <= resize(signed(DATAR), 32);  -- load right input data
                    count      <= 1;
                    valid_reg  <= '1';
                 end if;
             end if;
         end if;
     end process;
     DATALF <= std_logic_vector(avg_regL);
     DATARF <= std_logic_vector(avg_regR);
     valid   <= valid_reg;
end Behavioral;

