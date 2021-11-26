LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.ARKANOID_COMMON.ALL;

ENTITY ball_blocks IS
    PORT (clk          : IN    STD_LOGIC;
          reset        : IN    STD_LOGIC;
          clk_bola     : IN    STD_LOGIC;
          inicio       : IN    STD_LOGIC;
          posicion_paleta : IN    STD_LOGIC_VECTOR(9 DOWNTO 0);
          Game_over  : INOUT STD_LOGIC;
          posicion_bola_x   : INOUT STD_LOGIC_VECTOR(9 DOWNTO 0);
          posicion_bola_y   : INOUT STD_LOGIC_VECTOR(9 DOWNTO 0);
          matriz_bloque : INOUT matriz);
END ENTITY;

ARCHITECTURE behavioral OF ball_blocks IS
    SIGNAL angulo_bola_x : INTEGER;
    SIGNAL angulo_bola_y : INTEGER;
    
BEGIN
    -- calculates consequences OF ball moves
    movimiento_bola : PROCESS (clk, reset, Game_over, clk_bola, inicio)
    BEGIN
        IF (reset = '1' OR Game_over = '1') THEN
            posicion_bola_x   <= "0110010000";  -- 400
            posicion_bola_y   <= "0100110010";  -- 300
            angulo_bola_x <= 1;
            angulo_bola_y <= 1;
            Game_over  <= '0';

            -- INitialize matriz_bloque
            FOR i IN 0 TO (Filas_bloques - 1) LOOP
                FOR j IN 0 TO (Columnas_bloques - 1) LOOP
                    matriz_bloque(i, j) <= '1';
                END LOOP;
            END LOOP;
            
        ELSIF ((RISING_EDGE(clk)) AND clk_bola = '1' AND inicio = '1') THEN
            posicion_bola_x <= posicion_bola_x + angulo_bola_x;
            posicion_bola_y <= posicion_bola_y + angulo_bola_y;

            -- pad bounce
            -- "11001" = 25
            -- "1111" = 15
            -- "11" = 3
            IF (((posicion_bola_y + Radio_bola) >= 550) AND
                ((posicion_bola_x >= (posicion_paleta - (TO_STDLOGICVECTOR(TO_BITVECTOR(Longitud_paleta) SRL 1)))) AND
                 (posicion_bola_x <= (posicion_paleta + (TO_STDLOGICVECTOR(TO_BITVECTOR(Longitud_paleta) SRL 1))))) AND
                (angulo_bola_y > 0)) THEN

                IF (posicion_bola_x < (posicion_paleta - "11001")) THEN
                    IF (angulo_bola_x > 0) THEN
                        angulo_bola_y <= -4;
                        angulo_bola_x <= 1;
                    ELSE
                        angulo_bola_y <= -1;
                        angulo_bola_x <= -4;
                    END IF;
                ELSIF (posicion_bola_x < (posicion_paleta - "1111")) THEN
                    IF (angulo_bola_x > 0) THEN
                        angulo_bola_y <= -3;
                        angulo_bola_x <= 1;
                    ELSE
                        angulo_bola_y <= -1;
                        angulo_bola_x <= -3;
                    END IF;
                ELSIF (posicion_bola_x < (posicion_paleta - "11")) THEN
                    IF (angulo_bola_x > 0) THEN
                        angulo_bola_y <= -2;
                        angulo_bola_x <= 1;
                    ELSE
                        angulo_bola_y <= -1;
                        angulo_bola_x <= -2;
                    END IF;
                ELSIF ((posicion_bola_x >= (posicion_paleta - 3)) AND (posicion_bola_x <= (posicion_paleta + "11"))) THEN
                    angulo_bola_y <= -1*angulo_bola_y;
                ELSIF (posicion_bola_x > (posicion_paleta + "11")) THEN
                    IF (angulo_bola_x < 0) THEN
                        angulo_bola_y <= -2;
                        angulo_bola_x <= -1;
                    ELSE
                        angulo_bola_y <= -1;
                        angulo_bola_x <= 2;
                    END IF;
                ELSIF (posicion_bola_x > (posicion_paleta + "1111")) THEN
                    IF (angulo_bola_x < 0) THEN
                        angulo_bola_y <= -3;
                        angulo_bola_x <= -1;
                    ELSE
                        angulo_bola_y <= -1;
                        angulo_bola_x <= 3;
                    END IF;
                ELSIF (posicion_bola_x > (posicion_paleta + "11001")) THEN
                    IF (angulo_bola_x < 0) THEN
                        angulo_bola_y <= -4;
                        angulo_bola_x <= -1;
                    ELSE
                        angulo_bola_y <= -1;
                        angulo_bola_x <= 4;
                    END IF;
                END IF;
            END IF;

            -- ceilINg bounce
            IF ((posicion_bola_y - Radio_bola) <= (Borde_field + "1") AND (angulo_bola_y < 0)) THEN
                angulo_bola_y <= -1*angulo_bola_y;
            END IF;

            -- right wall bounce
            -- "1100011111" = 799
            IF ((posicion_bola_x + Radio_bola) >= ("1100011111" - Borde_field) AND (angulo_bola_x > 0)) THEN
                angulo_bola_x <= -1*angulo_bola_x;
            END IF;

            -- left wall bounce
            IF ((posicion_bola_x - Radio_bola) <= (Borde_field + "1") AND (angulo_bola_x < 0)) THEN
                angulo_bola_x <= -1*angulo_bola_x;
            END IF;

            -- block bounce (matriz_bloque)
            IF (((posicion_bola_y + Radio_bola) >= Inicio_bloque_y) AND
                ((posicion_bola_y - Radio_bola) < Fin_bloque_y) AND
                ((posicion_bola_x + Radio_bola) >= Inicio_bloque_x) AND
                ((posicion_bola_x - Radio_bola) < Fin_bloque_x)) THEN

                FOR i IN 0 TO (Filas_bloques - 1) LOOP
                    FOR j IN 0 TO (Columnas_bloques - 1) LOOP
                        IF (((posicion_bola_x + Radio_bola) >= (Inicio_bloque_x + j*Ancho_bloque)) AND
                            ((posicion_bola_x - Radio_bola) < (Inicio_bloque_x + Ancho_bloque + j*Ancho_bloque)) AND
                            ((posicion_bola_y + Radio_bola) >= (Inicio_bloque_y + i*Alto_bloque)) AND
                            ((posicion_bola_y - Radio_bola) < (Inicio_bloque_y + Alto_bloque + i*Alto_bloque)) AND
                            (matriz_bloque(i, j) = '1')) THEN
                            IF ((((posicion_bola_x + Radio_bola) >= (Inicio_bloque_x + j*Ancho_bloque)) AND
                                 ((posicion_bola_x + Radio_bola) < (Inicio_bloque_x + 5 + j*Ancho_bloque))) OR 
                                (((posicion_bola_x - Radio_bola) <= (Inicio_bloque_x + Ancho_bloque + j*Ancho_bloque)) AND
                                 ((posicion_bola_x - Radio_bola) > (Inicio_bloque_x + Ancho_bloque - 5 + j*Ancho_bloque)))) THEN
                                angulo_bola_x <= -1*angulo_bola_x;
                            ELSE
                                angulo_bola_y <= -1*angulo_bola_y;
                            END IF;
                            matriz_bloque(i, j) <= '0';
                        END IF;
                    END LOOP;
                END LOOP;
            END IF;

            -- mISs!
            IF ((posicion_bola_y + Radio_bola) > 555) THEN
                Game_over <= '1';
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;
