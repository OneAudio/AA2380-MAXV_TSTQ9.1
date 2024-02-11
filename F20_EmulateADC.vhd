-----------------------------------------------------------------
-- AA2380V1 OSVA PROJECT.
-- Date: 23/12/20	Designer: O.N
-- Design notes, please read : "SPECIF_SPI_LTC2380-24.vhd" and
-- "F1_readADC_multimodes.xls"
-----------------------------------------------------------------
-- This module is to emulate LTC2380-24 ADC signals
-- behaviour for testing purpose only.
--
-- Update from 23/12/2020 :
-- Auto reset shift register if no clock betweeen two CNV pulse,
-- or if 24 SCK clock shift are done (in any number of conversion).
-- Take 127 LE.
------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity F20_EmulateADC is
--
port(
  -- Inputs ports

  MCLK	 	      : in std_logic  ; -- Master clock
  DATADC        : in std_logic_vector(23 downto 0)  ; -- Signal to be send at SDO serial out (Emulated ADC data)
  -- ADC signals
  CNV           : in std_logic ; -- ADC start conv signal (rising_edge)
  SCK           : in std_logic ; -- ADC data read clock
  BUSY          : out std_logic  ; -- BUSY output (conversion in progress, fixed duration of 400ns)
  SDO           : out std_logic ;  -- ADC data output
  -- Test output only
  tst_CLEAR_REG     : out std_logic ;
  tst_CLEAR_MOY     : out std_logic ;
  tst_SCK_count    : out integer range 0 to 32;
  tst_loadSR		: out std_logic;
  tst_READ_end		: out std_logic 
);

end F20_EmulateADC;

architecture Behavioral of F20_EmulateADC is
--

signal  Busy_count  : integer range 0 to 63 ;
signal  BUSY_on     : std_logic ;
signal  Busy_end    : std_logic ;
signal  SRDATA      : std_logic_vector(23 downto 0);
signal  SSCK        : std_logic ;

signal  QA          : std_logic ;
signal  QB          : std_logic ;
signal  CLEAR_REG   : std_logic ;
signal  CLEAR_MOY   : std_logic ;

signal  CLS_count   : std_logic ;
signal  CLS         : std_logic ;

signal SCK_count    : integer range 0 to 32 ;

signal LOAD_SR      : std_logic ;
signal READ_end     : std_logic ;


begin

--- Copy of signals for tests purpose
tst_CLEAR_REG <= CLEAR_REG  ; -- TEst output
tst_CLEAR_MOY <= CLEAR_MOY  ; -- TEst output
tst_SCK_count <= SCK_count  ; -- TEst output
tst_loadSR	  <= LOAD_SR    ;
tst_READ_end  <= READ_end   ;

------------------------------------------------------------------
-- Function to emulate busy of DAC for simulation purpose
-- Generate 400 ns pulse when rising_edge of CNV (start conversion)
------------------------------------------------------------------
Emulate_Busy : process(CNV,MCLK,Busy_end,Busy_on)
begin
      if      Busy_end='1'  then
              BUSY_on <= '0'  ; --
      elsif   rising_edge(CNV) then
              BUSY_on <= '1'  ; --
      end if;
      --
      if    rising_edge(MCLK) then
            if   BUSY_on='1' then
              Busy_count <= Busy_count + 1 ; --
                if    Busy_count= 35  then -- 35x10ns =350ns pulse width 
                      Busy_end <= '1'  ; --
                else
                      Busy_end <= '0'  ; --
                end if;
            else
                Busy_count  <=  0  ;
                Busy_end    <= '0' ;
            end if;
      end if;
BUSY <= BUSY_on ;


end process Emulate_Busy ;
------------------------------------------------------------------
--- MODULE 2 SEULEMENT POUR TEST------------------------------------
------------------------------------------------------------------
-- A partir de donnée d'un bus parrallele 24 bits,
-- génére des valeurs
-- en série à la place de SDOR et SDOL (valeurs série des ADC).
------------------------------------------------------------------
Emulate_SDO : process(CNV,DATADC,SCK,SRDATA,SSCK,MCLK,CLEAR_REG,QA,QB,CLEAR_MOY,SCK_count,READ_end,LOAD_SR)
begin
      -- Reset if no SCK betweeb 2 CNV conversion pulse.
      if    SCK='1'            then
            QA  <= '0';
            QB  <= '0';
      elsif rising_edge(CNV)   then
            QA  <= '1'  ;
            QB  <= QA   ;
      end if;
      CLEAR_MOY <=  QB and CNV  ;
      --

      --PARTIE A REVOIR !! en dessous.

     -- Check number of SCK shift
       if      (CNV='1' and SCK_count=23) or CLEAR_MOY='1'  then -- ON le 08/02/24 : on reset aussi le compteur SCK_count si clear_moy est actif
               SCK_count <= 0   ;
               CLEAR_REG <= '0'  ;
      elsif    rising_edge(SCK) then
            --
            if    SCK_count>=22  then
                  READ_end <= '1' ;
            else
                  READ_end <= '0' ;
            end if;
            --
            if    SCK_count=23  then
                  CLEAR_REG <= '1'  ;
            else
                  SCK_count <= SCK_count +1 ;
            end if;

      end if;

      LOAD_SR <= CNV and READ_end ;--

      -- Shift register update  
      if    CLEAR_MOY='1' or  LOAD_SR='1' then
      --if    CNV='1'  then -- test
            SRDATA <= DATADC;
      elsif rising_edge(SCK)   then
            SRDATA <= SRDATA(22 downto 0) & '0'  ; -- décalage d'un bit à chaque front montant de SCK
      end if;
SDO <= SRDATA(23)  ; -- Le MSB de xDOSL est la sortie série

end process Emulate_SDO ;


end Behavioral ;
