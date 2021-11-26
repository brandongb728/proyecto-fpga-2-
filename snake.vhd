LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY snake IS 
PORT (
	clk : IN STD_LOGIC;
	rst : IN STD_LOGIC;
	stop : IN  STD_LOGIC;
	Direccion  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	VGA_HS, VGA_VS	: OUT STD_LOGIC;
	VGA_Rojo  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	VGA_Verde : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	VGA_Azul  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	led       : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
);
END ENTITY;


ARCHITECTURE behaviour OF snake IS

SIGNAL clk_vga, clk_60hz : STD_LOGIC:='0'; 
SIGNAL reset : STD_LOGIC:='0'; 
SIGNAL nuevo_frame : STD_LOGIC:='0';
SIGNAL Num : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL posicion_vertical, posicion_horizontal : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
	reset <= NOT rst;
  
pll_clock : ENTITY WORK.pll 
	PORT MAP (
		c0 => clk_vga,
		inclk0 => clk); 
	
vga1 : ENTITY WORK.configuracion_vga 
	PORT MAP (
		clk	 => clk_vga,
		h_sync  => VGA_HS,
		v_sync  => VGA_VS,
		nuevo_frame => nuevo_frame,
		horizontal_actual => posicion_horizontal,
		vertical_actual => posicion_vertical);
 
dibujado_vga : ENTITY WORK.dibujado 
	PORT MAP (
	   clk_60hz => clk_60hz,
		clk_vga => clk_vga,
		reset  => reset,
    	direccion => Num,
		stop => stop,
		en => nuevo_frame,
		columna => posicion_horizontal,
		fila => posicion_vertical,
		debug_led => led,
		rojo	 => VGA_Rojo,
		verde  => VGA_Verde,
		azul	 => VGA_Azul);
 
								
reloj_60hz: PROCESS(clk_vga)
        CONSTANT contador_max    : INTEGER := 900000;
        VARIABLE contador        : INTEGER RANGE 0 TO contador_max - 1 := 0;
        VARIABLE clk_60hz_siguiente: STD_LOGIC := '0';
    BEGIN 
        IF(RISING_EDGE(clk_vga)) THEN 
            IF(contador = contador_max - 1) THEN
                contador := 0;
                clk_60hz_siguiente := NOT clk_60hz_siguiente;
            ELSE
                contador := contador + 1;
            END IF;
        END IF;
        clk_60hz <= clk_60hz_siguiente;
    END PROCESS;
	 
direcci: PROCESS(Num)
 BEGIN 
  IF(direccion(0) = '0') THEN
    Num <= "00";
  ELSIF(direccion(1) = '0') THEN
    Num <= "10";
  ELSIF(direccion(2) = '0') THEN
    Num <= "11";
  ELSIF(direccion(3) = '0') THEN
    Num <= "01";
  END IF;		
END PROCESS;

END ARCHITECTURE;