LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.aux_package.ALL;

entity top is
    generic (
        n : positive := 8;
        m : positive := 7;
        k : positive := 3
    );
    port (
        rst, ena, clk : in std_logic;
        x : in std_logic_vector(n-1 downto 0);
        DetectionCode : in integer range 0 to 3;
        detector : out std_logic
    );
end top;

architecture arc_sys of top is
    signal res : std_logic_vector(n-1 downto 0);
    signal valid, cout : std_logic;
    signal help1 : std_logic_vector(2 downto 0);
    signal help2 : std_logic_vector(n-1 downto 0);
    signal x_minus_1 : std_logic_vector(n-1 downto 0);
    signal x_minus_2 : std_logic_vector(n-1 downto 0);
    signal ones : std_logic_vector(m-1 downto 0);
begin



	process2 : entity work.Adder 
        generic map (length => n) 
        port map (
            a => help2,
            b => x_minus_2,
            cin => '0',
            s => res,
            cout => cout
        );
	
	
	help1 <= "001" when DetectionCode = 0 else
			 "010" when DetectionCode = 1 else
			 "011" when DetectionCode = 2 else
			 "100" when DetectionCode = 3 else
			 "UUU";
			 
	help2 <= (0 => help1(0), 1 => help1(1), 2=> help1(2), others => '0');
    
	
	process(DetectionCode, res)
	
	begin
	    if res = x_minus_1 then valid <= '1';
		else valid <= '0';
		end if;
	end process;

	
	
	
    process(clk, rst, ena)
    begin
        if rst = '1' then
            x_minus_1 <= (others => '0');
            x_minus_2 <= (others => '0');
        elsif rising_edge(clk) then
            if ena = '1' then
                x_minus_2 <= x_minus_1;
                x_minus_1 <= x;
            end if;
        end if;
		
    end process;


    process(clk, rst, ena)
        variable counter : integer;
    begin
        ones <= (others => '1');
        if rst = '1' then
            detector <= '0';
            counter := 0;
        elsif rising_edge(clk) then
            if ena = '1' then
                if valid = '1' then
                    counter := counter + 1;
                else
                    counter := 0;
                end if;
            end if;
			
			if counter >= m  then
				detector <= '1';
			else
				detector <= '0';
			end if;
        end if;
    end process;
end arc_sys;
