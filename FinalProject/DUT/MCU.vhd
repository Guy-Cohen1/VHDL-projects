
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-----------------------------------------
-- Entity Declaration for MCU
-----------------------------------------
ENTITY MCU IS
	GENERIC(MemWidth	: INTEGER := 14;
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
			LEDR				: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
			Switches			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
			BTOUT				: OUT   STD_LOGIC;
			KEY1, KEY2, KEY3	: IN	STD_LOGIC);
END MCU;
----------------------------------------
-- Architecture Definition
----------------------------------------
ARCHITECTURE structure OF MCU IS
	SIGNAL resetSim		: STD_LOGIC;
	SIGNAL enaSim		: STD_LOGIC;

	SIGNAL PC			:	STD_LOGIC_VECTOR(9 DOWNTO 0);
	
	-- CHIP SELECT SIGNALS --
	SIGNAL CS_LEDR, CS_SW, CS_KEY		: STD_LOGIC;
	SIGNAL CS_HEX0, CS_HEX1, CS_HEX2	: STD_LOGIC;
	SIGNAL CS_HEX3, CS_HEX4, CS_HEX5, pll_out	: STD_LOGIC;
	
	
	-- GPIO SIGNALS -- 
	SIGNAL MemReadBus	: 	STD_LOGIC;
	SIGNAL MemWriteBus	:	STD_LOGIC;
	SIGNAL ControlBus	: 	STD_LOGIC_VECTOR(CtrlBusSize-1 DOWNTO 0);
	SIGNAL AddressBus	: 	STD_LOGIC_VECTOR(AddrBusSize-1 DOWNTO 0);
	SIGNAL DataBus		: 	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
	
	-- BASIC TIMER --
	SIGNAL BTCTL		:	STD_LOGIC_VECTOR(CtrlBusSize-1 DOWNTO 0);
	SIGNAL BTCNT		:	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
	SIGNAL BTCCR0		:	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
	SIGNAL BTCCR1		:	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
	SIGNAL BTIFG		:	STD_LOGIC;

	-- BASIC TIMER --
	SIGNAL DIVIDEND		:	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DIVISOR		:	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL QUOTIENT		:	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RESIDUE		:	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL final_QUOTIENT		:	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL final_RESIDUE		:	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DIVIFG		:	STD_LOGIC := '0';
	SIGNAL DIVENA		:	STD_LOGIC  := '0';
	
	
	-- INTERRUPT MODULE --
	SIGNAL IntrEn		:	STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL IFG			:	STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL TypeReg		:	STD_LOGIC_VECTOR(RegSize-1 DOWNTO 0);
	SIGNAL IntrSrc		:	STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL IRQ_OUT		:	STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL INTR			:	STD_LOGIC;
	SIGNAL INTA			:	STD_LOGIC;  
	SIGNAL GIE			:	STD_LOGIC;
	SIGNAL INTR_Active	:	STD_LOGIC;
	SIGNAL CLR_IRQ		:	STD_LOGIC_VECTOR(6 DOWNTO 0);
	
	
