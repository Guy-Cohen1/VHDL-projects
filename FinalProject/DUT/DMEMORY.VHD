----------  Dmemory module (implements the data memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
-----------------------------------------
-- Entity Declaration for dmemory
-----------------------------------------
ENTITY dmemory IS
	GENERIC (MemWidth	: INTEGER;
			 SIM		: BOOLEAN);
	PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			is_ra 			    : in 	STD_LOGIC;	
        	address 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
            clock,reset, index_11, ena			: IN 	STD_LOGIC );
END dmemory;
----------------------------------------
-- Architecture Definition
----------------------------------------
ARCHITECTURE behavior OF dmemory IS
	SIGNAL write_clock	: STD_LOGIC;
	SIGNAL write_enable	: STD_LOGIC;
	SIGNAL dMemAddr		: STD_LOGIC_VECTOR(MemWidth-1 DOWNTO 0);
BEGIN


	ModelSim: 
		IF (SIM = TRUE) GENERATE
				dMemAddr <= address(11 DOWNTO 0) when is_ra = '1' ELSE
							address(13 DOWNTO 2);
		END GENERATE ModelSim;
		
	FPGA: 
		IF (SIM = FALSE) GENERATE
				dMemAddr <= address(11 DOWNTO 0) & "00" when is_ra = '1' ELSE
							address(13 DOWNTO 2) & "00";
		END GENERATE FPGA;
	
	write_enable <= '1' WHEN (index_11 = '0' AND Memwrite = '1' and ena = '1') ELSE '0';
	

	data_memory : altsyncram
	GENERIC MAP  (
		operation_mode => "SINGLE_PORT",
		width_a => 32,
		widthad_a => 14,
		numwords_a => 16384,
		lpm_hint => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = DTCM",
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "C:\hanan\CPU\FinalProject\check\DTCM.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		wren_a => write_enable, 
		clock0 => clock, -- rising Edge
		address_a => dMemAddr,
		data_a => write_data,
		q_a => read_data	);
-- Load memory address register with write clock
-- Data Memory works on falling edge
		
END behavior;

