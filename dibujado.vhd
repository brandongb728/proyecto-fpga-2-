LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; 

ENTITY dibujado IS 
GENERIC(
   ancho_pantalla  : INTEGER := 1600;  
   alto_pantalla   : INTEGER := 900;
   ancho_comida    : INTEGER := 40;
   ancho_cabeza    : INTEGER := 40;
   posini_snake_x  : INTEGER := 450;
   posini_snake_y  : INTEGER := 300;
   largo_ini_snake : INTEGER := 2;
   largo_max_snake : INTEGER := 40;
   posini_comida_x  : INTEGER := 500;
   posini_comida_y  : INTEGER := 800);
PORT (
   clk_60hz	: IN STD_LOGIC;
   clk_vga	: IN STD_LOGIC;
	en : IN STD_LOGIC;
	reset  	: IN STD_LOGIC;
	direccion : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
   stop : IN  STD_LOGIC;
	fila, columna : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
   debug_led     : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
   rojo, verde, azul : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END ENTITY;
 
ARCHITECTURE behaviour OF dibujado IS
 SUBTYPE xy IS STD_LOGIC_VECTOR(31 DOWNTO 0);
 TYPE xys IS ARRAY (INTEGER RANGE <>) OF xy;
 SIGNAL largo_snake  : INTEGER RANGE 0 TO largo_max_snake;
 SIGNAL malla_snake_xy : xys(0 TO largo_max_snake - 1);
 SIGNAL comida_xy       : xy;
 SIGNAL random_xy     : UNSIGNED(31 DOWNTO 0);
BEGIN
movimiento_snake:
    PROCESS(clk_60hz, reset, random_xy)
        CONSTANT velocidad_snake    : SIGNED(15 DOWNTO 0) := TO_SIGNED(6, 16);
        VARIABLE inicio                : STD_LOGIC := '0';
        VARIABLE cabeza_snake_xy_siguiente  : xy := (OTHERS => '0');
        VARIABLE comida_xy_siguiente      : xy := (OTHERS => '0');
        VARIABLE largo_snake_siguiente    : INTEGER := 0;
        VARIABLE dx, dy                : SIGNED(15 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        comida_xy         <= comida_xy_siguiente;
        largo_snake    <= largo_snake_siguiente;
        IF (reset = '1' OR inicio = '0') THEN
            largo_snake_siguiente := largo_ini_snake;
            comida_xy_siguiente(31 DOWNTO 16) := STD_LOGIC_VECTOR(TO_SIGNED(posini_comida_x, 16));
            comida_xy_siguiente(15 DOWNTO 0) := STD_LOGIC_VECTOR(TO_SIGNED(posini_comida_y, 16));
            cabeza_snake_xy_siguiente(31 DOWNTO 16)  := STD_LOGIC_VECTOR(TO_SIGNED(posini_snake_x , 16));
            cabeza_snake_xy_siguiente(15 DOWNTO 0)   := STD_LOGIC_VECTOR(TO_SIGNED(posini_snake_y , 16));

            FOR i IN 0 TO largo_max_snake - 1 LOOP
                malla_snake_xy(i) <= cabeza_snake_xy_siguiente;
            END LOOP;
            
            inicio := '1';
        ELSIF (RISING_EDGE(clk_60hz)) THEN
            IF (stop = '0') THEN
                CASE direccion is
                    WHEN("00") =>       --arriba
                        cabeza_snake_xy_siguiente(15 DOWNTO 0) := STD_LOGIC_VECTOR(SIGNED(cabeza_snake_xy_siguiente(15 DOWNTO 0)) - velocidad_snake);
                    WHEN("01") =>       --derecha
                        cabeza_snake_xy_siguiente(31 DOWNTO 16) := STD_LOGIC_VECTOR(SIGNED(cabeza_snake_xy_siguiente(31 DOWNTO 16)) + velocidad_snake);
                    WHEN("10") =>       --abajo
                        cabeza_snake_xy_siguiente(15 DOWNTO 0) := STD_LOGIC_VECTOR(SIGNED(cabeza_snake_xy_siguiente(15 DOWNTO 0)) + velocidad_snake);
                    WHEN("11") =>       --izquierda
                        cabeza_snake_xy_siguiente(31 DOWNTO 16) := STD_LOGIC_VECTOR(SIGNED(cabeza_snake_xy_siguiente(31 DOWNTO 16)) - velocidad_snake);
                END CASE;
                FOR i IN largo_max_snake - 1 DOWNTO 1 LOOP
                    malla_snake_xy(i) <= malla_snake_xy(i - 1);
                END LOOP;
                malla_snake_xy(0) <= cabeza_snake_xy_siguiente; 

                IF (SIGNED(cabeza_snake_xy_siguiente(31 DOWNTO 16)) < 0 OR 
                    SIGNED(cabeza_snake_xy_siguiente(31 DOWNTO 16)) >= ancho_pantalla OR
                    SIGNED(cabeza_snake_xy_siguiente(15 DOWNTO 0)) < 0 OR
                    SIGNED(cabeza_snake_xy_siguiente(15 DOWNTO 0)) >= alto_pantalla) THEN
                    inicio := '0';
                END IF;

                dx := ABS(SIGNED(cabeza_snake_xy_siguiente(31 DOWNTO 16)) - SIGNED(comida_xy_siguiente(31 DOWNTO 16)));
                dy := ABS(SIGNED(cabeza_snake_xy_siguiente(15 DOWNTO 0))  - SIGNED(comida_xy_siguiente(15 DOWNTO 0)));
                IF (dy < (ancho_comida + ancho_cabeza) / 2 and
                    dx < (ancho_comida + ancho_cabeza) / 2) THEN
                    largo_snake_siguiente := largo_snake_siguiente + 1;
                    comida_xy_siguiente := STD_LOGIC_VECTOR(random_xy);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    debug_led <= STD_LOGIC_VECTOR(random_xy(23 DOWNTO 0));

numero_random: PROCESS(clk_vga)
        VARIABLE random_x : UNSIGNED(15 DOWNTO 0) := (OTHERS => '0');
        VARIABLE random_y : UNSIGNED(15 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        IF (RISING_EDGE(clk_vga)) THEN
            IF (random_x = TO_UNSIGNED(ancho_pantalla - 14, 16)) THEN 
                random_x := (OTHERS => '0');
            END IF;
            IF (random_y = TO_UNSIGNED(alto_pantalla - 14, 16)) THEN 
                random_y := (OTHERS => '0');
            END IF;
            random_x := random_x + 1;
            random_y := random_y + 1;
            random_xy(31 DOWNTO 16) <= random_x + 7;
            random_xy(15 DOWNTO 0) <= random_y + 7;
        END IF;
    END PROCESS;

dibujar: PROCESS(largo_snake, malla_snake_xy, comida_xy, fila, columna, en)
        VARIABLE dx, dy             : SIGNED(15 DOWNTO 0) := (OTHERS => '0');
        VARIABLE is_body, is_food   : STD_LOGIC := '0';
    BEGIN
        IF (en = '1') THEN 
            is_body := '0';
            FOR i IN 0 TO largo_max_snake - 1 LOOP
                dx := ABS(SIGNED(columna) - SIGNED(malla_snake_xy(i)(31 DOWNTO 16)));
                dy := ABS(SIGNED(fila) - SIGNED(malla_snake_xy(i)(15 DOWNTO 0)));
                IF (i < largo_snake) THEN 
                    IF (dx < ancho_cabeza / 2 and dy < ancho_cabeza / 2) THEN
                        is_body := '1';
                    END IF;
                END IF;
            END LOOP;
            dx := ABS(SIGNED(columna) - SIGNED(comida_xy(31 DOWNTO 16)));
            dy := ABS(SIGNED(fila) - SIGNED(comida_xy(15 DOWNTO 0)));
            IF (dx < ancho_comida / 2 and dy < ancho_comida / 2) THEN
                is_food := '1';
            ELSE 
                is_food := '0';
            END IF;

            IF (is_body = '1') THEN
                rojo <= "1111";
                verde <= "0000";
                azul <= "1111";
            ELSIF (is_food = '1') THEN
                rojo <= "0000";
                verde <= "1111";
                azul <= "1100";
            ELSE 
                rojo <= "0000";
                verde <= "0000";
                azul <= "0000";
            END IF;
        ELSE 
            rojo <= "0000";
            verde <= "0000";
            azul <= "0000";
        END IF;
    END PROCESS;
END ARCHITECTURE;