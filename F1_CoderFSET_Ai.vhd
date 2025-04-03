library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity F1_CoderFSET_Ai is
    Port (
        clk      : in  std_logic; -- 24.576MHz clock
        Ta, Tb   : in  std_logic; -- Encoder inputs
        push     : in  std_logic; -- Push button input
        RAZ      : out std_logic; -- Reset output
        NCO      : out std_logic_vector(11 downto 0);
        clkslowo : out std_logic; -- 3kHz clock output
        short    : out std_logic  -- Short press output
    );
end F1_CoderFSET_Ai;

architecture optimized of F1_CoderFSET_Ai is
    signal countA    : unsigned(13 downto 0) := (others => '0');
    signal clkslow   : std_logic := '0';
    signal counter   : unsigned(10 downto 0) := (others => '0');
    signal pulse_long, pulse_short : std_logic := '0';
    signal rotary_in : std_logic_vector(1 downto 0);
    signal dir, rotate : std_logic := '0';
    signal step_size : integer range 1 to 64 := 1;
    signal step_count: integer range 0 to 3 := 0;
    signal NCOcount  : unsigned(11 downto 0) := (others => '0');

begin
    -- Generate 3kHz clock from 24.576MHz
    process(clk)
    begin
        if rising_edge(clk) then
            countA <= countA + 1;
            if countA = 15 then
                clkslow <= not clkslow;
                countA <= (others => '0');
            end if;
        end if;
    end process;
    clkslowo <= clkslow;

    -- Long push detection (~1s)
    process(clkslow)
    begin
        if rising_edge(clkslow) then
            if push = '1' then
                if counter < 2047 then
                    counter <= counter + 1;
                end if;

                if counter = 128 then
                    pulse_short <= '1';
                end if;

                if counter = 2047 then
                    pulse_long <= '1';
                end if;
            else
                counter <= (others => '0');
                pulse_short <= '0';
                pulse_long <= '0';
            end if;
        end if;
    end process;

    -- Maintien des signaux de sortie pour au moins un cycle d'horloge
    process(clk)
    begin
        if rising_edge(clk) then
            RAZ   <= pulse_long;
            short <= pulse_short;
        end if;
    end process;

    -- Rotary encoder processing
    process(clkslow)
    begin
        if rising_edge(clkslow) then
            rotary_in <= Ta & Tb;
            case rotary_in is
                when "01" => dir <= '0';
                when "10" => dir <= '1';
                when "11" => rotate <= '1';
                when others => rotate <= '0';
            end case;
        end if;
    end process;

    -- Step size adjustment (1, 4, 16, 64)
    process(clkslow)
    begin
        if rising_edge(clkslow) then
            if pulse_long = '1' then
                step_count <= 0;
            elsif pulse_short = '1' then
                step_count <= (step_count + 1) mod 4;
            end if;
        end if;
    end process;
    step_size <= 1 when step_count = 0 else 4 when step_count = 1 else 16 when step_count = 2 else 64;

    -- NCO counter adjustment
    process(clkslow,rotate)
    begin
        if rising_edge(clkslow) and rotate = '1' then
            if dir = '0' and NCOcount >= step_size then
                NCOcount <= NCOcount - step_size;
            elsif dir = '1' and NCOcount <= 4095 - step_size then
                NCOcount <= NCOcount + step_size;
            end if;
        end if;
    end process;
    
    NCO <= std_logic_vector(NCOcount);
end optimized;
