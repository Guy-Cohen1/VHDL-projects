LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.aux_package.ALL;
-----------------------------------------
-- Entity Declaration for BTIMER
-----------------------------------------
ENTITY BTIMER IS
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
END BTIMER;
----------------------------------------
-- Architecture Definition
----------------------------------------
ARCHITECTURE structure OF BTIMER IS
	SIGNAL CLK		: STD_LOGIC;
	SIGNAL DIV		: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL BTCNT	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	SIGNAL BTCL0	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL BTCL1	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	SIGNAL PWM		: STD_LOGIC;

	ALIAS BTIPx		IS BTCTL(2 DOWNTO 0);
	ALIAS BTSSEL	IS BTCTL(4 DOWNTO 3);
	ALIAS BTHOLD	IS BTCTL(5);
	ALIAS BTOUTEN	IS BTCTL(6);
	
BEGIN

	PROCESS (MCLK) BEGIN
		IF (falling_edge(MCLK)) THEN
				BTCL0 <= BTCCR0;
				BTCL1 <= BTCCR1;
		END IF;
	END PROCESS;
	
	-- Determines the clock division based on BTCTL
	WITH BTSSEL SELECT DIV	<=
		"0001"	WHEN "00", -- 1
		"0010"	WHEN "01", -- 2
		"0100"	WHEN "10", -- 4
		"1000"	WHEN "11", -- 8
		"0001"	WHEN OTHERS;
		
	-- Generates PWM signal based on timer counts
	
	PROCESS (CLK, Addr) BEGIN
		IF reset = '1' THEN
			PWM <= '1';
		ELSIF (falling_edge(CLK)) THEN
			IF (BTOUTEN = '0') THEN
				PWM	<= '1';
			ELSIF (BTCNT = BTCL0 OR BTCNT = BTCL1) THEN
				PWM	<= NOT PWM; -- Toggle PWM signal
			END IF;
		END IF;
	END PROCESS;
	BTOUT	<= PWM;

		
	-- Update timer counter based on address and write signal
	PROCESS(MCLK, CLK, reset, Addr)
	BEGIN
		IF (reset = '1' OR IRQ_OUT = '1') THEN
			BTCNT <= X"00000000";
		ELSIF (falling_edge(CLK)) THEN
			IF(Addr = X"820" AND BTWrite = '1') THEN
				BTCNT <= BTCNT_io;
			ELSIF(BTHOLD = '0') THEN 
				BTCNT <= BTCNT + 1;
			END IF;
		END IF;
	END PROCESS;
	
	-- Calculates the divided clock for BTCNT based on MCLK
	PROCESS(MCLK, reset, CLK)
		VARIABLE BT_COUNTER	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	BEGIN
		IF reset = '1' THEN
			CLK 	<= '0';
			BT_COUNTER := "0000";
		ELSIF(falling_edge(MCLK)) THEN
			IF(DIV = X"1") THEN -- Reset counter if division is 1
				BT_COUNTER := "0000";
				CLK <= NOT CLK;
			ELSE
			BT_COUNTER := BT_COUNTER + 1;
				IF (BT_COUNTER = DIV) THEN
					BT_COUNTER := "0000";
					CLK <= NOT CLK;	
				END IF;
			END IF;
		END IF;
	END PROCESS;
		
	
	-- Handles data transfer to/from BTCNT_io based on address and read signal
	BTCNT_io <= BTCNT WHEN (Addr = X"820" AND BTRead = '1') ELSE (OTHERS => 'Z');	
	
	-- Determine interrupt flag based on BTCNT
	WITH BTIPx SELECT BTIFG <= 
		BTCNT(25)	WHEN	"111",
		BTCNT(23) 	WHEN	"110",
		BTCNT(19) 	WHEN	"101",
		BTCNT(15) 	WHEN	"100",
		BTCNT(11) 	WHEN	"011",
		BTCNT(7) 	WHEN	"010",
		BTCNT(3) 	WHEN	"001", 
		BTCNT(0) 	WHEN	"000",
		'0'		  	WHEN	OTHERS;
END structure;