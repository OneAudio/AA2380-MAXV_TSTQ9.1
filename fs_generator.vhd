library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fs_generator is
    Port (
        clk     : in  std_logic;                          -- Horloge 98.304 MHz
        dfs     : in  std_logic_vector(2 downto 0);       -- Sélection fréquence
        fs      : out std_logic;                          -- Sortie FS
        fs8     : out std_logic                           -- Sortie 8FS
    );
end fs_generator;

architecture Behavioral of fs_generator is

    -- Table de division de clk pour 8FS
    type div_array is array (0 to 7) of integer;
    constant div_values : div_array := (
        0 => 1024,
        1 => 512,
        2 => 256,
        3 => 128,
        4 => 64,
        5 => 32,
        6 => 16,
        7 => 8
    );

    signal div_count      : integer range 0 to 1023 := 0;
    signal div_value      : integer := 1024;

    signal fs8_ce         : std_logic := '0';  -- Clock enable pour fs8
    signal fs8_reg        : std_logic := '0';

    signal fs_div         : integer range 0 to 7 := 0;
    signal fs_reg         : std_logic := '0';

begin

    -- Sélection du diviseur à chaque cycle
    process(clk)
    begin
        if rising_edge(clk) then
            div_value <= div_values(to_integer(unsigned(dfs)));
        end if;
    end process;

    -- Génération de l'horloge 8FS (avec CE)
    process(clk)
    begin
        if rising_edge(clk) then
            fs8_ce <= '0';
            if div_count = div_value - 1 then
                div_count <= 0;
                fs8_ce <= '1';
                fs8_reg <= not fs8_reg;  -- Bascule tous les "div_value" cycles
            else
                div_count <= div_count + 1;
            end if;
        end if;
    end process;

    -- Génération de l'horloge FS : 1/8 de 8FS
    process(clk)
    begin
        if rising_edge(clk) then
            if fs8_ce = '1' then
                if fs_div = 3 then
                    fs_div <= 0;
                    fs_reg <= not fs_reg;  -- Bascule tous les 4 demi-périodes de 8FS
                else
                    fs_div <= fs_div + 1;
                end if;
            end if;
        end if;
    end process;

    -- Assignation des sorties
    fs8 <= fs8_reg;
    fs  <= fs_reg;

end Behavioral;
