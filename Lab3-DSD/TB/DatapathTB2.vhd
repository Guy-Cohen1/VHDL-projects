library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.std_logic_textio.all;
---------------------------------------------------------
entity tb200 is
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
end tb200;
----------
architecture tb_behav of tb200 is

signal		st, ld, mov, done_DM, add, sub, jmp, jc, jnc, nop, Cflag, Zflag, Nflag,  O_R, X0R, A_ND:  std_logic;
signal		IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in :  std_logic;
signal		OPC :  std_logic_vector(3 downto 0);
signal 		done_FSM : std_logic;
signal 		PCsel, RFaddr :  std_logic_vector(1 downto 0);
signal 		TBactive, clk, rst : std_logic;
signal 		TBWrEnProgMem, TBWrEnDataMem : std_logic;
signal 		TBdataInDataMem    : std_logic_vector(BusSize-1 downto 0);
signal 		TBdataInProgMem    : std_logic_vector(m-1 downto 0);
signal 		TBWrAddrProgMem, TBWrAddrDataMem, TBRdAddrDataMem : std_logic_vector(Awidth-1 downto 0);
signal 		TBdataOutDataMem   : std_logic_vector(BusSize-1 downto 0);
signal 	    donePmemIn, doneDmemIn:	 BOOLEAN;
signal 		DebugSignal		 : std_logic_vector(BusSize-1 downto 0);

begin 

DataPathUnit: Datapath generic map(BusSize)  port map(st, ld, mov, done_DM, add, sub, jmp, jc, jnc, Cflag, Zflag, Nflag, O_R, X0R, A_ND,
													IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in,
													OPC, PCsel, RFaddr,
													TBactive, clk, rst, 
													TBWrEnProgMem, TBWrEnDataMem,
													TBdataInProgMem, TBdataInDataMem, TBWrAddrProgMem, TBWrAddrDataMem, TBRdAddrDataMem,
													TBdataOutDataMem, DebugSignal);
													


--------- Clock
gen_clk : process
	begin
	  clk <= '0';
	  wait for 50 ns;
	  clk <= not clk;
	  wait for 50 ns;
	end process;

--------- Rst
gen_rst : process
        begin
		  rst <='1','0' after 100 ns;
		  wait;
        end process;	
--------- TB
gen_TB : process
	begin
	 TBactive <= '1';
	 wait until donePmemIn and doneDmemIn;  
	 TBactive <= '0';
	 wait until done_FSM = '1';  
	 TBactive <= '1';	
	end process;	
	
	
--------- Reading from text file and initializing the data memory data--------------
LoadDataMem:process 
	file inDmemfile : text open read_mode is dataMemLocation;
	variable    linetomem			: std_logic_vector(BusSize-1 downto 0);
	variable	good				: boolean;
	variable 	L 					: line;
	variable	TempAddresses		: std_logic_vector(Awidth-1 downto 0) ; 
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
	
	
--------- Reading from text file and initializing the program memory instructions	
LoadProgramMem:process 
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


--------- Start Test Bench ---------------------
StartTb : process
	begin
	
		wait until donePmemIn and doneDmemIn;  

------------- Reset ------------------------		
	 --reset
		wait until clk'EVENT and clk='1';
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; -- ALU unaffected
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "00";   -- RF unaffected
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "11";  -- PC = zeros 
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
---------------------- Instruction For Load - D104-----------------------------		
------------- Fetch ------------------------
		
		wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01"; 
		PCsel	 <= "01";		
		IRin 	 <= '0';
		PCin	 <= '0';	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				
------------- Load  ------------------------
-- ItypeState0
		wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0'; 
		Cin	 	 <= '1';
		OPC	 	 <= "0000"; 	
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "10";  		 
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '1';
		Mem_out	 <= '0';			
		done_FSM  <= '0';
		Mem_in	 <= '1';
------------- Load  ------------------------
-- ItypeState1
		wait until clk'EVENT and clk='1'; 
		
		Cout	 <= '1'; 
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';				
		done_FSM  <= '0';
		Mem_out	 <= '0';  
		RFin	 <= '0'; 
		RFout	 <= '0'; 
		Mem_wr	 <= '0';
		Mem_in	 <= '0';
