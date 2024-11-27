LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY logic IS
	GENERIC (n : INTEGER := 16);
	PORT (x, y: IN std_logic_vector (n-1 downto 0);
			fn : IN std_logic_vector (2 downto 0);
			  res : OUT std_logic_vector (n-1 downto 0));
END logic;
--------------------------------------------------------
ARCHITECTURE dataflow1 OF logic IS

signal zeros : std_logic_vector(n-1 DOWNTO 0);

BEGIN
	zeros <= (not X) and X;
	res <= y or x when fn = "001" else
		   y and x when fn = "010" else 
		   y xor x when fn = "011" else 
		   zeros;
end dataflow1;
	

