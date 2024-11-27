LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use work.aux_package.all;
----------------------------------------
entity IR is 
	generic(BusSize		: integer := 16;
			RegSize		: integer := 4;
			OffsetSize 	: integer := 8;
			ImmidSize	: integer := 8
	);
	port(dataOutProgMem	: in  std_logic_vector(BusSize-1 downto 0);
		IRin			: in  std_logic;
		RFaddr 			: in  std_logic_vector(1 downto 0);
		RWAddrRF		: out std_logic_vector(RegSize-1 downto 0);
		OffsetAddr		: out std_logic_vector(OffsetSize-1 downto 0);
		Immid			: out std_logic_vector(ImmidSize-1 downto 0);
		IROp			: out std_logic_vector(RegSize-1 downto 0)
	);
end IR;
-----------------------------------------
ARCHITECTURE dlf OF IR IS
	signal IR_reg	: std_logic_vector(BusSize-1 downto 0); 
begin 

IR_reg <= dataOutProgMem when IRin = '1' else unaffected;


IROp <= IR_reg(4*RegSize-1 downto 3*RegSize);


with RFaddr select
		RWAddrRF <=				IR_reg(RegSize-1 downto 0)  			when "00", -- R[c]
								IR_reg(2*RegSize-1 downto RegSize)  	when "01", -- R[b]
								IR_reg(3*RegSize-1 downto 2*RegSize) 	when others; -- R[a]

								
-- For JtypeState
OffsetAddr <= IR_reg(OffsetSize-1 downto 0);
-- For ItypeState
Immid <= IR_reg(ImmidSize-1 downto 0);


end dlf;