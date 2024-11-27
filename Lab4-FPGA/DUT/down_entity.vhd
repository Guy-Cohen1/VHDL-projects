LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY down_entity IS
  GENERIC (n : INTEGER := 8); 
  PORT 
  (  
	x, y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  pwm_o: out STD_LOGIC;
		  clk, rst, ena: in STD_LOGIC
  ); 
END down_entity;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF down_entity IS 

	SIGNAL ALUOUT, y_pwm, x_pwm : std_logic_vector(n-1 DOWNTO 0);
	SIGNAL highz : std_logic_vector(n-1 DOWNTO 0) := (others => 'Z');
	SIGNAL ALUFN_PWM, ALUFN_TEMP : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL pwm_mode : STD_LOGIC;
	
BEGIN
	ALUFN_TEMP <= ALUFN_i (2 DOWNTO 0);
	
	y_pwm <= y when ALUFN_i(4 DOWNTO 3) = "00" else highz;
	x_pwm <= x when ALUFN_i(4 DOWNTO 3) = "00" else highz;
	pwm_mode <= ALUFN_TEMP(0) when  ALUFN_i(4 DOWNTO 3) = "00" else 'Z';
	
	---------------------------------------------------------------------------------------------------------
	
	pwm_part : Pwm generic map(n) port map( x_pwm, y_pwm, pwm_mode, rst, clk, ena, pwm_o);
	
	---------------------------------------------------------------------------------------------------------
	
END struct;

