LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY ALU IS
  GENERIC (n : INTEGER := 16;
		   k : integer := 4;   -- k=log2(n)
		   m : integer := 8	); -- m=2^(k-1)
  PORT 
  (  
	A,B: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  OPC : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		  C: out STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag,Cflag,Zflag: OUT STD_LOGIC
  ); 
  END ALU;

------------------------------------------------------------------------
ARCHITECTURE struct OF ALU IS 
	SIGNAL ALUOUT, zeros, y_add, x_add, x_logic, y_logic, x_shifter, y_shifter, res_adder, res_logic, res_shifter : std_logic_vector(n-1 DOWNTO 0);
	SIGNAL cout_adder, cout_shifter :std_logic;
	SIGNAL highz : std_logic_vector(n-1 DOWNTO 0) := (others => 'Z');
	SIGNAL ALUFN_ADDER, ALUFN_LOGIC, ALUFN_SHIFTER, ALUFN_TEMP : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL temp : STD_LOGIC_VECTOR (4 DOWNTO 0);
	
	
BEGIN
    temp <= "01000" when OPC = "0000" else 
	        "01001" when OPC = "0001" else
            "11010" when OPC = "0010" else	
            "11001" when OPC = "0011" else	
		    "11011" when OPC = "0100" else
			"00000";
	ALUFN_TEMP <= temp (2 DOWNTO 0);
	zeros <= (not B) and B;
	y_add <= A when temp(4 DOWNTO 3) = "01" else highz;
	x_add <= A when temp(4 DOWNTO 3) = "01" else highz;
	ALUFN_ADDER <= temp(2 DOWNTO 0) when  temp(4 DOWNTO 3) = "01" else "ZZZ";
	
	y_logic <= A when temp(4 DOWNTO 3) = "11" else highz;
	x_logic <= A when temp(4 DOWNTO 3) = "11" else highz;
	ALUFN_LOGIC <= temp(2 DOWNTO 0) when  temp(4 DOWNTO 3) = "11" else "ZZZ";
	
	y_shifter <= A when temp(4 DOWNTO 3) = "10" else highz;
	x_shifter <= A when temp(4 DOWNTO 3) = "10" else highz;
	ALUFN_SHIFTER <= temp(2 DOWNTO 0) when  temp(4 DOWNTO 3) = "10" else "ZZZ";
	
	---------------------------------------------------------------------------------------------------------
	
	Adder : AdderSub generic map(n) port map(ALUFN_TEMP, B, A, cout_adder, res_adder);
	logicpart : Logic generic map(n) port map( B, A, temp(2 DOWNTO 0), res_logic);
	shifterpart : Shifter generic map(n) port map( A, B, temp(2 DOWNTO 0), res_shifter, cout_shifter);
	
	---------------------------------------------------------------------------------------------------------
	
				
	ALUOUT <= res_adder when temp(4 DOWNTO 3) = "01" else
				res_logic when temp(4 DOWNTO 3) = "11" else
				res_shifter when temp(4 DOWNTO 3) = "10" else
				zeros;
			 
	Zflag <= '1' when ALUOUT = zeros else '0';
	Nflag <= '1' when ALUOUT(n-1) = '1' else '0';
	Cflag <= cout_adder when temp(4 DOWNTO 3) = "01" else
		     	cout_shifter when temp(4 DOWNTO 3) = "10" else
				'0';
				
	C <= ALUOUT;

	
		
END struct;

