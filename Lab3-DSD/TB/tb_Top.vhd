library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.std_logic_textio.all;
---------------------------------------------------------
entity OUR_top_TB is
	generic(BusSize : integer := 16;
			Awidth:  integer:=6;  	-- Address Size
			RegSize: integer:=4; 	-- Register Size
			m: 	  integer:=16  -- Program Memory In Data Size
	);
	constant dept      : integer:=64;
	
	constant dataMemResult:	 	string(1 to 45) :=
	"C:\hanan\CPU\LAB3\MemoryFiles\DTCMcontent.txt";
	
	constant dataMemLocation: 	string(1 to 42) :=
	"C:\hanan\CPU\LAB3\MemoryFiles\DTCMinit.txt";
	
	constant progMemLocation: 	string(1 to 42) :=
	"C:\hanan\CPU\LAB3\MemoryFiles\ITCMinit.txt";
end OUR_top_TB;
---------------------------------------------------------
architecture rtb of OUR_top_TB is

	SIGNAL done_FSM:													STD_LOGIC := '0';
	SIGNAL rst, ena, clk, TBactive, TBWrEnDataMem, TBWrEnProgMem: 		STD_LOGIC;	
	SIGNAL TBdataInDataMem, TBdataOutDataMem: 							STD_LOGIC_VECTOR (BusSize-1 downto 0); -- n
	SIGNAL TBdataInProgMem: 											STD_LOGIC_VECTOR (BusSize-1 downto 0); -- m (m=n?)
	SIGNAL TBWrAddrDataMem, TBWrAddrProgMem:  							STD_LOGIC_VECTOR (Awidth-1 DOWNTO 0);
	SIGNAL TBRdAddrDataMem:												STD_LOGIC_VECTOR (Awidth-1 DOWNTO 0);
	SIGNAL donePmemIn, doneDmemIn:										BOOLEAN;
	
begin
	
	TopUnit: top port map(	clk, rst, ena,
		done_FSM,
		TBdataInProgMem,
		TBdataInDataMem ,
		TBdataOutDataMem,
		TBactive,
		TBWrEnProgMem, TBWrEnDataMem,
		TBWrAddrProgMem, TBWrAddrDataMem, TBRdAddrDataMem);
						
    
	--------- start of stimulus section ------------------	
	
	--------- Rst
	gen_rst : process
	begin
	  rst <='1','0' after 100 ns;
	  wait;
	end process;
	
	------------ Clock
	gen_clk : process
	begin
	  clk <= '0';
	  wait for 50 ns;
	  clk <= not clk;
	  wait for 50 ns;
	end process;
	
	--------- 	TB
	gen_TB : process
        begin
		 TBactive <= '1';
		 wait until donePmemIn and doneDmemIn;  
		 TBactive <= '0';
		 wait until done_FSM = '1';  
		 TBactive <= '1';	
        end process;	
	
				
				
	--------- --Reading from text file and initializing the data memory data--------
	LoadDataMem: process 
		file inDmemfile : text open read_mode is dataMemLocation;
		variable    linetomem			: std_logic_vector(BusSize-1 downto 0);
		variable	good				: boolean;
		variable 	L 					: line;
		variable	TempAddresses		: std_logic_vector(Awidth-1 downto 0) ; -- Awidth
	begin 
		doneDmemIn <= false;
		TempAddresses := (others => '0');
		while not endfile(inDmemfile) loop
			readline(inDmemfile,L);
			hread(L,linetomem,good);
			next when not good;
			TBWrEnDataMem <= '1';
			TBWrAddrDataMem <= TempAddresses;
			TBdataInDataMem <= linetomem;
			wait until rising_edge(clk);
			TempAddresses := TempAddresses +1;
		end loop ;
		TBWrEnDataMem <= '0';
		doneDmemIn <= true;
		file_close(inDmemfile);
		wait;
	end process;
		
		
	--------- Reading from text file and initializing the program memory instructions ------
	LoadProgramMem: process 
		file inPmemfile : text open read_mode is progMemLocation;
		variable    linetomem			: std_logic_vector(BusSize-1 downto 0); 
		variable	good				: boolean;
		variable 	L 					: line;
		variable	TempAddresses		: std_logic_vector(Awidth-1 downto 0) ; -- Awidth
	begin 
		donePmemIn <= false;
		TempAddresses := (others => '0');
		while not endfile(inPmemfile) loop
			readline(inPmemfile,L);
			hread(L,linetomem,good);
			next when not good;
			TBWrEnProgMem <= '1';
			TBWrAddrProgMem <= TempAddresses;
			TBdataInProgMem <= linetomem;
			wait until rising_edge(clk);
			TempAddresses := TempAddresses +1;
		end loop ;
		TBWrEnProgMem <= '0';
		donePmemIn <= true;
		file_close(inPmemfile);
		wait;
	end process;
	

	ena <= '1' when (doneDmemIn and donePmemIn) else '0';
	
		
	--------- Writing from Data memory to external text file, after the program ends (done_FSM = 1). -----
	WriteToDataMem: process 
		file outDmemfile : text open write_mode is dataMemResult;
		variable    linetomem			: std_logic_vector(BusSize-1 downto 0);
		variable	good				: boolean;
		variable 	L 					: line;
		variable	TempAddresses		: std_logic_vector(Awidth-1 downto 0) ; -- Awidth
		variable 	counter				: integer;
	begin 
		wait until done_FSM = '1';  
		TempAddresses := (others => '0');
		counter := 1;
		while counter < 16 loop	--15 lines in file
			TBRdAddrDataMem <= TempAddresses;
			wait until rising_edge(clk);
			wait until rising_edge(clk); 
			hwrite(L,TBdataOutDataMem);
			writeline(outDmemfile,L);
			TempAddresses := TempAddresses +1;
			counter := counter +1;
		end loop ;
		file_close(outDmemfile);
		wait;
	end process;
		

end architecture rtb;

