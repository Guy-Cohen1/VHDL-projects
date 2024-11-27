LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;

ENTITY clk_div IS
  PORT (
		  clk, ena, rst  : in std_logic; -- for single tap
		  -- Switch Port
		  q: out std_logic  
  );
END clk_div;

ARCHITECTURE roman OF clk_div IS 
	-- Signals for registers
	signal temp_clk : std_logic;

BEGIN

	Pll_part : pll port map(clk, rst, temp_clk);
	counter_part : counter port map(temp_clk, ena, q);

END roman;
