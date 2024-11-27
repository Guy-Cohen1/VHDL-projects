

ENTITY MCU_tb IS


END MCU_tb ;


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;

LIBRARY work;

ARCHITECTURE struct OF MCU_tb IS


	CONSTANT MemWidth		: INTEGER := 12;
	CONSTANT SIM 			: BOOLEAN := TRUE;
	CONSTANT IOSize			: INTEGER := 8;


	SIGNAL ALU_result_out  : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Branch_out      : STD_LOGIC;
	SIGNAL Instruction_out : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Memwrite_out    : STD_LOGIC;
	SIGNAL PC              : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL Regwrite_out    : STD_LOGIC;
	SIGNAL Zero_out        : STD_LOGIC;
	SIGNAL clock           : STD_LOGIC;
	SIGNAL read_data_1_out : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2_out : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL reset           : STD_LOGIC;
	SIGNAL write_data_out  : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL CLKCNT		   : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL STCNT		   : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL FHCNT		   : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL BPADD		   : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ST_trigger	   : STD_LOGIC;
	SIGNAL ena			   : STD_LOGIC;
   
	SIGNAL HEX0, HEX1, HEX2	: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL HEX3, HEX4, HEX5	: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL Switches			: STD_LOGIC_VECTOR(7 DOWNTO 0);  
	SIGNAL INTA			:	STD_LOGIC; 
	SIGNAL GIE			:	STD_LOGIC;		
	SIGNAL KEY1, KEY2, KEY3 : STD_LOGIC;


	COMPONENT MCU IS
	GENERIC(MemWidth	: INTEGER := 10;
			SIM 		: BOOLEAN := FALSE;
			CtrlBusSize	: integer := 8;
			AddrBusSize	: integer := 32;
			DataBusSize	: integer := 32;
			IrqSize		: integer := 7;
			RegSize		: integer := 8
			);
	PORT( 
			reset, clock, ena	: IN	STD_LOGIC;
			HEX0, HEX1, HEX2	: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX3, HEX4, HEX5	: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
			Switches			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
			KEY1, KEY2, KEY3	: IN	STD_LOGIC		
		);
	END COMPONENT;
	
	COMPONENT MCU_tester IS
		GENERIC(IOSize : INTEGER := 8);
		PORT( 
			HEX0, HEX1	: IN	STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX2, HEX3	: IN	STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX4, HEX5	: IN	STD_LOGIC_VECTOR(6 DOWNTO 0);
			Switches	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
			clock       : OUT   STD_LOGIC;
			ena			: OUT   STD_LOGIC;
			KEY1, KEY2, KEY3	: OUT	STD_LOGIC;
			reset       : OUT   STD_LOGIC
	   );
	END COMPONENT;

   FOR ALL : MCU USE ENTITY work.mcu;
   FOR ALL : MCU_tester USE ENTITY work.mcu_tester;



BEGIN


   U_0 : MCU
		GENERIC MAP (
			MemWidth => MemWidth,
			SIM 	 => SIM ,
			IrqSize  => 7
		) 
		PORT MAP (
			reset   	=> reset,
			clock   	=> clock,
			ena			=> ena,
			HEX0		=> HEX0,
			HEX1		=> HEX1,
			HEX2		=> HEX2,
			HEX3		=> HEX3,
			HEX4		=> HEX4,
			HEX5		=> HEX5,
			Switches	=> Switches,
			KEY1		=> KEY1,
			KEY2		=> KEY2,
			KEY3		=> KEY3
		);  
	  
   U_1 : MCU_tester
		PORT MAP (
			HEX0		=> HEX0,
			HEX1		=> HEX1,
			HEX2		=> HEX2,
			HEX3		=> HEX3,
			HEX4		=> HEX4,
			HEX5		=> HEX5,
			Switches	=> Switches,
			clock       => clock,
			ena			=> ena,
			KEY1		=> KEY1,
			KEY2		=> KEY2,
			KEY3		=> KEY3,
			reset       => reset
		);

END struct;
