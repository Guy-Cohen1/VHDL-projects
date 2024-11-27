LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.aux_package.ALL;
-----------------------------------------
-- Entity Declaration for INTERRUPT
-----------------------------------------
ENTITY INTERRUPT IS
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
END INTERRUPT;
----------------------------------------
-- Architecture Definition
----------------------------------------
ARCHITECTURE structure OF INTERRUPT IS
	SIGNAL IRQ	    	: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL CLR_IRQ		: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL TypeReg		: STD_LOGIC_VECTOR(RegSize-1 DOWNTO 0);
	SIGNAL INTA_Delayed : STD_LOGIC;
	
	
	
BEGIN

-- Determine if any interrupt is currently active
INTR_Active	<= 	IFG(0) OR IFG(1) OR IFG(2) OR
				IFG(3) OR IFG(4) OR IFG(5) OR IFG(6);

-- Assign the interrupt vector based on which interrupt flag is set
TypeReg	<= 	X"00" WHEN reset  = '1' ELSE -- main
			X"10" WHEN IFG(2) = '1' ELSE -- Basic timer
			X"14" WHEN IFG(3) = '1' ELSE -- KEY1
			X"18" WHEN IFG(4) = '1' ELSE -- KEY2
			X"1C" WHEN IFG(5) = '1' ELSE -- KEY3
			X"20" WHEN IFG(6) = '1' ELSE -- DIV
			(OTHERS => 'Z');


-- Update the interrupt flag register based on data from the MCU or the IRQ sources
IFG		<=	DataBus(6 DOWNTO 0)	WHEN (AddressBus = X"83D" AND MemWriteBus = '1') ELSE
			IRQ AND IntrEn;		
-- Update the interrupt type register based on data from the MCU
TypeReg	<=	DataBus(RegSize-1 DOWNTO 0)	WHEN (AddressBus = X"83E" AND MemWriteBus = '1') ELSE
			(OTHERS => 'Z');
			
-- Clear the IRQ signals when the interrupt acknowledge is received

CLR_IRQ(2) <= '0' WHEN (TypeReg = X"10" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(3) <= '0' WHEN (TypeReg = X"14" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(4) <= '0' WHEN (TypeReg = X"18" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(5) <= '0' WHEN (TypeReg = X"1C" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(6) <= '0' WHEN (TypeReg = X"20" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';


-------------------------------------------------------------

-- Determine the INTR output signal based on the interrupt flag register and global interrupt enable
PROCESS (clock, IFG) BEGIN 
	IF (rising_edge(CLOCK)) THEN
		IF (IFG(0) = '1' OR IFG(1) = '1' OR IFG(2) = '1' OR
			IFG(3) = '1' OR IFG(4) = '1' OR IFG(5) = '1' OR IFG(6) = '1') THEN
			-- Assert INTR if any interrupt flag is set and global interrupt is enabled
			INTR <= GIE;
		ELSE 
			INTR <= '0';
		END IF;
	END IF;
END PROCESS;


----------------------------------------
-- Handle interrupt requests for basic timer
----------------------------------------
PROCESS (clock, reset, CLR_IRQ(2), IntrSrc(2))
BEGIN
	IF rising_edge(clock) THEN
		IF (reset = '1') THEN
			IRQ(2) <= '0';
		ELSIF CLR_IRQ(2) = '0' THEN
			IRQ(2) <= '0';
		ELSIF IntrSrc(2) = '1' THEN
			IRQ(2) <= '1';  -- Set IRQ if IntrSrc(2) is asserted
		END IF;
	END IF;
END PROCESS;
----------------------------------------
-- Handle interrupt requests for KEY1
----------------------------------------
PROCESS (clock, reset, CLR_IRQ(3), IntrSrc(3))
BEGIN
	IF (reset = '1') THEN
		IRQ(3) <= '0';
	ELSIF CLR_IRQ(3) = '0' THEN
		IRQ(3) <= '0';
	ELSIF rising_edge(IntrSrc(3)) THEN
		IRQ(3) <= '1'; -- Set IRQ if IntrSrc(3) is asserted
	END IF;
END PROCESS;
----------------------------------------
-- Handle interrupt requests for KEY2
----------------------------------------
PROCESS (clock, reset, CLR_IRQ(4), IntrSrc(4))
BEGIN
	IF (reset = '1') THEN
		IRQ(4) <= '0';
	ELSIF CLR_IRQ(4) = '0' THEN
		IRQ(4) <= '0';
	ELSIF rising_edge(IntrSrc(4)) THEN
		IRQ(4) <= '1'; -- Set IRQ if IntrSrc(4) is asserted
	END IF;
END PROCESS;
----------------------------------------
-- Handle interrupt requests for KEY3
----------------------------------------
PROCESS (clock, reset, CLR_IRQ(5), IntrSrc(5))
BEGIN
	IF (reset = '1') THEN
		IRQ(5) <= '0';
	ELSIF CLR_IRQ(5) = '0' THEN
		IRQ(5) <= '0';
	ELSIF rising_edge(IntrSrc(5)) THEN
		IRQ(5) <= '1'; -- Set IRQ if IntrSrc(5) is asserted
	END IF;
END PROCESS;
----------------------------------------
-- Handle interrupt requests for KEY4
----------------------------------------
PROCESS (clock, reset, CLR_IRQ(6), IntrSrc(6))
BEGIN
	IF (reset = '1') THEN
		IRQ(6) <= '0';
	ELSIF CLR_IRQ(6) = '0' THEN
		IRQ(6) <= '0';
	ELSIF rising_edge(IntrSrc(6)) THEN
		IRQ(6) <= '1'; -- Set IRQ if IntrSrc(6) is asserted
	END IF;
END PROCESS;

-- Provide data to the MCU on the data bus based on the address and read signals
DataBus <=	X"000000" 		& TypeReg 	WHEN ((AddressBus = X"83E" AND MemReadBus = '1') OR (INTA = '0' AND MemReadBus = '0'))  ELSE
			"0000000000000000000000000"	& IntrEn 	WHEN (AddressBus = X"83C" AND MemReadBus = '1') ELSE
			"0000000000000000000000000"	& IFG	WHEN (AddressBus = X"83D" AND MemReadBus = '1') ELSE
			(OTHERS => 'Z'); 

IRQ_OUT <= IRQ;

CLR_IRQ_OUT <= CLR_IRQ;

-- Delay the INTA signal to ensure proper timing of interrupt acknowledge
PROCESS (clock) BEGIN
	IF (reset = '1') THEN
		INTA_Delayed <= '1';
	ELSIF (rising_edge(clock)) THEN
		INTA_Delayed <= INTA;
	END IF;
END PROCESS;


-- Handle write operations from the MCU to update internal registers 

PROCESS(clock) 
BEGIN
	IF (rising_edge(clock)) THEN
		IF (AddressBus = X"83C" AND MemWriteBus = '1') THEN
			IntrEn 	<=	DataBus(6 DOWNTO 0);
		END IF;		
	END IF;
END PROCESS;




END structure;