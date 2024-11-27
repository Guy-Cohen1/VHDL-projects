library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

--
--------------------------------------------------------------
entity Datapath is
generic( BusSize: integer:=16;	-- Bus Size
		 RegSize: integer:=4; 	-- Register Size
		 m: 	  integer:=16;  -- Program Memory In Data Size
		 Awidth:  integer:=6;  	-- Address Size
		 OffsetSize 	: integer := 8;
		 ImmidSize	: integer := 8;		 
		 dept:    integer:=64); -- Program Memory Size
port(	
		-- Op Status Signals --
		st, ld, mov, done_DM, add, sub, jmp, jc, jnc, CFlag, ZFlag, NFlag, o_r, x0r, a_nd : out std_logic;	
		-- st, ld, mov, done_DM, add, sub, jmp, jc, jnc, nop, CFlag, ZFlag, NFlag, neg, jz : out std_logic; -- Real time 
		-- Control Signals --
		IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in : in std_logic;
		OPC : in std_logic_vector(3 downto 0);
		PCsel, RFaddr : in std_logic_vector(1 downto 0);	
		-- Test Bench Signals --
		TBactive, clk, rst : in std_logic;
		TBWrEnProgMem, TBWrEnDataMem : in std_logic;
		TBdataInProgMem    : in std_logic_vector(m-1 downto 0);
		TBdataInDataMem    : in std_logic_vector(BusSize-1 downto 0);
		TBWrAddrProgMem, TBWrAddrDataMem, TBRdAddrDataMem :	in std_logic_vector(Awidth-1 downto 0);
		TBdataOutDataMem   : out std_logic_vector(BusSize-1 downto 0);
		-- Debug Signal --
		DebugSignal		 : out std_logic_vector(BusSize-1 downto 0)
);

end Datapath;
--------------------------------------------------------------
architecture behav of Datapath is
-- Program Memory --
signal dataOutProgMem : std_logic_vector(BusSize-1 downto 0);
signal RdAddrProgMem : std_logic_vector(Awidth-1 downto 0) := "000000";

-- Data Memory --
signal dataOutDataMem, dataInDataMem : std_logic_vector(BusSize-1 downto 0);
signal WrAddrDataMem : std_logic_vector(Awidth-1 downto 0);
signal RdAddrDataMem : std_logic_vector(BusSize-1 downto 0);
signal WrAddrDataMemMuxOut, RdAddrDataMemMuxOut	: std_logic_vector(Awidth-1 downto 0);
signal WrEnDataMem : std_logic;

-- Reg File --
signal WDataRF, RDataRF : std_logic_vector(BusSize-1 downto 0);
signal RWAddrRF 		: std_logic_vector(RegSize-1 downto 0);	  -- Was AWidth
	
-- ALU --
signal A, B, C : std_logic_vector(BusSize-1 downto 0);
Signal CregOut : std_logic_vector(BusSize-1 downto 0);

-- IR --
signal IR_OffsetAddr : std_logic_vector(OffsetSize-1 downto 0);
signal IR_Immid	     : std_logic_vector(ImmidSize-1 downto 0);
signal IROp		 : std_logic_vector(RegSize-1 downto 0);

-- General Purpose Signals
signal Immidiate	: std_logic_vector(BusSize-1 downto 0);

-- Bus Signal 
signal DataBUS 		: std_logic_vector(BusSize-1 downto 0);

