LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY top IS
  GENERIC (n : INTEGER := 8); 
  PORT 
  (  
	x, y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	clk, rst, ena : IN STD_LOGIC;
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: out STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o, Pwm_out: OUT STD_LOGIC
  ); 
END top;
------------- complete the top Architecture code --------------
ARCHITECTURE roman OF top IS 
	
BEGIN

	---------------------------------------------------------------------------------------------------------
	
	ALU_part : ALU generic map(n) port map( Y, X, ALUFN_i , ALUout_o, Nflag_o, Cflag_o, Zflag_o, Vflag_o);
	down_entity_part : down_entity generic map(n) port map( x, y, ALUFN_i, Pwm_out, clk, rst, ena);
	
	---------------------------------------------------------------------------------------------------------
	

		
END roman;

