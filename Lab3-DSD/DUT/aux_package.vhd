library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------  
component FA is
	PORT (xi, yi, cin: IN std_logic;
			  s, cout: OUT std_logic);
end component;
------------------------------------------------------------

component AdderSub IS
  GENERIC (n : INTEGER := 16);
  PORT (     sub_cont: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			 x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
            cout: OUT STD_LOGIC;
               res: OUT STD_LOGIC_VECTOR(n-1 downto 0));
END component;	

---------------------------------------------------------------
component shifter is 
	GENERIC (
        n : INTEGER := 16;
        k : INTEGER := 4
    );
	port ( Y, X : in STD_LOGIC_VECTOR (n-1 downto 0);
			dir : in STD_LOGIC_VECTOR (2 downto 0);
			res : out STD_LOGIC_VECTOR (n-1 downto 0);
			cout : out STD_LOGIC
			);
end component;
--------------------------------------------------------------
component logic IS
	GENERIC (n : INTEGER := 16);
	PORT (x, y: IN std_logic_vector (n-1 downto 0);
			fn : IN std_logic_vector (2 downto 0);
			  res : OUT std_logic_vector (n-1 downto 0));
END component;
-------------------------------------------------------------
component OPCDECODER IS
	
	PORT(Op :IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 st,ld,mov,done,add,sub,jmp,jc,JNC,a_nd,o_r,x0r :OUT STD_LOGIC);
END component;
--------------------------------------------------------------
component PC IS
	GENERIC(AddrSize		:INTEGER := 6;
			OffsetSize		:INTEGER := 8);
	PORT(	IRoffset 		:IN STD_LOGIC_VECTOR(OffsetSize-1 DOWNTO 0);
			PCsel			:IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			PCin, clk		:IN STD_LOGIC;
			PCout			:OUT std_logic_vector(AddrSize-1 downto 0) := "000000"
			);
END component;
---------------------------------------------------------------
component IR is 
	generic(BusSize		: integer := 16;
			RegSize		: integer := 4;
			OffsetSize 	: integer := 8;
			ImmidSize	: integer := 8
	);
	port(dataOutProgMem	: in  std_logic_vector(BusSize-1 downto 0);
		IRin			: in  std_logic;
		RFaddr 			: in  std_logic_vector(1 downto 0);
		RWAddrRF		: out std_logic_vector(RegSize-1 downto 0);
		OffsetAddr		: out std_logic_vector(OffsetSize-1 downto 0);
		Immid			: out std_logic_vector(ImmidSize-1 downto 0);
		IROp			: out std_logic_vector(RegSize-1 downto 0)
	);
end component;
---------------------------------------------------------------
component ALU IS
  GENERIC (n : INTEGER := 16;
		   k : integer := 4;   -- k=log2(n)
		   m : integer := 8	); -- m=2^(k-1)
  PORT 
  (  
	A,B: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  OPC : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		  C: out STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag,Cflag,Zflag: OUT STD_LOGIC
  ); 
END component;
-----------------------------------------------------------------
component BidirPin is
	generic( width: integer:= 16 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
END component;
-------------------------------------------------------------------
component BidirPinBasic is
	port(   writePin: in 	std_logic;
			readPin:  out 	std_logic;
			bidirPin: inout std_logic
	);
END component;
------------------------------------------------------------------
component dataMem is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
port(	clk,memEn: in std_logic;	
		WmemData:	in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr,RmemAddr:	
					in std_logic_vector(Awidth-1 downto 0);
		RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
);
END component;
------------------------------------------------------------------
component ProgMem is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
port(	clk,memEn: in std_logic;	
		WmemData:	in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr,RmemAddr:	
					in std_logic_vector(Awidth-1 downto 0);
		RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
);
END component;
--------------------------------------------------------------------
component RF is
generic( Dwidth: integer:=16;
		 Awidth: integer:=4);
port(	clk,rst,WregEn: in std_logic;	
		WregData:	in std_logic_vector(Dwidth-1 downto 0);
		WregAddr,RregAddr:	
					in std_logic_vector(Awidth-1 downto 0);
		RregData: 	out std_logic_vector(Dwidth-1 downto 0)
);
END component;
-------------------------------------------------------------------
component Control IS
	PORT(
		st, ld, mov, done_DM, add, sub, jmp, jc, jnc, Cflag, Zflag, Nflag, a_nd, o_r, x0r : in std_logic;
		IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in : out std_logic;
		OPC : out std_logic_vector(3 downto 0);
		PCsel, RFaddr : out std_logic_vector(1 downto 0);
		clk, rst, ena : in STD_LOGIC;
		done_FSM : out std_logic
	);
end component ;
----------------------------------------------------------------------
component Datapath is
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

end component;
-------------------------------------------------------------------------
component top IS
	generic( BusSize: integer:=16;	-- Data Memory In Data Size
		 m: 	  integer:=16;  -- Program Memory In Data Size
		 Awidth:  integer:=6;
		 RegSize:  integer:=4);  	-- Address Size
	PORT(
		clk, rst, ena  : in STD_LOGIC;
		done_FSM : out std_logic;	
		
		-- Test Bench
		TBdataInProgMem  : in std_logic_vector(m-1 downto 0);
		TBdataInDataMem  : in std_logic_vector(BusSize-1 downto 0);
		TBdataOutDataMem : out std_logic_vector(BusSize-1 downto 0);
		TBactive	   : in std_logic;
		TBWrEnProgMem, TBWrEnDataMem : in std_logic;
		TBWrAddrProgMem, TBWrAddrDataMem, TBRdAddrDataMem :	in std_logic_vector(Awidth-1 downto 0)
	);
end component ;



end aux_package;

