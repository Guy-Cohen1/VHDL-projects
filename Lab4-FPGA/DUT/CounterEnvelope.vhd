LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
 
entity CounterEnvelope is port (
	Clk,En : in std_logic;	
	Qout          : out std_logic); 
end CounterEnvelope;

architecture rtl of CounterEnvelope is
	 
    signal PLLOut : std_logic ;
	
begin
      m0: counter port map(PLLOut,En,Qout);
	  m1: PLL port map(
	     inclk0 => Clk,
		  c0 => PLLOut
	   );
end rtl;


