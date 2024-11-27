library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------- MIPS ---------------------------
	
	
	
	
	
	COMPONENT MIPS IS
	GENERIC (	MemWidth 	: INTEGER := 10;
				SIM 		: BOOLEAN := FALSE;
				CtrlBusSize	: integer := 8;
				AddrBusSize	: integer := 32;
				DataBusSize	: integer := 32;
				IOSize		: integer := 8
			 );
	PORT( reset					: IN 	STD_LOGIC; 
	      clock					: IN 	STD_LOGIC; 
		  ena					: IN 	STD_LOGIC; 
		-- Output important signals to pins for easy display in Simulator
		PC					: buffer  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		ControlBus			: OUT	STD_LOGIC_VECTOR(CtrlBusSize-1 DOWNTO 0);
		MemReadBus			: OUT 	STD_LOGIC;
		MemWriteBus			: OUT 	STD_LOGIC;
		AddressBus			: buffer	STD_LOGIC_VECTOR(AddrBusSize-1 DOWNTO 0);
		GIE					: OUT	STD_LOGIC;
		INTR				: IN	STD_LOGIC;
		INTA				: OUT	STD_LOGIC;
		INTR_Active			: IN	STD_LOGIC;
		CLR_IRQ				: IN	STD_LOGIC_VECTOR(6 DOWNTO 0);
		DataBus				: INOUT	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
		IFG				    : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		IntrEn		     	: IN STD_LOGIC_VECTOR(6 DOWNTO 0)		);
		end COMPONENT;

	COMPONENT Ifetch IS
	GENERIC (MemWidth	: INTEGER;
			 SIM 		: BOOLEAN);
	PORT(	SIGNAL ena				: IN 	STD_LOGIC; 
			SIGNAL Instruction 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	SIGNAL PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			SIGNAL PC_plus_4_jr_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL Add_result 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			SIGNAL jump_address 	: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			SIGNAL Ainput    		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL Branch 			: IN 	STD_LOGIC;
			SIGNAL Branch_not_equal : IN 	STD_LOGIC;
			SIGNAL jump_register    : IN 	STD_LOGIC;
        	SIGNAL Zero 			: IN 	STD_LOGIC;
			SIGNAL jump             : IN 	STD_LOGIC;
      		SIGNAL PC_out 			: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL clock, reset 	: IN 	STD_LOGIC;
			
			SIGNAL INTA				: IN	STD_LOGIC;
			SIGNAL Read_ISR_PC		: IN	STD_LOGIC;
			SIGNAL HOLD_PC			: IN 	STD_LOGIC;
			SIGNAL ISRAddr			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;

	COMPONENT Idecode IS
	 PORT(	
			read_data_1	: buffer 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			databus		: in 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			AddressBus		: in 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			jump_address: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Opcode      : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			read_data 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_result	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			PC_PLUS_4	: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			PC_PLUS_4_jr: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			PC      	: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			RegWrite 	: IN 	STD_LOGIC;
			MemtoReg 	: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			RegDst 		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			Sign_extend : buffer 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			GIE			: OUT 	STD_LOGIC;
			Read_ISR_PC	: IN	STD_LOGIC;
			EPC			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
			INTR		: IN	STD_LOGIC;
			INTR_Active	: IN	STD_LOGIC;
			CLR_IRQ		: IN	STD_LOGIC_VECTOR(6 DOWNTO 0);
			jump        : IN 	STD_LOGIC;
			clock,reset, ena	: IN 	STD_LOGIC;
			IFG			: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			IntrEn		: IN STD_LOGIC_VECTOR(6 DOWNTO 0)
			);
END COMPONENT;

	COMPONENT control IS
     PORT( 	
	Opcode 					: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	Funct        			: IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
	RegDst 					: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
	ALUSrc 					: OUT 	STD_LOGIC;
	MemtoReg 				: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	RegWrite 				: OUT 	STD_LOGIC;
	MemRead 				: OUT 	STD_LOGIC;
	MemWrite 	            : OUT 	STD_LOGIC;
	Branch 		            : OUT 	STD_LOGIC;
	Branch_not_equal 		: OUT 	STD_LOGIC;
	jump					: OUT 	STD_LOGIC;
	jump_register			: OUT 	STD_LOGIC;
	ALUop 				    : OUT 	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	clock, reset			: IN 	STD_LOGIC;
	STATE 				    : IN STD_LOGIC		);
	END COMPONENT;

	COMPONENT  Execute IS
    PORT(
		opcode           : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
        Read_data_1      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        Read_data_2      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        Sign_extend      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        Function_opcode  : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
        ALUOp            : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        ALUSrc           : IN  STD_LOGIC;
        Zero             : OUT STD_LOGIC;
        ALU_result       : buffer STD_LOGIC_VECTOR(31 DOWNTO 0);
        Add_Result       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        PC_plus_4        : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        clock, reset     : IN  STD_LOGIC
    );
	END COMPONENT;

	COMPONENT dmemory IS
	GENERIC (MemWidth	: INTEGER;
			 SIM		: BOOLEAN);
	PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			is_ra 			    : in 	STD_LOGIC;	
        	address 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
            clock,reset, index_11, ena			: IN 	STD_LOGIC );
	END COMPONENT;
	
	
