		-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
-----------------------------------------
-- Entity Declaration for control
-----------------------------------------
ENTITY control IS
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

END control;
----------------------------------------
-- Architecture Definition
----------------------------------------
ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, Lw, Sw, Beq, Addi, Andi, ori, xori, bne, slti, lui, jmp, jr, jal, mul : STD_LOGIC;

BEGIN           
				-- Code to generate control signals using opcode bits
	R_format 	<=  '1'  WHEN  Opcode = "000000"  ELSE '0';
	Lw          <=  '1'  WHEN  Opcode = "100011"  ELSE '0';
 	Sw          <=  '1'  WHEN  Opcode = "101011"  ELSE '0';
   	Beq         <=  '1'  WHEN  Opcode = "000100"  ELSE '0';
	Addi        <=  '1'  WHEN  Opcode  = "001000"  ELSE '0'; 
	Andi        <=  '1'  WHEN  Opcode  = "001100"  ELSE '0';
	ori         <=  '1'  WHEN  Opcode  = "001101"  ELSE '0';
	xori        <=  '1'  WHEN  Opcode  = "001110"  ELSE '0';	
	slti        <=  '1'  WHEN  Opcode  = "001010"  ELSE '0';
	lui         <=  '1'  WHEN  Opcode  = "001111"  ELSE '0';
	jmp         <=  '1'  WHEN  Opcode  = "000010"  ELSE '0';
	jal         <=  '1'  WHEN  Opcode  = "000011"  ELSE '0';
	mul         <=  '1'  WHEN  Opcode  = "011100"  ELSE '0';
	bne         <=  '1'  WHEN  Opcode  = "000101"  ELSE '0';
	Jr          <=  '1' WHEN (Opcode = "000000" AND Funct = "001000") ELSE '0';
	RegDst(1)   <=  jal;
  	RegDst(0)   <=  R_format or mul;
 	ALUSrc  	<=  Lw OR Sw or Addi or Andi  or ori or xori or slti or lui;
	MemtoReg(1) 	<=  jal;
	MemtoReg(0) 	<=  Lw;
  	RegWrite 	<=  (R_format OR Lw OR Addi or Andi or ori or xori or slti or lui or jal or mul) and (not jr);
  	MemRead 	<=  Lw;
   	MemWrite 	<=  '1' WHEN (Sw = '1' OR STATE = '1') ELSE '0'; 
 	Branch      <=  Beq;
	Branch_not_equal <= bne;
	jump        <= jmp or jal;
	jump_register <= jr;
	ALUOp( 3 )	<=  mul;
	ALUOp( 2 ) 	<=  Addi or sw or lw or ori or slti;
	ALUOp( 1 ) 	<=  R_format or Addi or Andi or sw or lw or slti or lui;
	ALUOp( 0 ) 	<=  Beq or Andi or ori or bne or slti; 

   END behavior;


