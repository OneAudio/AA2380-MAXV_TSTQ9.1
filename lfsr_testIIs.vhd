library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.lfsr_pkg.all;

entity lfsr_testIIs is
    port (
        FSclk      : in  std_logic;
        set_seed   : in  std_logic;
        seed       : in  std_logic_vector(23 downto 0);
        Set_Dither : in  integer range 0 to 7;
        DATAin     : in  signed(23 downto 0);
        DATAout    : buffer signed(23 downto 0);
        overflow   : out std_logic;
        DATAoutLSB : buffer signed(9 downto 0);
        random_out : buffer signed(7 downto 0)
    );
end lfsr_testIIs;

architecture Behavioral of lfsr_testIIs is
    signal random_out24 : signed(23 downto 0);
    signal datatemp     : signed(23 downto 0);
begin

    process(FSclk)
        variable rand_temp : std_logic_vector(23 downto 0) := (0 => '1', others => '0');
        variable temp      : std_logic := '0';
    begin
        if rising_edge(FSclk) then
            if set_seed = '1' then
                rand_temp := seed;
            end if;

            temp := xor_gates(rand_temp);
            rand_temp(23 downto 1) := rand_temp(22 downto 0);
            rand_temp(0) := temp;
        end if;

        random_out <= shift_right(signed(rand_temp(7 downto 0)), (7 - Set_Dither));
    end process;

    random_out24 <= resize(random_out, 24);

    process(random_out24, DATAin)
        variable sum : signed(23 downto 0);
    begin
        sum := signed(DATAin) + signed(random_out24);

        if (DATAin(23) = random_out24(23)) and (DATAin(23) /= sum(23)) then
            overflow <= '1';
        else
            overflow <= '0';
        end if;

        case Set_Dither is
            when 7 => DATAout <= signed(random_out24);
            when 0 => DATAout <= signed(DATAin);
            when others => DATAout <= signed(sum);
        end case;

        DATAoutLSB <= DATAout(9 downto 0);
    end process;

end Behavioral;
