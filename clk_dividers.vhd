LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.ARKANOID_COMMON.ALL;

ENTITY clk_dividers IS
    PORT (clk      : IN  STD_LOGIC;
          clk_bola : OUT STD_LOGIC;
          clk_paleta  : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behavioral OF clk_dividers IS
    SIGNAL contador_b : STD_LOGIC_VECTOR(3 DOWNTO 0)  := "0000";
    SIGNAL contador_p : STD_LOGIC_VECTOR(16 DOWNTO 0) := "00000000000000000";

BEGIN
    -- clk_divider for ball movement    
    clk_div_bola : PROCESS (clk, contador_p, contador_b)
    BEGIN
        IF (RISING_EDGE(clk)) THEN
            IF (contador_p = "11111111111111000" AND contador_b = "0100") THEN
                contador_b  <= "0000";
                clk_bola <= '1';

            ELSIF (contador_p = "11111111111111110") THEN
                contador_b  <= contador_b + '1';
                clk_bola <= '0';
            ELSE
                clk_bola <= '0';
            END IF;
        END IF;
    END PROCESS;

    -- clk_divider for pad movement
    clk_div_paleta : PROCESS (clk, contador_p)
    BEGIN
        IF (RISING_EDGE(clk)) THEN
            IF (contador_p = "11111111111111111") THEN
                clk_paleta <= '1';
                contador_p <= "00000000000000000";
            ELSE
                clk_paleta <= '0';
                contador_p <= contador_p + '1';
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;

