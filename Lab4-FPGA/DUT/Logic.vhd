LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY logic IS
	GENERIC (n : INTEGER := 8);
	PORT (x, y: IN std_logic_vector (n-1 downto 0);
			fn : IN std_logic_vector (2 downto 0);
			  res : OUT std_logic_vector (n-1 downto 0));
END logic;
--------------------------------------------------------
ARCHITECTURE dataflow1 OF logic IS

signal zeros : std_logic_vector(n-1 DOWNTO 0);

BEGIN
	zeros <= (not X) and X;
	res <= not y when fn = "000" else 
	       y or x when fn = "001" else
		   y and x when fn = "010" else 
		   y xor x when fn = "011" else 
		   y nor x when fn = "100" else
		   y nand x when fn = "101" else 
		   y xnor x when fn = "111" else
		   zeros;
end dataflow1;
	

