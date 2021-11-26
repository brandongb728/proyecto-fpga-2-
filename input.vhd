LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.ARKANOID_COMMON.ALL;

ENTITY input IS
    pORt (clk         : IN    STD_LOGIC;
          reset       : IN    STD_LOGIC;
          clk_paleta  : IN    STD_LOGIC;
          Game_over   : IN    STD_LOGIC;
          Boton_izquierdo : IN    STD_LOGIC;
          Boton_derecho   : IN    STD_LOGIC;
          Posicion_paleta     : INOUT STD_LOGIC_VECTOR(9 DOWNTO 0);
          Inicio       : OUT   STD_LOGIC);
END ENTITY;

ARCHITECTURE behavioral of input IS

BEGIN
    -- hANDles user INput
    -- "1100011111" = 799
    botones : PROCESS (clk, reset, Game_over, clk_paleta)
    BEGIN
        IF (reset = '1' OR Game_over = '1') THEN
            Posicion_paleta <= "0110010000";    -- 400
            Inicio   <= '0';
        ELSIF (RISING_EDGE(clk)) THEN
            IF (Boton_izquierdo = '0' AND clk_paleta = '1' AND ((Posicion_paleta - TO_STDLOGICVECTOR(TO_BITVECTOR(Longitud_paleta) SRL 1)) > (Borde_field + "1"))) THEN
                Posicion_paleta <= Posicion_paleta - 1;
                Posicion_paleta <= Posicion_paleta - 1;
                Inicio   <= '1';
            ELSIF (Boton_derecho = '0' AND clk_paleta = '1' AND ((Posicion_paleta + TO_STDLOGICVECTOR(TO_BITVECTOR(Longitud_paleta) SRL 1)) < ("1100011111" - Borde_field))) THEN
                Posicion_paleta <= Posicion_paleta + 1;
                Posicion_paleta <= Posicion_paleta + 1;
                Inicio   <= '1';
            END IF;
        END IF;
    END PROCESS;
    
END ARCHITECTURE;