------------- Load  ------------------------
-- ItypeState2
		wait until clk'EVENT and clk='1'; 
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';	
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
		Mem_wr	 <= '0'; 
		Mem_out	 <= '1';  
		RFin	 <= '1';
		RFout 	 <= '0';
-----------------------------------------------------------------------------
---------------------- Instruction For Load - D205-----------------------------	
------------- Fetch ------------------------		
		wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01"; 
		PCsel	 <= "01";		
		IRin 	 <= '0';
		PCin	 <= '0';	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				

------------- Load  ------------------------
-- ItypeState0
		wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0'; 
		Cin	 	 <= '1';
		OPC	 	 <= "0000"; 	
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "10";  		 
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '1';
		Mem_out	 <= '0';			
		done_FSM  <= '0';
		Mem_in	 <= '1';
------------- Load  ------------------------
-- ItypeState1
		wait until clk'EVENT and clk='1'; 
		
		Cout	 <= '1'; 
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';				
		done_FSM  <= '0';
		Mem_out	 <= '0';  
		RFin	 <= '0'; 
		RFout	 <= '0'; 
		Mem_wr	 <= '0';
		Mem_in	 <= '0';
------------- Load  ------------------------
-- ItypeState2
		wait until clk'EVENT and clk='1'; 
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';	
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
		Mem_wr	 <= '0'; 
		Mem_out	 <= '1';  
		RFin	 <= '1';
		RFout 	 <= '0';

-------------------------------------------------------------------------------
---------------------- Instruction For Mov - C31F-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode - Mov ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0'; 
		RFin	 <= '1';
		RFout	 <= '0';  
		RFaddr	 <= "10";  
		IRin 	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";				
		Imm1_in	 <= '1';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';	
-------------------------------------------------------------------------------
---------------------- Instruction For Mov - C401-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode - Mov ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0'; 
		RFin	 <= '1';
		RFout	 <= '0';  
		RFaddr	 <= "10";  
		IRin 	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";				
		Imm1_in	 <= '1';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
-------------------------------------------------------------------------------
---------------------- Instruction For Mov - C50E-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode - Mov ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0'; 
		RFin	 <= '1';
		RFout	 <= '0';  
		RFaddr	 <= "10";  
		IRin 	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";				
		Imm1_in	 <= '1';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';			
-------------------------------------------------------------------------------
---------------------- Instruction For AND - 2113-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01";  
		IRin 	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";				
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				
------------- AND -----------------------------	
--RtypeState0
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '1'; 
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '1'; 
        RFaddr	 <= "00";
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
		OPC <= "0000";
------------- AND -----------------------------	
--RtypeState1
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
		Cout	 <= '1';  
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '1';
		RFout	 <= '0';
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
-------------------------------------------------------------------------------
---------------------- Instruction For AND - 2223-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01";  
		IRin 	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";				
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				
------------- AND -----------------------------	
--RtypeState0
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '1'; 
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '1'; 
        RFaddr	 <= "00";
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
		OPC <= "0000";
------------- AND -----------------------------	
--RtypeState1
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
		Cout	 <= '1';  
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '1';
		RFout	 <= '0';
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
-------------------------------------------------------------------------------
---------------------- Instruction For SUB - 1621-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01";  
		IRin 	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";				
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				
------------- Sub -----------------------------	
--RtypeState0
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '1'; 
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '1'; 
        RFaddr	 <= "00";
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
		OPC 	 <= "0001";
------------- Sub -----------------------------	
--RtypeState1
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
		Cout	 <= '1';  
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '1';
		RFout	 <= '0';
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
-------------------------------------------------------------------------------
---------------------- Instruction For JC - 8002-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0'; 
		RFin	 <= '0';
		RFout	 <= '0';  
		RFaddr	 <= "01";  
		IRin 	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "10";				
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';	
-------------------------------------------------------------------------------
---------------------- Instruction For Add - 0640-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01";  
		IRin 	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";				
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				
------------- Add -----------------------------	
--RtypeState0
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '1'; 
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '1'; 
        RFaddr	 <= "00";
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
		OPC 	 <= "0000";
