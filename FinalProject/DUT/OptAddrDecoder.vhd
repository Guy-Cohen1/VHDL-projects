
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-----------------------------------------
-- Entity Declaration for OptAddrDecoder
-----------------------------------------
ENTITY OptAddrDecoder IS
	PORT( 
		reset 						: IN	STD_LOGIC;
		AddressBus					: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		CS_LEDR, CS_SW, CS_KEY		: OUT 	STD_LOGIC;
		CS_HEX0, CS_HEX1, CS_HEX2	: OUT 	STD_LOGIC;
		CS_HEX3, CS_HEX4, CS_HEX5	: OUT 	STD_LOGIC
		);
END OptAddrDecoder;
----------------------------------------
-- Architecture Definition
----------------------------------------
ARCHITECTURE structure OF OptAddrDecoder IS

BEGIN
	-- Generate Chip Select signals based on the address bus and reset signal
	CS_LEDR	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"800" ELSE '0';-- Select LEDR at address 0x800
	CS_HEX0	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"804" ELSE '0';-- Select HEX0 at address 0x804
	CS_HEX1	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"805" ELSE '0';-- Select HEX1 at address 0x805
	CS_HEX2	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"808" ELSE '0';-- Select HEX2 at address 0x808
	CS_HEX3	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"809" ELSE '0';-- Select HEX3 at address 0x809
	CS_HEX4	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"80C" ELSE '0';-- Select HEX4 at address 0x80C
	CS_HEX5	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"80D" ELSE '0';-- Select HEX5 at address 0x80D
	CS_SW	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"810" ELSE '0';-- Select SW at address   0x810
	CS_KEY	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"814" ELSE '0';-- Select KEY at address  0x814
	

END structure;