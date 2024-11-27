
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-----------------------------------------
-- Entity Declaration for OutputPeripheral
-----------------------------------------
ENTITY OutputPeripheral IS

	GENERIC (SevenSeg	: BOOLEAN := TRUE;
			 IOSize		: INTEGER := 7); -- 7 WHEN HEX, 8 WHEN LEDs
	PORT( 
		MemRead		: IN	STD_LOGIC;
		clock		: IN 	STD_LOGIC;
		reset		: IN 	STD_LOGIC;
		MemWrite	: IN	STD_LOGIC;
		GPIO_CS  	: IN 	STD_LOGIC;
		Data		: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		GPOutput	: OUT	STD_LOGIC_VECTOR(IOSize-1 DOWNTO 0)
		);
END OutputPeripheral;
----------------------------------------
-- Architecture Definition
----------------------------------------
ARCHITECTURE structure OF OutputPeripheral IS
	SIGNAL latch_data	: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

	-- Process to handle data latching on a rising clock edge
	PROCESS(clock)
	BEGIN
	IF (reset = '1') THEN
		latch_data	<= X"00";
	ELSIF (rising_edge(clock)) THEN -- Latch the data when both MemWrite and ChipSelect are active
		IF (MemWrite = '1' AND GPIO_CS = '1') THEN
			latch_data <= Data;
		END IF;
	END IF;
	END PROCESS;
	
	---

	-- Output the latched data when MemRead and ChipSelect are active
	Data	<=	latch_data WHEN (MemRead = '1' AND GPIO_CS = '1') 	ELSE (others => 'Z'); 

	
	
	SEG: 
		IF (SevenSeg = TRUE) GENERATE -- Map the lower 4 bits of the latch to the Seven Segment decoder
			SevenSegDec: 	SevenSegDecoder
							PORT MAP(	data	=> latch_data(3 DOWNTO 0),
										seg		=> GPOutput);
		END GENERATE SEG;
	
	NO_SEG:
		IF (SevenSeg = FALSE) GENERATE
			GPOutput <= latch_data; -- Directly assign the latch output to the general-purpose output
		END GENERATE NO_SEG;
	
END structure;