LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY top IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT 
  (  
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: out STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC
  ); 
END top;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top IS 
	SIGNAL ALUOUT, zeros, y_add, x_add, x_logic, y_logic, x_shifter, y_shifter, res_adder, res_logic, res_shifter : std_logic_vector(n-1 DOWNTO 0);
	SIGNAL cout_adder, cout_shifter :std_logic;
	SIGNAL highz : std_logic_vector(n-1 DOWNTO 0) := (others => 'Z');
	SIGNAL ALUFN_ADDER, ALUFN_LOGIC, ALUFN_SHIFTER, ALUFN_TEMP : STD_LOGIC_VECTOR (2 DOWNTO 0);
	
	
BEGIN
	ALUFN_TEMP <= ALUFN_i (2 DOWNTO 0);
	zeros <= (not X_i) and X_i;
	y_add <= Y_i when ALUFN_i(4 DOWNTO 3) = "01" else highz;
	x_add <= Y_i when ALUFN_i(4 DOWNTO 3) = "01" else highz;
	ALUFN_ADDER <= ALUFN_i(2 DOWNTO 0) when  ALUFN_i(4 DOWNTO 3) = "01" else "ZZZ";
	
	y_logic <= Y_i when ALUFN_i(4 DOWNTO 3) = "11" else highz;
	x_logic <= Y_i when ALUFN_i(4 DOWNTO 3) = "11" else highz;
	ALUFN_LOGIC <= ALUFN_i(2 DOWNTO 0) when  ALUFN_i(4 DOWNTO 3) = "11" else "ZZZ";
	
	y_shifter <= Y_i when ALUFN_i(4 DOWNTO 3) = "10" else highz;
	x_shifter <= Y_i when ALUFN_i(4 DOWNTO 3) = "10" else highz;
	ALUFN_SHIFTER <= ALUFN_i(2 DOWNTO 0) when  ALUFN_i(4 DOWNTO 3) = "10" else "ZZZ";
	
	---------------------------------------------------------------------------------------------------------
	
	Adder : AdderSub generic map(n) port map(ALUFN_TEMP, X_i, Y_i, cout_adder, res_adder);
	logicpart : Logic generic map(n) port map( X_i, Y_i, ALUFN_i(2 DOWNTO 0), res_logic);
	shifterpart : Shifter generic map(n) port map( Y_i, X_i, ALUFN_i(2 DOWNTO 0), res_shifter, cout_shifter);
	
	---------------------------------------------------------------------------------------------------------
	
				
	ALUOUT <= res_adder when ALUFN_i(4 DOWNTO 3) = "01" else
				res_logic when ALUFN_i(4 DOWNTO 3) = "11" else
				res_shifter when ALUFN_i(4 DOWNTO 3) = "10" else
				zeros;
			 
	Zflag_o <= '1' when ALUOUT = zeros else '0';
	Nflag_o <= '1' when ALUOUT(n-1) = '1' else '0';
	Cflag_o <= cout_adder when ALUFN_i(4 DOWNTO 3) = "01" else
		     	cout_shifter when ALUFN_i(4 DOWNTO 3) = "10" else
				'0';
				
	ALUout_o <= ALUOUT;
	Vflag_o <= ((X_i(n-1) and Y_i(n-1) and (not ALUOUT(n-1))) or ((not X_i(n-1)) and (not Y_i(n-1)) and ALUOUT(n-1))) when ALUFN_i = "01000" else 
           ((X_i(n-1) and (not Y_i(n-1)) and  ALUOUT(n-1)) or ((not X_i(n-1)) and Y_i(n-1) and (not ALUOUT(n-1)))) when ALUFN_i = "01001" else
           '0';

	
		
END struct;

