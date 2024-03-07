
-- 07/03/2024 * Table of all ReadClock value depending
-- on SR and AVG values. When ReadCLK must be 98.304MHz,
-- bypass bit must be set high to send clock to readclock
-- without divider.
    case SR is
        when 0 => -- FSo=12kHz
            case AVG is
                when 0 => SetCnt_ReadCLK <=  64 ; -- 1.536 MHz
                when 1 => SetCnt_ReadCLK <=  64 ; -- 1.536 MHz
                when 2 => SetCnt_ReadCLK <=  64 ; -- 1.536 MHz
                when 3 => SetCnt_ReadCLK <=  64 ; -- 1.536 MHz
                when 4 => SetCnt_ReadCLK <=  64 ; -- 1.536 MHz
                when 5 => SetCnt_ReadCLK <=  64 ; -- 1.536 MHz
                when 6 => SetCnt_ReadCLK <=  32 ; -- 3.072 MHz
                when 7 => SetCnt_ReadCLK <=  8  ; -- 12.288 MHz
            end case;
        when 1 => -- FSo=24kHz
            case AVG is
                when 0 => SetCnt_ReadCLK <= 64 ; --1.536 MHz
                when 1 => SetCnt_ReadCLK <= 64 ; --1.536 MHz
                when 2 => SetCnt_ReadCLK <= 64 ; --1.536 MHz 
                when 3 => SetCnt_ReadCLK <= 32 ; --3.072 MHz 
                when 4 => SetCnt_ReadCLK <= 32 ; --3.072 MHz 
                when 5 => SetCnt_ReadCLK <= 32 ; --3.072 MHz 
                when 6 => SetCnt_ReadCLK <= 8  ; --12.288 MHz  
                when others => null ;
            end case;
        when 2 => -- FSo=48kHz
            case AVG is
                when 0 => SetCnt_ReadCLK <= 64 ; -- 1.536 MHz
                when 1 => SetCnt_ReadCLK <= 64 ; -- 1.536 MHz
                when 2 => SetCnt_ReadCLK <= 32 ; -- 3.072 MHz
                when 3 => SetCnt_ReadCLK <= 32 ; -- 3.072 MHz
                when 4 => SetCnt_ReadCLK <= 16 ; -- 6.044 MHz
                when 5 => SetCnt_ReadCLK <= 8  ; -- 12.288 MHz 
                when others => null ;
            end case;
        when 3 => -- FSo=96kHz
            case AVG is
                when 0 => SetCnt_ReadCLK <= 32 ; -- 3.072 MHz
                when 1 => SetCnt_ReadCLK <= 16 ; -- 6.144 MHz
                when 2 => SetCnt_ReadCLK <= 16 ; -- 6.144 MHz
                when 3 => SetCnt_ReadCLK <= 16 ; -- 6.144 MHz
                when 4 => SetCnt_ReadCLK <= 8  ; -- 12.288 MHz
                when others => null ;
            end case;
        when 4 => -- FSo=192kHz
            case AVG is
                when 0 => SetCnt_ReadCLK <= 16 ; -- 6.144 MHz
                when 1 => SetCnt_ReadCLK <= 8  ; -- 12.288 MHz
                when 2 => SetCnt_ReadCLK <= 8  ; -- 12.288 MHZ
                when 3 => SetCnt_ReadCLK <= 4  ; -- 24.576 MHz 
                when others => null ;
            end case;
        when 5 => -- FSo=384kHz
            case AVG is
                when 0 => SetCnt_ReadCLK <= 8 ; -- 12.288 MHz 
                when 1 => SetCnt_ReadCLK <= 2 ; -- 49.152 MHz
                when 2 => SetCnt_ReadCLK <= 2 ; -- 49.152 MHz   
                when others => null ;
            end case;   
        when 6 => -- FSo=768kHz
            case AVG is
                when 0 => SetCnt_ReadCLK <= 2 ; -- 49.152 MHz 
                when others => null ;
            end case;
        when others => null ;
    end case;

-- Generate Bypass conditions where ReadClock is the main fast clock (98.304MHz).
-- This is the ReadCLK mux command signal to choose direct (bypass) or divided clock.
-- 98.304MHz Read clock when SR=7, and when SR=6 and AVG=1
    if  SR=7 or (SR=6 and AVG=1) then
        Bypass <= '1';-- clock bypasse on
    else
        Bypass <= '0';-- clock bypasse off
    end if;