LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------------
entity shifter is 
	GENERIC (
        n : INTEGER := 16;
        k : INTEGER := 4
    );
	port ( Y, X : in STD_LOGIC_VECTOR (n-1 downto 0);
			dir : in STD_LOGIC_VECTOR (2 downto 0);
			res : out STD_LOGIC_VECTOR (n-1 downto 0);
			cout : out STD_LOGIC
			);
end shifter;
--------------------------------------------------------------
architecture s1 of shifter is
subtype vector is STD_LOGIC_VECTOR (n-1 downto 0);
type matrix is array (k downto 0) of vector;
signal mat : matrix;
signal carry : STD_LOGIC_VECTOR(k downto 0);

begin
		
		carry(0) <= '0';
		
		first : for i in 0 to n-1 generate
					mat(0)(i) <= y(i) when dir = "000" else 
								 y(n-1-i) when dir = "001" else 
								 '0';
					end generate;
				 
		other : for j in 1 to k generate
					shift : for l in 0 to 2**(j-1)-1 generate
								mat(j)(l) <= '0' when x(j-1) = '1' else
											  mat(j-1)(l);
											  
					end generate;
					
											  
					after_shift : for m in 2**(j-1) to n-1 generate
								mat(j)(m) <= mat(j-1)(m-2**(j-1)) when x(j-1) = '1' else
											  mat(j-1)(m);
					end generate;
					
		end generate;
		
		result : for m in 0 to n-1 generate
					res(m) <= mat(k)(m) when dir = "000" else
					          mat(k)(n-1-m) when dir = "001" else 
							  '0';
				end generate;
			
		carryout : for s in 1 to k generate
						carry(s) <= mat(s-1)(n-2**(s-1)) when x(s-1) = '1' else 
									carry(s-1);
						cout <= carry(s);
						            
					end generate;

		
					
	

end s1;		
		
					