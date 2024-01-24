-- PE le 02/06/2011
-- pour le pilotage du variateur de vitesse de l'extracteur de brouillard de la chambre de vision
--
-- PRINCIPE :
-- Tranforme une commande Marche/Arrêt en une commande Marche/Freine/Arrêt 
-- Donc quand le signal de commande passe à 0, il faut envoyer la commande de freinage pendant un "certain temps" 
-- avant de le mettre à l'arrêt.
-- Pour envoyer une commande au variateur il faut lui envoyer un pulse d'une longueur donnée, cette boite donne 
-- la longueur du pulse à générer. Un compteur interne compte plusieurs coups de CLK pour faire la tempo de freinage.
-- La durée de cette tempo est pour le moment codée en dur.
--
-- Pour ce variateur voici les longueurs de pulse de commande :
-- frein      : pulse de 1.107ms                                     
-- Arret      : pulse de 1.540ms                                     
-- tourne     : pulse de 1.620ms                                     
-- tourne_max : pulse de 1.924ms                                     



LIBRARY ieee;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_1164.all;
LIBRARY lpm;
USE lpm.lpm_components.all;
LIBRARY altera;
USE altera.maxplus2.all;

ENTITY pilote_variateur IS
	PORT(
		CLK			   		: IN    STD_LOGIC;	  	    			-- la clock
		COMMANDE			: IN	STD_LOGIC;						-- le signal MARCHE/ARRET de l'extracteur de brouillard
		LENGTH   			: OUT   STD_LOGIC_VECTOR(15 downto 0)	-- la longueur du pulse a envoyer au variateur de vitesse : unité=0.1µs
		);
END pilote_variateur;

ARCHITECTURE main OF pilote_variateur IS
	type machine is (	
						ARRET,  	 			-- variateur à l'arrêt
						TOURNE,     			-- le variateur tourne à vitesse normale
					 	FREINE	       			-- le variateur freine
					);
signal etape : machine;							-- Etape de la machine d'état

BEGIN
	PROCESS
	variable cpt_frein:INTEGER RANGE 0 TO 200; 	-- compteur pour tempo durée du freinage
    
	BEGIN
		WAIT UNTIL CLK'event and CLK ='1'; 		-- sur front montant de l'horloge CLK
			case etape is

				when ARRET	=>					-- variateur à l'arrêt
					LENGTH <= CONV_STD_LOGIC_VECTOR(15400, 16);
					if (COMMANDE = '1') then	-- attend que le signal de commande passe à 1  
						etape <= TOURNE;
					end if;
						
				when TOURNE =>					-- le variateur tourne à vitesse normale
					LENGTH <= CONV_STD_LOGIC_VECTOR(16200, 16);
					if (COMMANDE = '0') then	-- attend que le signal de commande repasse à 0
						etape <= FREINE;
						cpt_frein := 100;		-- init tempo de freinage à 100ms (CLK=1kHz, cpt=100)
					end if;
					
				when FREINE =>					-- le variateur freine
					LENGTH <= CONV_STD_LOGIC_VECTOR(11070, 16);
					if (COMMANDE = '1') then	-- si le signal COMMANDE repasse à 1 pendant que l'on freine 
						etape <= TOURNE;        -- on refait tourner le variateur (COMMANDE prioritaire)
					else            
						cpt_frein := cpt_frein - 1;	-- decremente compteur de freinage
						if (cpt_frein = 0) then     -- si fin de tempo de freinage
							etape <= ARRET;         -- retour à l'arrêt
						end if;
					end if;

				When OTHERS =>
					etape <= ARRET;

			end case;
	END PROCESS;
END main;