BEGIN	

	-------------------------- FPGA or ModelSim -----------------------
	resetSim 	<= reset WHEN SIM ELSE not reset;


	
	CPU: MIPS
		GENERIC MAP(
					MemWidth	=> MemWidth,
					SIM 		=> SIM)
		PORT MAP(
					reset		=> resetSim,
					clock		=> pll_out,
					ena			=> ena,
					PC			=> PC,
					ControlBus	=> ControlBus,
					MemReadBus	=> MemReadBus,
					MemWriteBus	=> MemWriteBus,
					AddressBus	=> AddressBus,
					GIE			=> GIE,
					INTR		=> INTR,
					INTA		=> INTA,
					INTR_Active	=> INTR_Active,
					CLR_IRQ		=> CLR_IRQ,
					DataBus		=> DataBus,
					IFG			=> IFG,
					IntrEn      => IntrEn
		);
		
	
	OAD : 	OptAddrDecoder
	PORT MAP(	reset		=> resetSim,
				AddressBus	=> AddressBus(11 DOWNTO 0),
				CS_LEDR		=> CS_LEDR,
				CS_SW		=> CS_SW,
				CS_KEY		=> CS_KEY,
				CS_HEX0		=> CS_HEX0,
				CS_HEX1		=> CS_HEX1,
				CS_HEX2		=> CS_HEX2,
				CS_HEX3		=> CS_HEX3,
				CS_HEX4		=> CS_HEX4,
				CS_HEX5		=> CS_HEX5
				);
		
	
	IO_interface: GPIO
		PORT MAP(
			INTA		=> INTA,
			MemReadBus	=> MemReadBus,
			clock		=> pll_out,
			reset		=> resetSim,
			MemWriteBus	=> MemWriteBus,
			AddressBus	=> AddressBus,
			DataBus		=> DataBus,
			HEX0		=> HEX0,
			HEX1		=> HEX1,
			HEX2		=> HEX2,
			HEX3		=> HEX3,
			HEX4		=> HEX4,
			HEX5		=> HEX5,
			LEDR		=> LEDR,
			Switches	=> Switches,
			CS_LEDR		=> CS_LEDR,
			CS_SW		=> CS_SW,
			CS_HEX0		=> CS_HEX0,
			CS_HEX1		=> CS_HEX1,
			CS_HEX2		=> CS_HEX2,
			CS_HEX3		=> CS_HEX3,
			CS_HEX4		=> CS_HEX4,
			CS_HEX5		=> CS_HEX5
		);

	PROCESS(pll_out)
	BEGIN
		if (falling_edge(pll_out)) then
			if(AddressBus(11 DOWNTO 0) = X"81C" AND MemWriteBus = '1') then
				BTCTL <= ControlBus;
			END IF;
			
			if(AddressBus(11 DOWNTO 0) = X"824" AND MemWriteBus = '1') then
				BTCCR0 <= DataBus;
			END IF;
			
			if(AddressBus(11 DOWNTO 0) = X"828" AND MemWriteBus = '1') then
				BTCCR1 <= DataBus;
			END IF;
			
			if(AddressBus(11 DOWNTO 0) = X"82C" AND MemWriteBus = '1') then
				DIVIDEND <= DataBus;
			END IF;
			
			if(AddressBus(11 DOWNTO 0) = X"830" AND MemWriteBus = '1') then
				DIVISOR <= DataBus;
				DIVENA <= '1';
			END IF;
			
			if(DIVIFG = '1') then
				DIVENA <= '0';
				final_QUOTIENT <= QUOTIENT;
				final_RESIDUE <= RESIDUE;
			END IF;
		END IF;
	END PROCESS;
	
	----
	BTCNT	<= DataBus		WHEN (AddressBus(11 DOWNTO 0) = X"820" AND MemWriteBus = '1') ELSE
			   (OTHERS => 'Z');	-- INPUT

			 
			 
	DataBus <= final_QUOTIENT WHEN (AddressBus(11 DOWNTO 0) = X"834" AND MemReadBus = '1')  ELSE
			   final_RESIDUE WHEN  (AddressBus(11 DOWNTO 0) = X"838" AND MemReadBus = '1')  ELSE
			   "000000000000000000000000" & Switches		WHEN  (AddressBus(11 DOWNTO 0) = X"810" AND MemReadBus = '1')  ELSE
			   "0000000000000000000000000"  & IFG WHEN (AddressBus(11 DOWNTO 0) = X"83D" AND MemReadBus = '1')  ELSE
			   "0000000000000000000000000"  & IntrEn WHEN (AddressBus(11 DOWNTO 0) = X"83C" AND MemReadBus = '1')  ELSE
			   BTCNT WHEN (AddressBus(11 DOWNTO 0) = X"820" AND MemReadBus = '1')  ELSE
			   (OTHERS => 'Z');


	
	div_acc: Divider
		Port MAP(
			clk => pll_out,          -- Clock signal
			
			Addr	=> AddressBus(11 DOWNTO 0),
			DIVRead	=> MemReadBus,
			
			reset => resetSim,       -- Asynchronous reset signal
			ena  => DIVENA,        -- Start signal to begin the division
			dividend => DIVIDEND, -- Input for dividend (32-bit)
			divisor => DIVISOR, -- Input for divisor (32-bit)
			quotient_OUT => QUOTIENT, -- Output for quotient (32-bit)
			remainder_OUT => RESIDUE, -- Output for remainder (32-bit)
			DIVIFG => DIVIFG         -- Indicates an overflow condition
		);
	
	
	Basic_Timer: BTIMER
		PORT MAP(
			Addr	=> AddressBus(11 DOWNTO 0),
			BTRead	=> MemReadBus,
			BTWrite	=> MemWriteBus,
			MCLK	=> pll_out,
			reset	=> resetSim,
			BTCTL	=> BTCTL,
			BTCCR0	=> BTCCR0,
			BTCCR1	=> BTCCR1,
			BTCNT_io=> BTCNT,
			IRQ_OUT => IRQ_OUT(2),
			BTIFG	=> BTIFG,
			BTOUT	=> BTOUT
		);
		
	
	IntrSrc	<=  DIVIFG & (NOT KEY3) & (NOT KEY2) & (NOT KEY1) & BTIFG & '0' & '0';
	Intr_Controller: INTERRUPT
		GENERIC MAP(
			DataBusSize	=> DataBusSize,
			AddrBusSize	=> AddrBusSize,
			IrqSize		=> IrqSize,
			RegSize 	=> RegSize
		)
		PORT MAP(
			reset		=> resetSim,
		    clock		=> pll_out,
		    MemReadBus	=> MemReadBus,
		    MemWriteBus	=> MemWriteBus,
		    AddressBus	=> AddressBus,
		    DataBus		=> DataBus,
		    IntrSrc		=> IntrSrc,
		    ChipSelect	=> '0',
		    INTR		=> INTR,
		    INTA		=> INTA,
			IRQ_OUT		=> IRQ_OUT,
			INTR_Active	=> INTR_Active,
			CLR_IRQ_OUT	=> CLR_IRQ,
		    GIE			=> GIE,
			IFG 		=> IFG
		);
		
		 m1: PLL port map(
	     inclk0 => clock,
		  c0 => pll_out
	   );
	
END structure;