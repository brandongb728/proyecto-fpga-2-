LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY configuracion_vga IS 
GENERIC(
   polar_horizontal  : STD_LOGIC := '1';
   polar_vertical    : STD_LOGIC := '1';
   ancho_pantalla    : INTEGER := 1600;
   alto_pantalla     : INTEGER := 900;
   frente_horizontal : INTEGER := 24;
   pulso_h_sync      : INTEGER := 80;
   atras_horizontal  : INTEGER := 96;
   frente_vertical   : INTEGER := 1;
   pulso_v_sync      : INTEGER := 3;
   atras_vertical    : INTEGER := 96);
PORT (
	clk	: IN STD_LOGIC;
	h_sync : OUT STD_LOGIC;
	v_sync : OUT STD_LOGIC;
	nuevo_frame : OUT STD_LOGIC;
	horizontal_actual : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	vertical_actual : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
 
END ENTITY;
 
ARCHITECTURE behaviour OF configuracion_vga IS

CONSTANT periodo_horizontal : INTEGER := ancho_pantalla  + frente_horizontal + pulso_h_sync + atras_horizontal;
CONSTANT periodo_vertical : INTEGER := alto_pantalla + frente_vertical + pulso_v_sync + atras_vertical;
 
BEGIN

PROCESS (clk)
        VARIABLE contador_horizontal : INTEGER RANGE 0 TO periodo_horizontal - 1 := 0;
        VARIABLE contador_vertical : INTEGER RANGE 0 TO periodo_vertical - 1 := 0;
    BEGIN
        IF(RISING_EDGE(clk)) THEN
            IF (contador_horizontal = periodo_horizontal - 1) THEN
                contador_horizontal := 0;
                IF (contador_vertical = periodo_vertical - 1) THEN
                    contador_vertical := 0;
                ELSE 
                    contador_vertical := contador_vertical + 1;
                END IF;
            ELSE
                contador_horizontal := contador_horizontal + 1;
            END IF;

            IF (contador_horizontal < ancho_pantalla + frente_horizontal OR 
                contador_horizontal >= ancho_pantalla + frente_horizontal + pulso_h_sync) THEN 
                h_sync <= NOT polar_horizontal;
            ELSE 
                h_sync <= polar_horizontal;
            END IF;

            IF (contador_vertical < alto_pantalla + frente_vertical OR 
                contador_vertical >= alto_pantalla + frente_vertical + pulso_v_sync) THEN
                v_sync <= NOT polar_vertical;
            ELSE 
                v_sync <= polar_vertical;
            END IF;
            
            IF (contador_horizontal < ancho_pantalla AND contador_vertical < alto_pantalla) THEN 
                nuevo_frame <= '1';
            ELSE 
                nuevo_frame <= '0';
            END IF;

            vertical_actual <= STD_LOGIC_VECTOR(TO_UNSIGNED(contador_vertical, vertical_actual'LENGTH));
            horizontal_actual <= STD_LOGIC_VECTOR(TO_UNSIGNED(contador_horizontal, horizontal_actual'LENGTH));
        END IF;
    END PROCESS;

END ARCHITECTURE;