begin 
----------------------------------------- PORT MAPS --------------------------------------------
-- Program Memory - (clk, memEn, WmemData, WmemAddr, RmemAddr, RmemData)
ProgMemModule:	progMem 	generic map(BusSize,Awidth,dept)	port map (clk, TBWrEnProgMem, TBdataInProgMem, TBWrAddrProgMem, RdAddrProgMem, dataOutProgMem);
-- Data Memory    - (clk, memEn, WmemData, WmemAddr, RmemAddr, RmemData)
DataMemModule:	dataMem 	generic map(BusSize,Awidth,dept)	port map (clk, WrEnDataMem, dataInDataMem, WrAddrDataMemMuxOut, RdAddrDataMemMuxOut, dataOutDataMem);
-- Register File  - (clk, rst, WregEn, WregData, WregAddr, RregAddr, RregData)
RegFileModule:	RF			generic map(BusSize,RegSize)			port map (clk, rst, RFin, WDataRF, RWAddrRF, RWAddrRF, RDataRF);
-- ALU            - (A, B, OPC, CFlag, Zflag, Nflag, C)
ALUModule:		ALU			generic map(BusSize)				port map (A, B, OPC, C, NFlag, CFlag, ZFlag);		
-- OPC Decoder    - (IRreg, st, ld, mov, done_DM, add, sub, jmp, jc, jnc, nop)
OPCdecModule:	OPCdecoder 	generic map(RegSize)				port map(IROp, st, ld, mov, done_DM, add, sub, jmp, jc, jnc, a_nd, o_r, x0r);
-- PC             - (IR_offset, PCsel, PCin, clk, PCout)
PCLogicModule:	PC 	generic map(Awidth)					port map(IR_OffsetAddr, PCsel, PCin, clk, RdAddrProgMem);
-- IR 			  - (dataOutProgMem, IRin, RFaddr, RWAddrRF, OffsetAddr, Immid, IROp)
IRModule:		IR			generic map(BusSize)				port map(dataOutProgMem, IRin, RFaddr, RWAddrRF, IR_OffsetAddr, IR_Immid, IROp);
--------------------------------------------------------------------------------------------------

------------------------------------------ Debug -------------------------------------------
DebugSignal <= dataOutProgMem;

----------------------------------------- BiDir Bus ------------------------------------------
-- BidirPin            - (Dout, en, Din, IOpin), DOUT input of buffer, DIN input of module
BusConnectionToRF: BidirPin			generic map(BusSize)	port map(RDataRF, RFout, WDataRF, DataBUS);
BusConnectionToALU: BidirPin		generic map(BusSize)	port map(CregOut, Cout, B, DataBUS); 
BusConnectionToDataMem: BidirPin	generic map(BusSize)	port map(dataOutDataMem, Mem_out, RdAddrDataMem, DataBUS);
BusConnectionToImm1: BidirPin		generic map(BusSize)	port map(Immidiate, Imm1_in, WDataRF, DataBUS);
BusConnectionToImm2: BidirPin		generic map(BusSize)	port map(Immidiate, Imm2_in, WDataRF, DataBUS);


-- Immidiate Sign Extention 
Immidiate <= 	SXT(IR_Immid, BusSize) when Imm1_in ='1' else
				"000000000000" & IR_Immid(RegSize-1 downto 0)		when Imm2_in = '1' else
				unaffected;

--------------- ALU Connections Register -------------------------
ALU_Registers: process(clk) 
begin
	if (clk'event and clk='1') then
		if (Ain = '1') then
			A <= DataBUS;  -- was <= databus
		end if;
		if(Cin = '1') then
			CregOut <= C;
		end if;
	end if;
			
end process;

--------------- Data Memory Write ----------------
DataMem_Write: process(clk) 
begin
	if (clk'event and clk='1') then
		if (Mem_in = '1') then
			WrAddrDataMem <= DataBUS(Awidth-1 downto 0);
		end if;
	end if;
			
end process;
----------------------------------------------------------------------------------------------


----- Test Bench Connections --------
-- Data Memory TB
WrEnDataMem      	<= TBWrEnDataMem	  	when TBactive = '1' 	else Mem_wr;
dataInDataMem    	<= TBdataInDataMem		when TBactive = '1' 	else DataBUS;
WrAddrDataMemMuxOut <= TBWrAddrDataMem 		when TBactive = '1' 	else WrAddrDataMem;
RdAddrDataMemMuxOut <= TBRdAddrDataMem 		when TBactive = '1' 	else RdAddrDataMem(Awidth-1 downto 0);
TBdataOutDataMem 	<= dataOutDataMem;

end behav;
