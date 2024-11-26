library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb2 is
	constant n : integer := 8;
	constant ROWmax : integer := 7; 
end tb2;
-------------------------------------------------------------------------------
architecture rtb of tb2 is
	type mem is array (0 to ROWmax) of std_logic_vector(2 downto 0);
	SIGNAL Y,X:  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL ALUFN :  STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL ALUout:  STD_LOGIC_VECTOR(n-1 downto 0);
    SIGNAL cout: STD_LOGIC; 	
	SIGNAL Icache : mem := ("000","001","010","011","100","101","110","111");
begin
	L0 : Shifter generic map (n) port map( Y, X, ALUFN, ALUout, cout);
    
	--------- start of stimulus section ----------------------------------------		
        tb_x_y : process
        begin
		  x <= (others => '1');
		  y <= (others => '1');
		  wait for 50 ns;
		  for i in 0 to 40 loop
			x <= x-10;
			y <= y-1;
			wait for 50 ns;
		  end loop;
		  wait;
        end process;
		 
		
		tb_ALUFN : process
        begin
		  ALUFN <= (others => '0');
		  for i in 0 to ROWmax loop
			ALUFN <= Icache(i);
			wait for 100 ns;
		  end loop;
		  wait;
        end process;
  
end architecture rtb;
