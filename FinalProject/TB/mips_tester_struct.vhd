
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MCU_tester IS
	GENERIC(IOSize : INTEGER := 8);
	PORT( 
		HEX0, HEX1			: IN	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2, HEX3			: IN	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX4, HEX5			: IN	STD_LOGIC_VECTOR(6 DOWNTO 0);
		Switches			: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		clock       		: OUT   STD_LOGIC;
		ena					: OUT   STD_LOGIC;
		KEY1, KEY2, KEY3	: OUT	STD_LOGIC;
		reset       : OUT   STD_LOGIC
   );



END MCU_tester;


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;


ARCHITECTURE struct OF MCU_tester IS


   SIGNAL mw_U_0clk : std_logic;
   SIGNAL mw_U_0disable_clk : boolean := FALSE;
   SIGNAL mw_U_1pulse : std_logic :='0';


BEGIN

 
   u_0clk_proc: PROCESS
   BEGIN
      WHILE NOT mw_U_0disable_clk LOOP
         mw_U_0clk <= '0', '1' AFTER 50 ns;
         WAIT FOR 100 ns;
      END LOOP;
      WAIT;
   END PROCESS u_0clk_proc;
   mw_U_0disable_clk <= TRUE AFTER 10000000 ns;
   clock <= mw_U_0clk;


   ena	 <= '1';
   reset <= mw_U_1pulse;
   u_1pulse_proc: PROCESS
   BEGIN
      mw_U_1pulse <= 
         '0',
         '1' AFTER 20 ns,
         '0' AFTER 120 ns;

      WAIT;
    END PROCESS u_1pulse_proc;


   Switches <= X"A5";

 
  inter_key1_proc: PROCESS
  BEGIN
        KEY1 <= 
        '1',
        '0' AFTER 20000 ns,
        '1' AFTER 20100 ns;
       WAIT;
  END PROCESS inter_key1_proc;
   
 
END struct;
