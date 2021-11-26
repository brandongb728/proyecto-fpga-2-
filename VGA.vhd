LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.ARKANOID_COMMON.ALL;

ENTITY VGA IS
    pORt (clk           : IN  STD_LOGIC;
          posicion_bola_x    : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
          posicion_bola_y    : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
          matriz_bloque  : IN  matriz;
          Posicion_paleta       : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
          V_SYNCH    : OUT STD_LOGIC;
          H_SYNCH    : OUT STD_LOGIC;
          Azul  : OUT STD_LOGIC;
          Rojo   : OUT STD_LOGIC;
          Verde : OUT STD_LOGIC;
          led           : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY;

ARCHITECTURE behavioral OF VGA IS
    SIGNAL contador_fila    : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL contador_columna : STD_LOGIC_VECTOR(11 DOWNTO 0);

BEGIN
    -- generates h-sync AND v-sync VGA SIGNALs
    video_synch : PROCESS(clk)
    BEGIN
        IF(RISING_EDGE(clk)) THEN
            IF(contador_fila >= 637 AND contador_fila < 643) THEN
                V_SYNCH <= '0';
            ELSE
                V_SYNCH <= '1';
            END IF;
            IF(contador_columna >= 856 AND contador_columna < 976) THEN
                H_SYNCH <= '0';
            ELSE
                H_SYNCH <= '1';
            END IF;
        END IF;
    END PROCESS;

    -- keeps track OF VGA rows AND columns
    video_rows_cols : PROCESS (clk)
    BEGIN
        IF(RISING_EDGE(clk)) THEN
            contador_columna <= contador_columna + 1;
            IF(contador_columna = 1040) THEN
                contador_columna <= "000000000000";
                contador_fila    <= contador_fila + 1;
            END IF;

            IF(contador_fila = 666) THEN
                contador_fila <= "000000000000";
            END IF;
        END IF;
    END PROCESS;

    -- draw the screen
    draw : PROCESS (clk)
    BEGIN
        IF (RISING_EDGE(clk)) THEN

            -- draw the field  
            -- "1001011000" = 600 
            -- "1100100000" = 800
            IF (((contador_fila = Borde_field OR contador_fila = ("1001011000"-Borde_field)) AND contador_columna >= Borde_field AND contador_columna <= ("1100100000"-Borde_field)) OR
                (contador_fila > Borde_field AND contador_fila < ("1001011000"-Borde_field) AND (contador_columna = Borde_field OR contador_columna = ("1100100000"-Borde_field)))) THEN
                Rojo   <= '1';
                Verde <= '0';
                Azul  <= '0';
            ELSE
                Rojo   <= '0';
                Verde <= '0';
                Azul  <= '0';
            END IF;

            -- draw the blocks (matriz_bloque)
            IF ((contador_fila >= Inicio_bloque_y) AND (contador_fila < Fin_bloque_y) AND
                (contador_columna >= Inicio_bloque_x) AND (contador_columna < Fin_bloque_x)) THEN

                FOR i IN 0 TO (Filas_bloques - 1) LOOP
                    FOR j IN 0 TO (Columnas_bloques - 1) LOOP
                        IF (((((contador_fila = (Inicio_bloque_y + i*Alto_bloque)) OR
                               (contador_fila = (Inicio_bloque_y + Alto_bloque - 1 + i*Alto_bloque))) AND 
                              (contador_columna >= (Inicio_bloque_x + j*Ancho_bloque)) AND
                              (contador_columna < (Inicio_bloque_x + Ancho_bloque + j*Ancho_bloque))) OR
                             ((contador_fila >= (Inicio_bloque_y + i*Alto_bloque)) AND
                              (contador_fila < (Inicio_bloque_y + Alto_bloque + i*Alto_bloque)) AND
                              ((contador_columna = (Inicio_bloque_x + j*Ancho_bloque)) OR
                               (contador_columna = (Inicio_bloque_x + Ancho_bloque - 1 + j*Ancho_bloque))))) AND 
                            (matriz_bloque(i, j) = '1')) THEN

                            Rojo   <= '1';
                            Verde <= '1';
                            Azul  <= '0';
                        ELSIF ((contador_fila > (Inicio_bloque_y + i*Alto_bloque)) AND
                               (contador_fila < (Inicio_bloque_y + Alto_bloque - 1 + i*Alto_bloque)) AND
                               (contador_columna > (Inicio_bloque_x + j*Ancho_bloque)) AND
                               (contador_columna < (Inicio_bloque_x + Ancho_bloque - 1 + j*Ancho_bloque)) AND
                               (matriz_bloque(i, j) = '1')) THEN

                            Rojo   <= '0';
                            Verde <= '0';
                            Azul  <= '1';
                        END IF;
                    END LOOP;
                END LOOP;
            END IF;

            -- draw the pad
            IF (contador_fila >= 550 AND contador_fila < 560) THEN
                IF ((contador_fila = 550) AND ((contador_columna >= (Posicion_paleta - 3)) AND (contador_columna <= (Posicion_paleta + 3)))) THEN
                    Rojo   <= '1';
                    Verde <= '0';
                    Azul  <= '1';
                ELSIF ((contador_fila = 551) AND ((contador_columna >= Posicion_paleta - 8) AND (contador_columna <= Posicion_paleta + 8))) THEN
                    Rojo   <= '1';
                    Verde <= '0';
                    Azul  <= '1';
                ELSIF ((contador_fila = 552) AND ((contador_columna >= Posicion_paleta - 15) AND (contador_columna <= Posicion_paleta + 15))) THEN
                    Rojo   <= '1';
                    Verde <= '0';
                    Azul  <= '1';
                ELSIF ((contador_fila = 553) AND ((contador_columna >= Posicion_paleta - 19) AND (contador_columna <= Posicion_paleta + 19))) THEN
                    Rojo   <= '1';
                    Verde <= '0';
                    Azul  <= '1';
                ELSIF ((contador_fila = 554) AND ((contador_columna >= Posicion_paleta - 23) AND (contador_columna <= Posicion_paleta + 23))) THEN
                    Rojo   <= '1';
                    Verde <= '0';
                    Azul  <= '1';
                ELSIF ((contador_fila = 555) AND ((contador_columna >= Posicion_paleta - 27) AND (contador_columna <= Posicion_paleta + 27))) THEN
                    Rojo   <= '1';
                    Verde <= '0';
                    Azul  <= '1';
                ELSIF ((contador_fila = 556) AND ((contador_columna >= Posicion_paleta - 29) AND (contador_columna <= Posicion_paleta + 29))) THEN
                    Rojo   <= '1';
                    Verde <= '0';
                    Azul  <= '1';
                ELSIF ((contador_fila >= 557) AND
                       (contador_columna >= (Posicion_paleta - (TO_STDLOGICVECTOR(TO_BITVECTOR(Longitud_paleta) SRL 1))) AND
                        contador_columna <= (Posicion_paleta + (TO_STDLOGICVECTOR(TO_BITVECTOR(Longitud_paleta) SRL 1))))) THEN
                    Rojo   <= '1';
                    Verde <= '0';
                    Azul  <= '1';
                ELSIF (contador_columna = Borde_field OR contador_columna = ("1100100000" - Borde_field)) THEN
                    Rojo   <= '1';
                    Verde <= '0';
                    Azul  <= '0';
                ELSE
                    Rojo   <= '0';
                    Verde <= '0';
                    Azul  <= '0';
                END IF;
            END IF;

            -- draw the ball
            IF (contador_fila > (posicion_bola_y - Radio_bola) AND contador_fila < (posicion_bola_y + Radio_bola)) THEN
                IF ((contador_fila = (posicion_bola_y - Radio_bola + 1) OR contador_fila = (posicion_bola_y + Radio_bola - 1)) AND
                    (contador_columna >= (posicion_bola_x - 1) AND contador_columna <= (posicion_bola_x +1))) THEN
                    Rojo   <= '0';
                    Verde <= '1';
                    Azul  <= '1';
                ELSIF ((contador_fila = (posicion_bola_y - Radio_bola + 2) OR contador_fila = (posicion_bola_y + Radio_bola - 2)) AND
                       (contador_columna >= (posicion_bola_x - 3) AND contador_columna <= (posicion_bola_x +3))) THEN
                    Rojo   <= '0';
                    Verde <= '1';
                    Azul  <= '1';
                ELSIF ((contador_fila = (posicion_bola_y - Radio_bola + 3) OR contador_fila = (posicion_bola_y + Radio_bola - 3)) AND
                       (contador_columna >= (posicion_bola_x - 4) AND contador_columna <= (posicion_bola_x +4))) THEN
                    Rojo   <= '0';
                    Verde <= '1';
                    Azul  <= '1';
                ELSIF ((contador_fila = (posicion_bola_y - Radio_bola + 4) OR contador_fila = (posicion_bola_y + Radio_bola - 4)) AND
                       (contador_columna >= (posicion_bola_x - 4) AND contador_columna <= (posicion_bola_x +4))) THEN
                    Rojo   <= '0';
                    Verde <= '1';
                    Azul  <= '1';
                ELSIF ((contador_fila >= (posicion_bola_y - Radio_bola + 5) AND contador_fila <= (posicion_bola_y + Radio_bola - 5)) AND
                       (contador_columna >= (posicion_bola_x - 5) AND contador_columna         <= (posicion_bola_x +5))) THEN
                    Rojo   <= '0';
                    Verde <= '1';
                    Azul  <= '1';
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- lights up led accORdINg TO position OF ball
    walkINg_leds : PROCESS (clk, posicion_bola_x)
    BEGIN
        IF (RISING_EDGE(clk)) THEN
            IF (posicion_bola_x >= 700) THEN
                led <= "00000001";
            ELSIF (posicion_bola_x >= 600) THEN
                led <= "00000010";
            ELSIF (posicion_bola_x >= 500) THEN
                led <= "00000100";
            ELSIF (posicion_bola_x >= 400) THEN
                led <= "00001000";
            ELSIF (posicion_bola_x >= 300) THEN
                led <= "00010000";
            ELSIF (posicion_bola_x >= 200) THEN
                led <= "00100000";
            ELSIF (posicion_bola_x >= 100) THEN
                led <= "01000000";
            ELSIF (posicion_bola_x >= 0) THEN
                led <= "10000000";
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;

