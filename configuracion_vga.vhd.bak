LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY configuracion_vga IS 
PORT (
	clk	: IN STD_LOGIC;
	h_syn : OUT STD_LOGIC;
	v_syn : OUT STD_LOGIC;
	rojo	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	verde	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	azul	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	nuevo_frame : OUT STD_LOGIC;
	horizontal_actual : OUT INTEGER RANGE 0 TO 2256:=0;
	vertical_actual : OUT INTEGER RANGE 0 TO 1087:=0;
	rojo_in	 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	verde_in  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	azul_in	 : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
);
 
END ENTITY;
 
ARCHITECTURE behaviour OF configuracion_vga IS

SIGNAL posicion_horizontal : INTEGER RANGE 0 TO 2256:=0;   
SIGNAL posicion_vertical : INTEGER RANGE 0 TO 1087:=0;

 
BEGIN

horizontal_actual <= posicion_horizontal;
vertical_actual <= posicion_vertical;
 
vga : PROCESS(clk)
BEGIN
	IF RISING_EDGE(clk) THEN		
		IF(posicion_horizontal < 2256) THEN	
			nuevo_frame <= '0';			
   		posicion_horizontal <= posicion_horizontal + 1;
		ELSE
			posicion_horizontal <= 0; 		
			IF (posicion_vertical < 1087) THEN
				posicion_vertical <= posicion_vertical + 1;
			ELSE 
				posicion_vertical <= 0;				
				nuevo_frame <= '1';				
			END IF;
		END IF;

		IF(posicion_horizontal > 103 AND posicion_horizontal < 288) THEN
			h_syn <= '0';
		ELSE
			h_syn <= '1';
		END IF;
		
		IF (posicion_vertical > 0 AND posicion_vertical < 4) THEN
			v_syn <= '1';
		ELSE
			v_syn <= '0';
		END IF;
		
		IF((posicion_horizontal >= 0 AND posicion_horizontal < 576) or (posicion_vertical >= 0 AND posicion_vertical < 37) ) THEN
				rojo <= (OTHERS => '0');
				verde <= (OTHERS => '0');
				azul <= (OTHERS => '0');				
		ELSE
			IF ( (posicion_horizontal >= 576 AND posicion_horizontal < 586 ) or (posicion_vertical >= 37 AND posicion_vertical < 47 ) or (posicion_horizontal >= 2246 AND posicion_horizontal < 2256 ) or (posicion_vertical >= 1077 AND posicion_vertical < 1087 ) ) THEN
					rojo <= (OTHERS => '1');
					verde <= (OTHERS => '1');
					azul <= (OTHERS => '1');
			ELSE
					rojo <= rojo_in;
					verde <= verde_in;
					azul <= azul_in;
			END IF;	
		END IF;	
	END IF;	
END PROCESS;
END ARCHITECTURE;