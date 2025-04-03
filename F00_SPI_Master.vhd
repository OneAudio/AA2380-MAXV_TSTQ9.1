library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;



--              SPI_mode table

--              Mode | Clock Polarity (CPOL/CKP) | Clock Phase (CPHA)
--               0   |             0             |        0
--               1   |             0             |        1
--               2   |             1             |        0
--               3   |             1             |        1

entity F00_spi_master is 
	generic(
		
		SPI_Mode 			: integer := 0;
		CLK_per_half_bit 	: integer := 1					-- sets frequency of SPI clock
		
	
	);
	port ( 
	
		clk 		: in std_logic;
		reset		: in std_logic;
		
		 -- MOSI Signals
		Tx_Byte   	: in std_logic_vector(7 downto 0);   	-- Byte to transmit on MOSI
		Tx_DV     	: in std_logic;          				-- Data Valid Pulse 
		Tx_Ready  	: out std_logic;         				-- Transmit Ready for next byte
		   
		   -- MISO Signals
		Rx_DV   	: out std_logic;    					-- Data Valid pulse (1 clock cycle)
		Rx_Byte 	: out std_logic_vector(7 downto 0);   	-- Byte received on MISO

		   -- SPI Interface
		SPI_clk  	: out std_logic;
		SPI_MISO 	: in  std_logic;
		SPI_MOSI 	: out std_logic;
		SPI_CS   	: out std_logic							-- chip select

   
	);
			
end entity;
	
	
architecture RTL of F00_spi_master is

	signal clk_phase		: std_logic := '0';
	signal clk_polarity		: std_logic := '0';
	signal SPI_clock		: std_logic := '0';
	signal SPI_clk_counter	: integer := 0;
	signal bit_counter		: integer range 0 to 7 := 0;
	signal Tx_Byte_reg		: std_logic_vector(7 downto 0) := (others => '0');
	signal Rx_Byte_reg		: std_logic_vector(7 downto 0) := (others => '0');
	signal Tx_DV_delayed	: std_logic := '0';
	signal Rx_DV_reg		: std_logic := '0';
	signal Tx_Ready_reg		: std_logic := '1';
	signal CS_bit			: std_logic := '1'; -- Active low CS
	signal SPI_MISO_reg     : std_logic := '0';
	

begin

	clk_phase	 <= '1' when (SPI_Mode = 1) or (SPI_Mode = 3) else '0';		
	clk_polarity <= '1' when (SPI_Mode = 2) or (SPI_Mode = 3) else '0';
	
	-- Clock generation
	process(clk, reset)
	begin
		if reset = '1' then
		
			SPI_clk_counter <= 0;
			SPI_clock 		<= clk_polarity;
			
		elsif rising_edge(clk) then
		
			if SPI_clk_counter = CLK_per_half_bit - 1 then
			
				SPI_clk_counter <= 0;
				SPI_clock 		<= not SPI_clock;
			else
				SPI_clk_counter <= SPI_clk_counter + 1;
			end if;
		end if;
	end process;
	
	-- Transmit and receive logic
	process(clk, reset)
	begin
		if reset = '1' then
		
			Tx_Byte_reg 	<= (others => '0');
			Rx_Byte_reg 	<= (others => '0');
			bit_counter 	<= 0;
			Rx_DV_reg 		<= '0';
			Tx_Ready_reg 	<= '1';
			Tx_DV_delayed 	<= '0';
			CS_bit 			<= '1';
			SPI_MISO_reg    <= '0'; 
			
		elsif rising_edge(clk) then
		
			Tx_DV_delayed	<= Tx_DV;
			SPI_MISO_reg    <= SPI_MISO;
		
			if Tx_DV = '1' and Tx_DV_delayed = '0' then
			
				Tx_Byte_reg 	<= Tx_Byte;
				bit_counter 	<= 0;
				Tx_Ready_reg 	<= '0';
				CS_bit 			<= '0'; 									-- Assert CS
				
				
			end if;
			
			if SPI_clock = '1' and clk_phase = '0' then
			
             Rx_Byte_reg <= Rx_Byte_reg(6 downto 0) & SPI_MISO_reg;
             
             elsif SPI_clock = '0' and clk_phase = '1' then
             
              Rx_Byte_reg <= Rx_Byte_reg(6 downto 0) & SPI_MISO_reg;
            end if;
			
			
			if SPI_clock = not clk_phase then
			
				SPI_MOSI 		<= Tx_Byte_reg(7);
				Tx_Byte_reg		<= Tx_Byte_reg(6 downto 0) & '0';
				
				if bit_counter = 7 then										--indicates completion of 8-bit transmission 
				
					bit_counter 	<= 0;
					Rx_DV_reg 		<= '1';
					Tx_Ready_reg 	<= '1';
					CS_bit 			<= '1'; 								-- Deassert CS
				else
					bit_counter 	<= bit_counter + 1;
					Rx_DV_reg 		<= '0';
				end if;
			end if;
		end if;
	end process;

	SPI_clk 	<= SPI_clock;
	Tx_Ready 	<= Tx_Ready_reg;
	Rx_DV 		<= Rx_DV_reg;
	Rx_Byte 	<= Rx_Byte_reg;
	SPI_CS     <= CS_bit when rising_edge(clk);

	
end RTL;