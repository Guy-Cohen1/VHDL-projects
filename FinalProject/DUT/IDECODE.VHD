						--  Idecode module (implements the register file for
LIBRARY IEEE; 			-- the MIPS computer)
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-----------------------------------------
-- Entity Declaration for Idecode
-----------------------------------------
ENTITY Idecode IS
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
END Idecode;

----------------------------------------
-- Architecture Definition
----------------------------------------

ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL register_array				: register_file;
	SIGNAL write_register_address 		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_data					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_register_1_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_1		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_0		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR( 15 DOWNTO 0 );

BEGIN
	read_register_1_address 	<= Instruction( 25 DOWNTO 21 );
   	read_register_2_address 	<= Instruction( 20 DOWNTO 16 );
   	write_register_address_1	<= Instruction( 15 DOWNTO 11 );
   	write_register_address_0 	<= Instruction( 20 DOWNTO 16 );
   	Instruction_immediate_value <= Instruction( 15 DOWNTO 0 );
					-- Read Register 1 Operation
	read_data_1 <= register_array( 
			      CONV_INTEGER( read_register_1_address ) );
					-- Read Register 2 Operation		 
	read_data_2 <= register_array( 
			      CONV_INTEGER( read_register_2_address ) );
				  
					-- Mux for Register Write Address
   write_register_address <= write_register_address_1 
			WHEN RegDst = "01"  ELSE write_register_address_0 WHEN RegDst = "00" ELSE
			"11111"; --31 for jal
			
		

		-- Mux to bypass data memory for Rformat instructions
	write_data <= "000000000000000000000000" & PC_PLUS_4_jr(9 DOWNTO 2) when (write_register_address = "11111" and Opcode /= "100011") ELSE
				  databus WHEN (AddressBus(11 DOWNTO 0) = X"834" or AddressBus(11 DOWNTO 0) = X"838"   or
			      AddressBus(11 DOWNTO 0) = X"83D" or AddressBus(11 DOWNTO 0) = X"83C" OR AddressBus(11 DOWNTO 0) = X"810" ) ELSE
				  ALU_result WHEN ( MemtoReg = "00" ) ELSE 
				  read_data;
			
					-- Sign Extend 16-bits to 32-bits
    Sign_extend <= X"0000" & Instruction_immediate_value
					WHEN Instruction_immediate_value(15) = '0'
					ELSE	X"FFFF" & Instruction_immediate_value;
					
	-------------  Calc PC Address when branching --------------------
	jump_address	  <= Sign_extend(7 DOWNTO 0)  WHEN Opcode(1 DOWNTO 0) = "10" OR Opcode(1 DOWNTO 0) = "11" ELSE
						 read_data_1(7 DOWNTO 0); -- jr
	
	-------------- Global interrupt enable GIE ------------------------
	GIE				<= register_array(26)(0);
	-------------------------------------------------------------------
PROCESS
	BEGIN
		WAIT UNTIL falling_edge(clock);
		IF reset = '1' THEN
					-- Initial register values on reset are register = reg#
					-- use loop to automatically generate reset logic 
					-- for all registers
			FOR i IN 0 TO 31 LOOP
				register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
 			END LOOP;
					-- Write back to register - don't write to register 0
  		ELSIF (RegWrite = '1' AND write_register_address /= 0 and ena = '1') THEN
		      register_array( CONV_INTEGER( write_register_address)) <= write_data;
		END IF;
		
		------ Edit $k0 section ------
		IF (INTR = '1') THEN
			register_array(26)(0) <= '0';  --GIE
		ELSIF (read_register_1_address = "11011" AND Jump = '1') THEN
			register_array(26)(0) <= '1';  --GIE
		ELSE
			register_array(26)(0) <= '1';
		END IF;
		------ Edit $k1 section ------
		IF (Read_ISR_PC = '1') THEN
			register_array(27) <= X"000000" & EPC;
		END IF;
	END PROCESS;
END behavior;


