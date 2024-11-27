LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;
-------------------------------------
ENTITY OPCDECODER IS
	generic(width: integer:=4 );
	PORT(Op :IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 st,ld,mov,done,add,sub,jmp,jc, jnc,a_nd,o_r,x0r :OUT STD_LOGIC);
END OPCDECODER;
------------------------------------------------
ARCHITECTURE colson OF OPCDECODER IS
	
	begin
		st <= '1' when Op = "1110" else '0';
		ld <= '1' when Op = "1101" else '0';
		mov <= '1' when Op = "1100" else '0';
		done <= '1' when Op = "1111" else '0';
		add <= '1' when Op = "0000" else '0';
		sub <= '1' when Op = "0001" else '0';
		jmp <= '1' when Op = "0111" else '0';
		jc <= '1' when Op = "1000" else '0';
		jnc <= '1' when Op = "1001" else '0';
		a_nd <= '1' when Op = "0010" else '0';
		o_r <= '1' when Op = "0011" else '0';
		x0r <= '1' when Op = "0100" else '0';
END colson;