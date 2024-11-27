LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------
ENTITY AdderSub IS
  GENERIC (n : INTEGER := 16);
  PORT (     sub_cont: IN std_logic_vector(2 downto 0);
			 x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
             cout: OUT STD_LOGIC;
             res: OUT STD_LOGIC_VECTOR(n-1 downto 0));
END AdderSub;
--------------------------------------------------------------
ARCHITECTURE dfl OF AdderSub IS

	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
	
	SIGNAL reg : std_logic_vector(n-1 DOWNTO 0);
	signal zeros_temp , ones_temp, x_temp, y_temp :std_logic_vector (n-1 DOWNTO 0);
	SIGNAL sub_cont_vec1, x_xor_sub :std_logic_vector (n-1 downto 0);
	
	
BEGIN
	
	zeros_temp <= (others => '0');
	ones_temp <= not zeros_temp;
	
	sub_cont_vec1 <= (OTHERS => '1') WHEN sub_cont = "001" OR sub_cont = "010" ELSE (OTHERS => '0');

	x_temp <= x when sub_cont = "001" else 
	          x when sub_cont = "010" else                
			  x when sub_cont = "000" else
			  zeros_temp; 
	
	y_temp <= y when sub_cont = "001" else                 
			  y when sub_cont = "000" else
			  zeros_temp;
			  
	x_xor_sub <= x_temp xor sub_cont_vec1; 
	
	first : FA port map (
				xi => x_xor_sub(0),
				yi => y_temp(0),
				cin => sub_cont_vec1(0),
				s => res(0),
				cout => reg(0));
				
	hibur : for i in 1 to n-1 generate
				connect: FA port map(
							 xi => x_xor_sub(i),
							 yi => y_temp(i),
							 cin => reg(i-1),
							 cout => reg(i),
							 s => res(i));
	end generate;				 
					 
	cout <= reg(n-1);
    

END dfl;



