LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

------------------------------------------------------------
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

-------------------------------------------------------------------------
ARCHITECTURE roman OF top IS 
	
	signal ALUout_o, X, Y : std_logic_vector(n-1 downto 0);
	signal ref_clk, Nflag_o, Cflag_o, Zflag_o, Vflag_o, rst, ena: STD_LOGIC;
	signal ALUFN_i: std_logic_vector(4 downto 0);
	
BEGIN

	---------------------------------------------------------------------------------------------------------
	--process (clk)
    --begin
        --if (rst = '1') then
            --Nflag_o <= '0';
			--Vflag_o <= '0';
			--Zflag_o <= '0';
			--Cflag_o <= '0';
			--X <= "00000000";
			--Y <= "00000000";
			--ALUFN_i <= "00000";
            --Pwm_out <= '0';
        --elsif rising_edge(clk) then
            --if ena = '1' then
				
            --end if; 
       -- end if;
    --end process;
	
	clk_div_part : CounterEnvelope  port map(clk, ena, ref_clk);
	
	ALU_part : ALU generic map(n) port map( Y, X, ALUFN_i , ALUout_o, Nflag_o, Cflag_o, Zflag_o, Vflag_o);
	
	down_entity_part : down_entity generic map(n) port map( x, y, ALUFN_i, Pwm_out, clk, rst, ena);
	
	---------------------------------------------------------------------------------------------------------
	---------------------7 Segment Decoder-----------------------------
	-- Display X on 7 segment
	DecoderModuleXHex0: 	SevenSegDecoder	port map(X(3 downto 0) , HEX0);
	DecoderModuleXHex1: 	SevenSegDecoder	port map(X(7 downto 4) , HEX1);
	-- Display Y on 7 segment
	DecoderModuleYHex2: 	SevenSegDecoder	port map(Y(3 downto 0) , HEX2);
	DecoderModuleYHex3: 	SevenSegDecoder	port map(Y(7 downto 4) , HEX3);
	-- Display ALU output on 7 segment
	DecoderModuleOutHex4: 	SevenSegDecoder	port map(ALUout_o(3 downto 0) , HEX4);
	DecoderModuleOutHex5: 	SevenSegDecoder	port map(ALUout_o(7 downto 4) , HEX5);
	--------------------LEDS Binding-------------------------
	LEDs(0) <= Vflag_o;
	LEDs(1) <= Zflag_o;
	LEDs(2) <= Nflag_o;
	LEDs(3) <= Cflag_o;
	LEDs(9 downto 5) <= ALUFN_i;
	-------------------Keys Binding--------------------------
	process(KEY0, KEY1, KEY2) 
	begin
	--	if rising_edge(clk) then
			if KEY0 = '0' then
				Y     <= SW_i(n-1 downto 0);
			elsif KEY1 = '0' then
				ALUFN_i <= SW_i(4 downto 0);
			elsif KEY2 = '0' then
				X	  <= SW_i(n-1 downto 0);				
			elsif KEY3 = '0' then
				rst	  <= '1';	
			elsif SW_i(8) = '1' then
				ena	  <= '1';	
			end if;
--		end if;
	end process;
		
END roman;

