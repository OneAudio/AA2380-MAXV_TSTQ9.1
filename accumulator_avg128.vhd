library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity accumulator_avg128 is
     Port (
         clk      : in  STD_LOGIC;
         rst      : in  STD_LOGIC;
         en       : in  STD_LOGIC;
         data_in  : in  STD_LOGIC_VECTOR(23 downto 0);
         avg_out  : out STD_LOGIC_VECTOR(23 downto 0);
         valid    : out STD_LOGIC
     );
end accumulator_avg128;

architecture Behavioral of accumulator_avg128 is
     signal acc_reg   : signed(31 downto 0) := (others => '0'); --�largi pour �viter d�passement
     signal count     : integer range 0 to 128 := 0;
     signal avg_reg   : signed(23 downto 0) := (others => '0');
     signal valid_reg : std_logic := '0';
begin
     process(clk)
     begin
         if rising_edge(clk) then
             if rst = '1' then
                 acc_reg   <= (others => '0');
                 count     <= 0;
                 avg_reg   <= (others => '0');
                 valid_reg <= '0';
             elsif en = '1' then
                 if count < 128 then
                     acc_reg <= acc_reg + resize(signed(data_in), 32);
                     count   <= count + 1;
                     valid_reg <= '0';
                 else
                     -- moyenne = acc_reg / 128 = acc_reg srl 7
                     avg_reg   <= resize(acc_reg(31 downto 7), 24); --shift right 7 bits
                     acc_reg   <= (others => '0');  -- reset pour prochaine s�rie
                     count     <= 0;
                     valid_reg <= '1';
                 end if;
             else
                 valid_reg <= '0'; -- valide seulement un cycle
             end if;
         end if;
     end process;

     avg_out <= std_logic_vector(avg_reg);
     valid   <= valid_reg;
end Behavioral;