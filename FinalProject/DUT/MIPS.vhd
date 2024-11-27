
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

-----------------------------------------
-- Entity Declaration for MIPS
-----------------------------------------

ENTITY MIPS IS
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
		
END 	MIPS;
----------------------------------------
-- Architecture Definition
----------------------------------------
ARCHITECTURE structure OF MIPS IS

	COMPONENT Ifetch
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

	COMPONENT control
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

	COMPONENT  Execute
   	     PORT(	opcode           : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
				Read_data_1 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
                Read_data_2 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Sign_Extend 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Function_opcode		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
               	ALUOp 				: IN 	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
               	ALUSrc 				: IN 	STD_LOGIC;
               	Zero 				: OUT	STD_LOGIC;
               	ALU_Result 			: buffer	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Add_Result 			: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
               	PC_plus_4 			: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
               	clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;


	COMPONENT dmemory
	GENERIC (MemWidth	: INTEGER;
			 SIM		: BOOLEAN);
	PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			is_ra 			    : in 	STD_LOGIC;	
        	address 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
            clock,reset, index_11, ena			: IN 	STD_LOGIC );
	end COMPONENT;
	-- declare signals used to connect VHDL components
	
	---- MCU BUS ----
	
	
	SIGNAL PC_plus_4 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL read_data_1 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL jump_address 	: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUSrc 			: STD_LOGIC;
	SIGNAL Branch 			: STD_LOGIC;
	SIGNAL Branch_not_equal : STD_LOGIC;
	SIGNAL is_ra 			: STD_LOGIC := '0';  -- Initialized to '0'

	SIGNAL jump 			: STD_LOGIC;
	signal jump_register	: STD_LOGIC;
	SIGNAL RegDst 			: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL Regwrite 		: STD_LOGIC;
	SIGNAL Zero 			: STD_LOGIC;
	SIGNAL MemWrite 		: STD_LOGIC;
	SIGNAL MemtoReg 		: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL ALUop 			: STD_LOGIC_VECTOR(3 DOWNTO 0 );
	SIGNAL Instruction		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL PC_plus_4_jr_out : STD_LOGIC_VECTOR( 9 DOWNTO 0 );

	-- Interrupt Signals
	SIGNAL MemAddr												: STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ISRAddr												: STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
	SIGNAL EPC													: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL INTA_sig												: STD_LOGIC;
	SIGNAL Read_ISR_PC											: STD_LOGIC;
	SIGNAL INTR_OneCycle										: STD_LOGIC;
	SIGNAL HOLD_PC												: STD_LOGIC;
	SIGNAL STATE 												: STD_LOGIC;
	
	
