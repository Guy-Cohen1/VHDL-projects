LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;

ENTITY top IS
  GENERIC (	HEX_num : integer := 7;
			n : INTEGER := 8
			); 
  PORT (
		  clk  : in std_logic; -- for single tap
		  -- Switch Port
		  SW_i : in std_logic_vector(n downto 0);
		  -- Keys Ports
		  KEY0, KEY1, KEY2, KEY3 : in std_logic;
		  Pwm_out : OUT std_logic;
		  -- 7 segment Ports
		  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(HEX_num-1 downto 0);
		  -- Leds Port
		  LEDs: out std_logic_vector(9 downto 0)  
  );
END top;

ARCHITECTURE roman OF top IS 
	-- Signals for registers
	signal reg1_X, reg2_X, reg1_Y, reg2_Y : std_logic_vector(n-1 downto 0);
	signal reg1_ALUFN_i, reg2_ALUFN_i : std_logic_vector(4 downto 0);
	signal reg1_ALUout, reg2_ALUout : std_logic_vector(n-1 downto 0);
	signal ref_clk, reg1_Nflag, reg1_Cflag, reg1_Zflag, reg1_Vflag : std_logic;
	signal reg2_Nflag, reg2_Cflag, reg2_Zflag, reg2_Vflag : std_logic;
	signal ALUout_o, X, Y : std_logic_vector(n-1 downto 0);
	signal Nflag_o, Cflag_o, Zflag_o, Vflag_o, rst, ena: STD_LOGIC;
	signal ALUFN_i: std_logic_vector(4 downto 0);

BEGIN
	
	clk_div_part : CounterEnvelope  port map(clk, ena, ref_clk);
	
	-- First register stage
	process(ref_clk)
	begin
		if rising_edge(ref_clk) then
			reg1_X <= X;
			reg1_Y <= Y;
			reg1_ALUFN_i <= ALUFN_i;
		end if;
	end process;
	
	-- ALU instantiation
	ALU_part : ALU generic map(n) 
		port map(Y_i => reg1_Y, 
				 X_i => reg1_X, 
				 ALUFN_i => reg1_ALUFN_i, 
				 ALUout_o => reg1_ALUout, 
				 Nflag_o => reg1_Nflag, 
				 Cflag_o => reg1_Cflag, 
				 Zflag_o => reg1_Zflag, 
				 Vflag_o => reg1_Vflag);

	-- Second register stage
	process(ref_clk)
	begin
		if rising_edge(ref_clk) then
			reg2_ALUout <= reg1_ALUout;
			reg2_Nflag <= reg1_Nflag;
			reg2_Cflag <= reg1_Cflag;
			reg2_Zflag <= reg1_Zflag;
			reg2_Vflag <= reg1_Vflag;
		end if;
	end process;

	-- Output assignments
	ALUout_o <= reg2_ALUout;
	Nflag_o <= reg2_Nflag;
	Cflag_o <= reg2_Cflag;
	Zflag_o <= reg2_Zflag;
	Vflag_o <= reg2_Vflag;

	-- The rest of your top architecture code

	-- Down entity instantiation
	down_entity_part : down_entity generic map(n) 
		port map(x => x, 
				 y => y, 
				 ALUFN_i => ALUFN_i, 
				 pwm_o => Pwm_out, 
				 clk => ref_clk, 
				 rst => rst, 
				 ena => ena);
	
	-- 7 Segment Decoder and LED assignments
	DecoderModuleXHex0: 	SevenSegDecoder	port map(X(3 downto 0) , HEX0);
	DecoderModuleXHex1: 	SevenSegDecoder	port map(X(7 downto 4) , HEX1);
	DecoderModuleYHex2: 	SevenSegDecoder	port map(Y(3 downto 0) , HEX2);
	DecoderModuleYHex3: 	SevenSegDecoder	port map(Y(7 downto 4) , HEX3);
	DecoderModuleOutHex4: 	SevenSegDecoder	port map(ALUout_o(3 downto 0) , HEX4);
	DecoderModuleOutHex5: 	SevenSegDecoder	port map(ALUout_o(7 downto 4) , HEX5);
	LEDs(0) <= Vflag_o;
	LEDs(1) <= Zflag_o;
	LEDs(2) <= Nflag_o;
	LEDs(3) <= Cflag_o;
	LEDs(9 downto 5) <= ALUFN_i;

	-- Keys binding
	process(KEY0, KEY1, KEY2) 
	begin
		if KEY0 = '0' then
			Y <= SW_i(n-1 downto 0);
		elsif KEY1 = '0' then
			ALUFN_i <= SW_i(4 downto 0);
		elsif KEY2 = '0' then
			X <= SW_i(n-1 downto 0);
		elsif KEY3 = '0' then
			rst <= '1';	
		elsif SW_i(8) = '1' then
			ena <= '1';	
		end if;
	end process;

END roman;
