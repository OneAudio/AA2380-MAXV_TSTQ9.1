library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity compteur_base96 is
    Port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        enable  : in  std_logic;
        count   : out std_logic_vector(20 downto 0)
    );
end compteur_base96;

architecture Behavioral of compteur_base96 is
    signal counter : std_logic_vector(20 downto 0) := (others => '0');

begin
    process (clk, rst)
    begin
        if rst = '1' then
            counter <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                if counter(6 downto 0) = "1011111" then -- 95 en binaire
                    counter(6 downto 0) <= (others => '0');
                    if counter(13 downto 7) = "1011111" then -- 95 en binaire
                        counter(13 downto 7) <= (others => '0');
                        if counter(20 downto 14) = "1011111" then -- 95 en binaire
                            counter(20 downto 14) <= (others => '0');
                        else
                            counter(20 downto 14) <= counter(20 downto 14) + '1';
                        end if;
                    else
                        counter(13 downto 7) <= counter(13 downto 7) + '1';
                    end if;
                else
                    counter(6 downto 0) <= counter(6 downto 0) + '1';
                end if;
            end if;
        end if;
    end process;
    
    count <= counter;
    
end Behavioral;
