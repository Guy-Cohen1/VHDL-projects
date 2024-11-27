-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
-----------------------------------------
-- Entity Declaration for Ifetch
-----------------------------------------
ENTITY Ifetch IS
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
END Ifetch;
----------------------------------------
-- Architecture Definition
----------------------------------------
ARCHITECTURE behavior OF Ifetch IS
	SIGNAL instruction_temp  : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL PC, PC_plus_4 , 	PC_plus_4_jr : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL Mem_Addr 		 : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL Next_PC           : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL f_clk  : STD_LOGIC;
BEGIN
						--ROM for Instruction Memory
inst_memory: altsyncram
	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => 10,
		numwords_a => 1024,
		lpm_hint => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = ITCM",
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "C:\hanan\CPU\FinalProject\check\ITCM.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0     => f_clk,
		address_a 	=> Mem_Addr, 
		q_a 			=> instruction_temp );
		
					-- Instructions always start on word address - not byte
		PC(1 DOWNTO 0) <= "00";
		
					-- copy output signals - allows read inside module
		PC_out 			<= PC;
		PC_plus_4_out 	<= PC_plus_4;
		PC_plus_4_jr_out    <= PC_plus_4_jr;
		f_clk <= not clock;
						-- send address to inst. memory address register
		------------------------------------------------------------------
		ModelSim: 
		IF (SIM = TRUE) GENERATE
				Mem_Addr <= PC( 9 DOWNTO 2 );
		END GENERATE ModelSim;
		
		FPGA: 
		IF (SIM = FALSE) GENERATE
				Mem_Addr <= PC;
		END GENERATE FPGA;
		------------------------------------------------------------------
		
		

						-- Adder to increment PC by 4        
      	PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
       	PC_plus_4( 1 DOWNTO 0 )  <= "00";
		
		PC_plus_4_jr <= PC_plus_4 when clock = '0' else unaffected;
		
		------------------------------------------------------------------
		
						-- Mux to select Branch Address or PC + 4        
		Next_PC  <= X"00" WHEN Reset = '1' ELSE
					ISRAddr(9 DOWNTO 2)	WHEN Read_ISR_PC = '1'	ELSE	-- Interrupt!
					jump_address WHEN ((jump = '1' or jump_register = '1') and Read_ISR_PC = '0') ELSE --jump\jal
					Add_result  WHEN ( ( Branch = '1' ) AND ( Zero = '1' ) ) ELSE   --beq
					Add_result  WHEN ( ( Branch_not_equal = '1' ) AND ( Zero = '0' ) ) ELSE  --bne
					PC_plus_4( 9 DOWNTO 2 );
		
		
			
		instruction <= instruction_temp;
		
	PROCESS
		BEGIN
		
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				   PC( 9 DOWNTO 2) <= "00000000" ; 
			ELSIF (HOLD_PC = '0' and ena = '1') THEN 
				   PC( 9 DOWNTO 2 ) <= Next_PC;
			END IF;
	END PROCESS;
END behavior;


