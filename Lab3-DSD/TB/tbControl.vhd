library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
-- A test bench which checks the Control unit. 
---------------------------------------------------------
entity tbControl is

end tbControl;
---------------------------------------------------------
architecture Ctb of tbControl is
	signal		clk, rst, ena, st, ld, mov, done_in, add, sub, jmp, jc, jnc,Cflag, Zflag, Nflag:  std_logic;
	signal		IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in, a_nd, o_r, x0r :  std_logic;
	signal		OPC :  std_logic_vector(3 downto 0);
	signal 		PCsel, RFaddr :  std_logic_vector(1 downto 0);
	SIGNAL done_out:			STD_LOGIC := '0';
	
---------------------------------------------------------
begin
ControlUnit: Control 	port map(st, ld, mov, done_in, add, sub, jmp, jc, jnc, Cflag, Zflag, Nflag, a_nd, o_r, x0r,
		IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in,
		OPC,
		PCsel, RFaddr,
		clk, rst, ena,
		done_out
								);
    
	--------- start of stimulus section ------------------	
	
		gen_rst : process	-- reset process
        begin
		  rst <='1','0' after 100 ns;	-- reset at the begining of the system
		  wait;
        end process; 
		
		
        gen_clk : process	-- Clk process (duty cycle of 50% and period of 100 ns)
        begin
		  clk <= '1';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
		ena <= '1';

		--------------- Commands ---------------------
		
		sub_cmd : process
        begin
		  sub <= '0', '1' after 100 ns, '0' after 500 ns;
		  wait;
        end process; 
		
		or_cmd : process
        begin
		  o_r <='0','1' after 500 ns, '0' after 900 ns;
		  wait;
        end process;
		
		jmp_cmd : process
        begin
		  jmp <='0','1' after 900 ns, '0' after 1100 ns;
		  wait;
        end process;
		
		
		jc_cmd : process
        begin
		  jc <='0','1' after 1100 ns, '0' after 1300 ns;
		  wait;
        end process;
		
		
		jnc_cmd : process
        begin
		  jnc <='0','1' after 1300 ns, '0' after 1500 ns;
		  wait;
        end process;
		
		add_cmd : process
        begin
		  add <='0','1' after 1500 ns, '0' after 1900 ns;
		  wait;
        end process;
		
		done_in_cmd : process
        begin
		  done_in <='0','1' after 1900 ns, '0' after 2100 ns;
		  wait;
        end process;
		
		ld_cmd : process
        begin
		  ld <='0','1' after 2100 ns, '0' after 2600 ns;
		  wait;
        end process;
		
		mov_cmd : process
        begin
		  mov <='0','1' after 2600 ns, '0' after 2800 ns;
		  wait;
        end process;
		
		and_cmd : process
        begin
		  a_nd <='0','1' after 2800 ns, '0' after 3200 ns;
		  wait;
        end process;
		
		
		xor_cmd : process
        begin
		  x0r <='0','1' after 3200 ns, '0' after 3600 ns;
		  wait;
        end process;
		
		
end architecture Ctb;
