library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PulseOnChange is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        data_in  : in  STD_LOGIC_VECTOR(15 downto 0);
        pulse_out: out STD_LOGIC
    );
end PulseOnChange;

architecture Behavioral of PulseOnChange is
    signal prev_data : STD_LOGIC_VECTOR(15 downto 0);
    signal pulse     : STD_LOGIC := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                prev_data  <= (others => '0');
                pulse      <= '0';
            else
                if prev_data /= data_in then
                    pulse <= '1';
                else
                    pulse <= '0';
                end if;
                prev_data <= data_in;
            end if;
        end if;
    end process;
    
    pulse_out <= pulse;
end Behavioral;