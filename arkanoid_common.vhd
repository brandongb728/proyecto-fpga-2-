LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.ARKANOID_COMMON.ALL;

PACKAGE arkanoid_common IS
    -- change these CONSTANTs TO define the number OF columns and rows OF blocks
    CONSTANT Columnas_bloques : INTEGER := 5;  -- not working for more than 3x3 blocks as OF yet... 'infinite' synthesization time
    CONSTANT Filas_bloques : INTEGER := 5;

    -- change these CONSTANTs TO define the size OF a block (in pixels)
    CONSTANT Ancho_bloque  : INTEGER := 20;  -- default: 20
    CONSTANT Alto_bloque : INTEGER := 10;  -- default: 10

    -- change Borde_field TO define how many pixels from the edge OF the screen the playing field starts
    CONSTANT Borde_field : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11110";  -- default: 30

    -- change Longitud_paleta TO define the length (width) OF the pad
    CONSTANT Longitud_paleta : STD_LOGIC_VECTOR(5 DOWNTO 0) := "111100";  -- default: 60

    -- change Radio_bola TO define the radius OF the ball
    CONSTANT Radio_bola : STD_LOGIC_VECTOR(2 DOWNTO 0) := "110";  -- default:  6

    -- in principle, these CONSTANTs should not be changed
    -- they are used TO determine the position OF the blocks in the field
    CONSTANT Inicio_bloque_y : INTEGER := 100;  -- 100
    CONSTANT Fin_bloque_y  : INTEGER := Inicio_bloque_y + Alto_bloque * Filas_bloques;  -- 130
    CONSTANT Inicio_bloque_x : INTEGER := 400 - ((Ancho_bloque / 2) * Columnas_bloques);  -- 370
    CONSTANT Fin_bloque_x  : INTEGER := Inicio_bloque_x + Ancho_bloque * Columnas_bloques;  -- 430

    -- TYPE definition for block_matriz matriz
    TYPE matriz IS ARRAY(0 TO (Columnas_bloques - 1), 0 TO (Filas_bloques - 1)) OF STD_LOGIC;
END PACKAGE;

PACKAGE BODY arkanoid_common IS
END PACKAGE BODY;
