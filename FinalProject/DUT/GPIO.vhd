LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-----------------------------------------
-- Entity Declaration for GPIO
-----------------------------------------
ENTITY GPIO IS
	GENERIC(CtrlBusSize	: integer := 8;
			AddrBusSize	: integer := 32;
			DataBusSize	: integer := 32
			);
	PORT( 
		INTA						: IN	STD_LOGIC;
		MemReadBus					: IN 	STD_LOGIC;
		clock						: IN 	STD_LOGIC;
		reset						: IN 	STD_LOGIC;
		MemWriteBus					: IN 	STD_LOGIC;
		AddressBus					: IN	STD_LOGIC_VECTOR(AddrBusSize-1 DOWNTO 0);
		DataBus						: INOUT	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
		HEX0, HEX1					: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2, HEX3					: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX4, HEX5					: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
		LEDR						: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		Switches					: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		CS_LEDR, CS_SW				: IN 	STD_LOGIC;
		CS_HEX0, CS_HEX1, CS_HEX2	: IN 	STD_LOGIC;
		CS_HEX3, CS_HEX4, CS_HEX5	: IN 	STD_LOGIC
		);
END GPIO;
----------------------------------------
-- Architecture Definition
----------------------------------------
ARCHITECTURE structure OF GPIO IS

	SIGNAL GPIO_CS	: STD_LOGIC_VECTOR(6 DOWNTO 0);
	

	
BEGIN	
	
	-- Instantiate the OutputPeripheral module for driving LEDs
	LED:	OutputPeripheral
	GENERIC MAP(SevenSeg => FALSE,
				IOSize	 => 8)
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				GPIO_CS	    => CS_LEDR,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> LEDR
			);
	
	-- Instantiate the OutputPeripheral module for driving HEX0
	HEX0_7SEG:	OutputPeripheral
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,	
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				GPIO_CS	=> CS_HEX0,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX0
			);
	-- Instantiate the OutputPeripheral module for driving HEX1		
	HEX1_7SEG:	OutputPeripheral
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				GPIO_CS	=> CS_HEX1,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX1
			);
	-- Instantiate the OutputPeripheral module for driving HEX2
	HEX2_7SEG:	OutputPeripheral
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				GPIO_CS	=> CS_HEX2,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX2
			);
	-- Instantiate the OutputPeripheral module for driving HEX3
	HEX3_7SEG:	OutputPeripheral
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				GPIO_CS	    => CS_HEX3,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX3
			);
	-- Instantiate the OutputPeripheral module for driving HEX4		
	HEX4_7SEG:	OutputPeripheral
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				GPIO_CS	=> CS_HEX4,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX4
			);
	-- Instantiate the OutputPeripheral module for driving HEX5		
	HEX5_7SEG:	OutputPeripheral
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				GPIO_CS	=> CS_HEX5,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX5
			);
	-- Instantiate the InputPeripheral module for reading switch inputs
	SW:			InputPeripheral
	PORT MAP(	MemRead		=> MemReadBus,
				GPIO_CS	=> CS_SW,
				INTA		=> INTA,
				Data		=> DataBus,
				GPInput		=> Switches
			);
		
	
END structure;