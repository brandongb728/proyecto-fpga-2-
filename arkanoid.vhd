LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.ARKANOID_COMMON.ALL;

ENTITY arkanoid IS
    PORT(clk           : IN  STD_LOGIC;
         RST           : IN  STD_LOGIC;
         BOTON_IZQUIERDO : IN  STD_LOGIC;
         BOTON_DERECHO   : IN  STD_LOGIC;
         V_SYNCH : OUT STD_LOGIC;
         H_SYNCH : OUT STD_LOGIC;
         Azul   : OUT STD_LOGIC;
         Rojo   : OUT STD_LOGIC;
         Verde  : OUT STD_LOGIC;
         led    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY;

ARCHITECTURE behavioral OF arkanoid IS
    SIGNAL reset : STD_LOGIC:='0';
    SIGNAL posicion_paleta : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL posicion_bola_x : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL posicion_bola_y : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL clk_paleta  : STD_LOGIC;
    SIGNAL clk_bola : STD_LOGIC;
    SIGNAL inicio       : STD_LOGIC := '0';
    SIGNAL Game_over : STD_LOGIC := '0';
    SIGNAL matriz_bloque : matriz;
    
BEGIN

    reset <= NOT rst;
    -- clock dividers for the ball and pad movement
    clk_dividers : ENTITY WORK.clk_dividers 
										PORT MAP (clk      => clk,
										clk_bola => clk_bola,
										clk_paleta  => clk_paleta);

 -- OUTput handlers
    Configuracion_VGA : ENTITY WORK.VGA 
										  PORT MAP (clk           => clk,
										  posicion_bola_x    => posicion_bola_x,
										  posicion_bola_y    => posicion_bola_y,
										  matriz_bloque  => matriz_bloque,
										  posicion_paleta       => posicion_paleta,
										  V_SYNCH    => V_SYNCH,
										  H_SYNCH    => H_SYNCH,
										  Azul  => Azul,
										  Rojo   => Rojo,
										  Verde => Verde,
										  led           => led);

    -- INput handler
    Botones : ENTITY WORK.INput
											PORT MAP (clk         => clk,
                                 reset       => reset,
                                 clk_paleta     => clk_paleta,
                                 Game_over => Game_over,
                                 BOTON_IZQUIERDO   => BOTON_IZQUIERDO,
                                 BOTON_DERECHO  => BOTON_DERECHO,
                                 posicion_paleta     => posicion_paleta,
                                 inicio       => inicio);

    -- calculates consequences OF ball position
    dibujado : ENTITY WORK.ball_blocks 
											PORT MAP (clk          => clk,
											reset        => reset,
											clk_bola     => clk_bola,
											inicio        => inicio,
											posicion_paleta      => posicion_paleta,
											Game_over  => Game_over,
											posicion_bola_x   => posicion_bola_x,
											posicion_bola_y   => posicion_bola_y,
											matriz_bloque => matriz_bloque);

END ARCHITECTURE;

