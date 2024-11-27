
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-----------------------------------------
-- Entity Declaration for InputPeripheral
-----------------------------------------
ENTITY InputPeripheral IS
	GENERIC(DataBusSize	: integer := 32);
	PORT( 
		MemRead		: IN	STD_LOGIC;
		GPIO_CS	: IN 	STD_LOGIC;
		INTA		: IN	STD_LOGIC;
		Data		: OUT	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
		GPInput		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END InputPeripheral;
----------------------------------------
-- Architecture Definition
----------------------------------------
ARCHITECTURE structure OF InputPeripheral IS
BEGIN	
	
    -- When both MemRead and ChipSelect signals are asserted, 
    -- the Data output is driven with the GPInput signals
	Data		<= X"000000" & GPInput WHEN (MemRead AND GPIO_CS) = '1' ELSE (OTHERS => 'Z');
	
END structure;