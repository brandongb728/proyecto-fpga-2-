LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY teclas IS
    PORT (
	     clk     : IN  STD_LOGIC;                
        rst     : IN  STD_LOGIC;
	     Fila0    : IN  STD_LOGIC;
		  Fila1    : IN  STD_LOGIC;
		  Fila2    : IN  STD_LOGIC;
		  Fila3    : IN  STD_LOGIC;
		  Num      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		  Columna0 : OUT STD_LOGIC;
		  Columna1 : OUT STD_LOGIC;
		  Columna2 : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavior OF teclas IS
 TYPE Estado IS (S0,S1,S2,boton0,boton1,boton2,boton3,boton4,boton5,boton6,boton7,boton8,boton9,Error);       
 SIGNAL Estado_Actual,Siguiente_Estado : Estado;
BEGIN
fsm: PROCESS (Estado_Actual,Fila0,Fila1,Fila2,Fila3)
   BEGIN 
     CASE Estado_Actual IS
	  
	    WHEN S0 =>
		   Columna0 <= '0';
			Columna1 <= '1';
			Columna2 <= '1';
			Num <= "1010";
		   IF(Fila0 = '1') THEN
			   Siguiente_Estado <= boton1;
			ELSIF(Fila1 = '1') THEN
			   Siguiente_Estado <= boton4;		
			ELSIF(Fila2 = '1') THEN
			   Siguiente_Estado <= boton7;	
			ELSIF(Fila3 = '1') THEN
			   Siguiente_Estado <= Error;	
		   ELSE
	         Siguiente_Estado <= S1;		
			END IF;

	    WHEN S1 =>
		   Columna0 <= '1';
			Columna1 <= '0';
			Columna2 <= '1';
			Num <= "1010";
			IF(Fila0 = '1') THEN
			   Siguiente_Estado <= boton2;		
			ELSIF(Fila1 = '1') THEN
			   Siguiente_Estado <= boton5;		
			ELSIF(Fila2 = '1') THEN
			   Siguiente_Estado <= boton8;	
			ELSIF(Fila3 = '1') THEN
			   Siguiente_Estado <= boton0;
	      ELSE
			   Siguiente_Estado <= S2;
			END IF;		
		
	    WHEN S2 =>
		   Columna0 <= '1';
			Columna1 <= '1';
			Columna2 <= '0';
			Num <= "1010";
			IF(Fila0 = '1') THEN
			   Siguiente_Estado <= boton3;		
			ELSIF(Fila1 = '1') THEN
			   Siguiente_Estado <= boton6;	
			ELSIF(Fila2 = '1') THEN
			   Siguiente_Estado <= boton9;	
			ELSIF(Fila3 = '1') THEN
			   Siguiente_Estado <= Error;	
			ELSE
		      Siguiente_Estado <= S0;		
			END IF;			

       WHEN boton0 =>
		   Columna0 <= '1';
			Columna1 <= '0';
			Columna2 <= '1';
			Num <= "0000";
		   Siguiente_Estado <= S2;

       WHEN boton1 =>
		   Columna0 <= '0';
			Columna1 <= '1';
			Columna2 <= '1';
			Num <= "0001";
		   Siguiente_Estado <= S1;
       
       WHEN boton2 =>
		   Columna0 <= '1';
			Columna1 <= '0';
			Columna2 <= '1';
			Num <= "0010";
		   Siguiente_Estado <= S2;
	     
	    WHEN boton3 =>
		   Columna0 <= '1';
			Columna1 <= '1';
			Columna2 <= '0';
			Num <= "0011";
		   Siguiente_Estado <= S0;
	  
       WHEN boton4 =>
		   Columna0 <= '0';
			Columna1 <= '1';
			Columna2 <= '1';
			Num <= "0100";
		   Siguiente_Estado <= S1;
	   
       WHEN boton5 =>
		   Columna0 <= '1';
			Columna1 <= '0';
			Columna2 <= '1';
			Num <= "0101";
		   Siguiente_Estado <= S2;
		  
		 WHEN boton6 =>
		   Columna0 <= '1';
			Columna1 <= '1';
			Columna2 <= '0';
			Num <= "0110";
		   Siguiente_Estado <= S0;
		
       WHEN boton7 =>
		   Columna0 <= '0';
			Columna1 <= '1';
			Columna2 <= '1';
			Num <= "0111";
		   Siguiente_Estado <= S1;
		   
	    WHEN boton8 =>
		   Columna0 <= '1';
			Columna1 <= '0';
			Columna2 <= '1';
			Num <= "1000";
		   Siguiente_Estado <= S2;
		 
	    WHEN boton9 =>
		   Columna0 <= '1';
			Columna1 <= '1';
			Columna2 <= '0';
			Num <= "1001";
	      Siguiente_Estado <= S0;	 
		  
		 WHEN Error =>
		   Columna0 <= '1';
			Columna1 <= '1';
			Columna2 <= '1';
			Num <= "1111";
	      Siguiente_Estado <= S0;	 
	  END CASE;
   END PROCESS fsm;

 Asignador_Estado: PROCESS (clk, rst)
  BEGIN  
    IF rst = '1' THEN                   
      Estado_Actual <= S0;
    ELSIF RISING_EDGE(clk) THEN 
      Estado_Actual <= Siguiente_Estado;
    END IF;
  END PROCESS Asignador_Estado;
END ARCHITECTURE;