-----------------------------------------------------------------------------------

--------------------------- GPIO ---------------------------
	COMPONENT InputPeripheral IS
		GENERIC(DataBusSize	: integer := 32);
		PORT( 
			MemRead		: IN	STD_LOGIC;
			GPIO_CS	: IN 	STD_LOGIC;
			INTA		: IN	STD_LOGIC;
			Data		: OUT	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
			GPInput		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT OutputPeripheral IS
		GENERIC (SevenSeg	: BOOLEAN := TRUE;
			 IOSize		: INTEGER := 7); -- 7 WHEN HEX, 8 WHEN LEDs
	PORT( 
		MemRead		: IN	STD_LOGIC;
		clock		: IN 	STD_LOGIC;
		reset		: IN 	STD_LOGIC;
		MemWrite	: IN	STD_LOGIC;
		GPIO_CS	: IN 	STD_LOGIC;
		Data		: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		GPOutput	: OUT	STD_LOGIC_VECTOR(IOSize-1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT OptAddrDecoder IS
		PORT( 
		reset 						: IN	STD_LOGIC;
		AddressBus					: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		CS_LEDR, CS_SW, CS_KEY		: OUT 	STD_LOGIC;
		CS_HEX0, CS_HEX1, CS_HEX2	: OUT 	STD_LOGIC;
		CS_HEX3, CS_HEX4, CS_HEX5	: OUT 	STD_LOGIC
		);
	END COMPONENT;

	COMPONENT SevenSegDecoder IS
	  GENERIC (SegmentSize	: integer := 7);
	  PORT (data		: in STD_LOGIC_VECTOR (3 DOWNTO 0);
			seg   		: out STD_LOGIC_VECTOR (SegmentSize-1 downto 0));
	END COMPONENT;

	COMPONENT GPIO IS
		GENERIC(CtrlBusSize	: integer := 8;
				AddrBusSize	: integer := 32;
				DataBusSize	: integer := 32
		);
		PORT( 
			-- ControlBus	: IN	STD_LOGIC_VECTOR(CtrlBusSize-1 DOWNTO 0);
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
	END COMPONENT;
------------------ BASIC TIMER ---------------------------
	COMPONENT BTIMER IS
		GENERIC(DataBusSize	: integer := 32);
		PORT( 
			Addr	: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
			BTRead	: IN	STD_LOGIC;
			BTWrite	: IN	STD_LOGIC;
			MCLK	: IN 	STD_LOGIC;
			reset	: IN 	STD_LOGIC;
			BTCTL	: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			BTCCR0	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
			BTCCR1	: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
			BTCNT_io: INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
			IRQ_OUT : IN	STD_LOGIC;
			BTIFG	: OUT 	STD_LOGIC;
			BTOUT	: OUT	STD_LOGIC
			);
	END COMPONENT;
------------------ Interrupt Controller --------------------
	COMPONENT INTERRUPT IS
	GENERIC(DataBusSize	: integer := 32;
			AddrBusSize	: integer := 12;
			IrqSize	    : integer := 7;
			RegSize		: integer := 8
			);
	PORT( 
			reset		: IN	STD_LOGIC;
			clock		: IN	STD_LOGIC;
			MemReadBus	: IN	STD_LOGIC;
			MemWriteBus	: IN	STD_LOGIC;
			AddressBus	: IN	STD_LOGIC_VECTOR(AddrBusSize-1 DOWNTO 0);
			DataBus		: INOUT	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
			IntrSrc		: IN	STD_LOGIC_VECTOR(6 DOWNTO 0); -- IRQ
			ChipSelect	: IN	STD_LOGIC;
			INTR		: OUT	STD_LOGIC;
			INTA		: IN	STD_LOGIC;
			IRQ_OUT		: OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);
			INTR_Active	: OUT	STD_LOGIC;
			CLR_IRQ_OUT	: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
			GIE			: IN	STD_LOGIC;
			IFG			: buffer STD_LOGIC_VECTOR(6 DOWNTO 0);
			IntrEn		: buffer STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;

COMPONENT Divider is
     Port (
        clk : in STD_LOGIC;          -- Clock signal
		
		Addr	: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		DIVRead	: IN	STD_LOGIC;
		
        reset : in STD_LOGIC;        -- Asynchronous reset signal
        ena : in STD_LOGIC;        -- Start signal to begin the division
        dividend : in  STD_LOGIC_VECTOR (31 downto 0); -- Input for dividend (32-bit)
        divisor : in  STD_LOGIC_VECTOR (31 downto 0); -- Input for divisor (32-bit)
        quotient_OUT : out  STD_LOGIC_VECTOR (31 downto 0); -- Output for quotient (32-bit)
        remainder_OUT : out  STD_LOGIC_VECTOR (31 downto 0); -- Output for remainder (32-bit)
		DIVIFG : buffer STD_LOGIC         -- Indicates an overflow condition
    );
end COMPONENT;


COMPONENT PLL IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
END COMPONENT;

end aux_package;