------------- Add -----------------------------	
--RtypeState1
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
		Cout	 <= '1';  
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '1';
		RFout	 <= '0';
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
-------------------------------------------------------------------------------
---------------------- Instruction For JMP - 7001-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0'; 
		RFin	 <= '0';
		RFout	 <= '0';  
		RFaddr	 <= "01";  
		IRin 	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "11";				
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';	
		-------------------------------------------------------------------------------
---------------------- Instruction For Add - 0600-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01";  
		IRin 	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";				
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				
------------- Add -----------------------------	
--RtypeState0
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '1'; 
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '1'; 
        RFaddr	 <= "00";
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
		OPC 	 <= "0000";
------------- Add -----------------------------	
--RtypeState1
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
		Cout	 <= '1';  
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '1';
		RFout	 <= '0';
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
-------------------------------------------------------------------------------
---------------------- Instruction For Store - E650-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01"; 
		PCsel	 <= "01";		
		IRin 	 <= '0';
		PCin	 <= '0';	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				

------------- Store  ------------------------
-- ItypeState0
		wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0'; 
		Cin	 	 <= '1';
		OPC	 	 <= "0000"; 	
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "10";  		 
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '1';
		Mem_out	 <= '0';			
		done_FSM  <= '0';
		Mem_in	 <= '0';
------------- Store  ------------------------
-- ItypeState1
		wait until clk'EVENT and clk='1'; 		
		Cout	 <= '1'; 
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';				
		done_FSM  <= '0';
		RFout	 <= '0'; 
		Mem_wr	 <= '0'; 
		RFin	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '1';  
------------- Store  ------------------------
-- ItypeState2
		wait until clk'EVENT and clk='1'; 
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';	
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
		Mem_out	 <= '0';	
		RFout	 <= '1'; 
		Mem_wr	 <= '1'; 
		RFin	 <= '0';
		-------------------------------------------------------------------------------
---------------------- Instruction For NOP - 0000-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01";  
		IRin 	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";				
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				
------------- Add -----------------------------	
--RtypeState0
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '1'; 
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '1'; 
        RFaddr	 <= "00";
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
		OPC 	 <= "0000";
------------- Add -----------------------------	
--RtypeState1
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
		Cout	 <= '1';  
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '1';
		RFout	 <= '0';
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
-------------------------------------------------------------------------------
---------------------- Instruction For DONE - 0600-----------------------------
------------- Fetch ------------------------
		
		wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01"; 
		PCsel	 <= "01";		
		IRin 	 <= '0';
		PCin	 <= '1';	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '1';		
-------------------------------------------------------------------------------
---------------------- Instruction For JMP - 70FE-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0'; 
		RFin	 <= '0';
		RFout	 <= '0';  
		RFaddr	 <= "01";  
		IRin 	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "11";				
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';	

--******************************************************************

------------- End: go back to reset---------------------------------	
------------- Reset ------------------------		
		wait until clk'EVENT and clk='1';
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; -- ALU unaffected
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "00";   -- RF unaffected
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "11";  -- PC = zeros 
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '1';
		wait;
		
	end process;	
	
	
	--------- Writing from Data memory to external text file, after the program ends (done_FSM = 1).
	
	WriteToDataMem:process 
		file outDmemfile : text open write_mode is dataMemResult;
		variable    linetomem			: STD_LOGIC_VECTOR(BusSize-1 downto 0);
		variable	good				: BOOLEAN;
		variable 	L 					: LINE;
		variable	TempAddresses		: STD_LOGIC_VECTOR(Awidth-1 downto 0) ; 
		variable 	counter				: INTEGER;
	begin 

		wait until done_FSM = '1';  
		TempAddresses := (others => '0');
		counter := 1;
		while counter < 16 loop	--15 lines in file
			TBRdAddrDataMem <= TempAddresses;
			wait until rising_edge(clk);   -- 
			wait until rising_edge(clk); -- 
			linetomem := TBdataOutDataMem;   --
			hwrite(L,linetomem);
			writeline(outDmemfile,L);
			TempAddresses := TempAddresses +1;
			counter := counter +1;
		end loop ;
		file_close(outDmemfile);
		wait;
	end process;


end tb_behav;