BEGIN
	
   
					-- connect the 5 MIPS components   
  IFE : Ifetch
	GENERIC MAP(MemWidth => MemWidth, SIM => SIM)
	PORT MAP (	ena 			=> ena,
				Instruction 	=> Instruction,
    	    	PC_plus_4_out 	=> PC_plus_4,
				PC_plus_4_jr_out => PC_plus_4_jr_out,
				Add_result 		=> Add_result,
				jump_address    => jump_address,
				Branch 			=> Branch,
				Branch_not_equal => Branch_not_equal,
				jump_register   => jump_register,
				jump            => jump,
				Zero 			=> Zero,
				Ainput          => read_data_1(9 DOWNTO 0),
				PC_out 			=> PC,    
				INTA 			=> INTA_sig,	
				Read_ISR_PC     => Read_ISR_PC,
				HOLD_PC         => HOLD_PC,
				ISRAddr         => ISRAddr,
				clock 			=> clock,  
				reset 			=> reset );

   ID : Idecode
   	PORT MAP (	
				read_data_1 	=> read_data_1,
				ena             => ena,
				databus			=> DataBus,
				AddressBus		=> AddressBus,
        		read_data_2 	=> read_data_2,
				jump_address    => jump_address,
        		Instruction 	=> Instruction,
				Opcode 			=> Instruction( 31 DOWNTO 26 ),
        		read_data 		=> read_data,
				ALU_result 		=> ALU_result,
				PC_PLUS_4       => PC_plus_4,
				PC_plus_4_jr => PC_plus_4_jr_out,
				PC              => PC,
				RegWrite 		=> RegWrite,
				MemtoReg 		=> MemtoReg,
				RegDst 			=> RegDst,
				Sign_extend 	=> Sign_extend,
				GIE				=> GIE,
				Read_ISR_PC		=> Read_ISR_PC,
				EPC				=> EPC,
				INTR			=> INTR,
				INTR_Active		=> INTR_Active,
				CLR_IRQ			=> CLR_IRQ,
				jump			=> jump,
        		clock 			=> clock,  
				reset 			=> reset,
				IFG				=> IFG,
				IntrEn			=> IntrEn
				);


   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction( 31 DOWNTO 26 ),
				Funct           => Instruction( 5 DOWNTO 0 ),
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg,
				RegWrite 		=> RegWrite,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				Branch 			=> Branch,
				jump_register   => jump_register,
				Branch_not_equal => Branch_not_equal,
				jump            => jump,
				ALUop 			=> ALUop,
                clock 			=> clock,
				reset 			=> reset,
				STATE		=> STATE 
				);

   EXE:  Execute
   	PORT MAP (  Opcode 			=> Instruction( 31 DOWNTO 26 ),
				Read_data_1 	=> read_data_1,
             	Read_data_2 	=> read_data_2,
				Sign_extend 	=> Sign_extend,
                Function_opcode	=> Instruction( 5 DOWNTO 0 ),
				ALUOp 			=> ALUop,
				ALUSrc 			=> ALUSrc,
				Zero 			=> Zero,
                ALU_Result		=> ALU_Result,
				Add_Result 		=> Add_Result,
				PC_plus_4		=> PC_plus_4,
                Clock			=> clock,
				Reset			=> reset );

   MEM:  dmemory
    GENERIC MAP(MemWidth => MemWidth, SIM => SIM) 
	PORT MAP (	read_data 		=> read_data,
				ena             => ena,
				is_ra           => is_ra,
				address 		=> MemAddr,--jump memory address by 4
				write_data 		=> read_data_2,
				MemRead 		=> MemRead, 
				Memwrite 		=> MemWrite, 
                clock 			=> clock,  
				reset 			=> reset,
				index_11		=> MemAddr(11)	);
				
				
	------ MCU ------
	ControlBus		<= read_data_2(CtrlBusSize-1 DOWNTO 0) WHEN ALU_result(11 DOWNTO 0) = X"81C" ELSE -- BTCTL
					   X"00";	 
	MemReadBus		<= MemRead;
	
	MemWriteBus		<= MemWrite;
	
	AddressBus		<= X"00000" & ALU_result(11 DOWNTO 0) WHEN (MemRead = '1' OR MemWrite = '1')
						ELSE (OTHERS => '0');
						
	DataBus			<= read_data_2 	WHEN (ALU_result(11) = '1' AND MemWrite = '1') ELSE 
					   (OTHERS => 'Z');	-- GPIO OUTPUT
	
	MemAddr 		<= DataBus 	WHEN (INTA_sig = '0') ELSE 
						ALU_result;
						
	is_ra           <= '1' WHEN ((Instruction(31 DOWNTO 26) = "101011" and Instruction(20 DOWNTO 16) = "11111") 
						or(Instruction(31 DOWNTO 26) = "100011" and Instruction(20 DOWNTO 16) = "11111"))
						ELSE '0';
				
	---------- INTERRUPT ----------
	------ INTA and ISR Addr ------
	INTA	<= INTA_sig;
	
	PROCESS (clock, INTR, reset)
		VARIABLE INTR_STATE 	: STD_LOGIC_VECTOR(1 DOWNTO 0);

	BEGIN
		IF reset = '1' THEN
			INTR_STATE 	:= "00";
			INTA_sig 	<= '1';
			Read_ISR_PC	<= '0';
			HOLD_PC		<= '0';
			STATE <= '0';
		
		ELSIF (rising_edge(clock)) THEN
			IF (INTR_STATE = "00") THEN
				IF (INTR = '1') THEN
					INTA_sig	<= '0'; -- send ack to mcu
					INTR_STATE	:= "01";
					HOLD_PC		<= '1'; -- hold current pc
					STATE <= '0';
				END IF;
				Read_ISR_PC	<= '0';
				
			ELSIF (INTR_STATE = "01") THEN		
				INTA_sig	<= '1'; 
				INTR_STATE 	:= "10";
				STATE <= '1';
								
			ELSE 
				ISRAddr		<= read_data; -- get the ISR address from dmemory
				INTR_STATE 	:= "00";
				Read_ISR_PC	<= '1'; -- jump to ISR
				HOLD_PC		<= '0';
				STATE <= '0';
			END IF;
		
		END IF;
	END PROCESS;
	
	------ EPC (Exception Program Counter) PROCESS ------
	PROCESS (clock, INTR, reset) BEGIN	
		IF reset = '1' THEN
			EPC	<= (OTHERS => '0');
			
		ELSIF (rising_edge(clock)) THEN
			IF (INTR = '1') THEN
				EPC	<= PC(9 DOWNTO 2); -- save current pc
			END IF;
		END IF;
	
	END PROCESS;
	
	
END structure;

