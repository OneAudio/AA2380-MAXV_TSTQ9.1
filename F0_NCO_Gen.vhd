library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity F0_NCO_Gen is
    generic (
        FCLOCK         : natural := 24576000; -- Horloge en Hz
        FMIN           : natural := 250;     -- Fr�quence de sortie minimale en Hz
        FMAX           : natural := 512000;  -- Fr�quence de sortie maximale en Hz
        LUT_SIZE       : natural := 96       -- Taille de la LUT
    );
    Port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        phase_inc  : in  unsigned(15 downto 0); -- Largeur ajust�e � 16 bits
        dither_in  : in  signed(3 downto 0);
        phase_lut  : out unsigned(6 downto 0) -- Largeur ajust�e � 7 bits pour LUT 96
    );
end F0_NCO_Gen;

architecture Behavioral of F0_NCO_Gen is
    -- Largeurs fix�es manuellement pour �viter les fonctions math�matiques
    constant PHASE_ACC_WIDTH : natural := 24; -- Largeur de l'accumulateur
    constant PHASE_INC_WIDTH : natural := 16; -- Largeur de l'incr�ment de phase
    constant LUT_WIDTH       : natural := 7;  -- Largeur pour indexer la LUT (96 points)

    signal phase_acc       : signed(PHASE_ACC_WIDTH-1 downto 0) := (others => '0');
    signal dither_ext      : signed(PHASE_ACC_WIDTH-1 downto 0);
    signal phase_with_dith : signed(PHASE_ACC_WIDTH-1 downto 0);
    signal phase_inc_ext   : signed(PHASE_ACC_WIDTH-1 downto 0);

begin
    -- Extension de phase_inc
    phase_inc_ext <= resize(signed(phase_inc), PHASE_ACC_WIDTH);
    
    -- Extension du dither
    dither_ext <= resize((dither_in & "00000000"), PHASE_ACC_WIDTH);
    
    -- Accumulateur de phase synchrone
    process(clk, rst)
    begin
        if rst = '1' then
            phase_acc <= (others => '0');
        elsif rising_edge(clk) then
            phase_acc       <= phase_acc + phase_inc_ext;
            phase_with_dith <= phase_acc + dither_ext;
            phase_lut      <= unsigned(phase_with_dith(PHASE_ACC_WIDTH-1 downto PHASE_ACC_WIDTH-LUT_WIDTH));
        end if;
    end process;
end Behavioral;
