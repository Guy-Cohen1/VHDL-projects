library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity tb3 is
    constant n : integer := 8;
    constant k : integer := 3;   -- k=log2(n)
    constant m : integer := 4;   -- m=2^(k-1)
    constant ROWmax : integer := 39;  -- Increased ROWmax to match more entries
end tb3;

architecture rtb of tb3 is
    type mem is array (0 to ROWmax) of std_logic_vector(4 downto 0);
    SIGNAL Y, X:  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    SIGNAL ALUFN :  STD_LOGIC_VECTOR (4 DOWNTO 0);
    SIGNAL ALUout:  STD_LOGIC_VECTOR(n-1 downto 0); 
    SIGNAL Nflag, Cflag, Zflag, Vflag, p_out: STD_LOGIC;
    SIGNAL clk, rst, ena: STD_LOGIC;
    SIGNAL Icache : mem := (
        "00000", "00001", "01010", "01000", "01001", "01010", "01000", "01001", "10000", "10001",
        "10010", "10000", "10001", "10010", "11001", "11010", "11101", "11111", "11011", "00100",
        "01100", "01101", "01110", "01111", "10000", "10001", "10010", "10011", "10100", "10101",
        "10110", "10111", "11000", "11001", "11010", "11011", "11100", "11101", "11110", "11111"
    );
begin
    L0 : top generic map (n) port map(X, Y, clk, rst, ena, ALUFN, ALUout, Nflag, Cflag, Zflag, Vflag, p_out);
    
    -- Clock generation process
    clk_gen : process
    begin
        clk <= '0';
        wait for 10 ps;
        clk <= '1';
        wait for 10 ps;
    end process;
    
    -- Reset and enable signals generation process
    rst_ena_gen : process
    begin
        rst <= '1';
        ena <= '0';
        wait for 20 ns;
        rst <= '0';
        ena <= '1';
        wait;
    end process;
    
    -- Stimulus process for X and Y
    tb_x_y : process
    begin
        X <= (others => '1');
        Y <= (others => '1');
        wait for 50 ns;
        for i in 0 to 40 loop
            X <= X - 10;
            Y <= Y - 1;
            wait for 50 ns;
        end loop;
        wait;
    end process;
     
    -- Stimulus process for ALUFN
    tb_ALUFN : process
    begin
        ALUFN <= (others => '0');
        for i in 0 to ROWmax loop
            ALUFN <= Icache(i);
            wait for 100 ns;
        end loop;
        wait;
    end process;
  
end architecture rtb;
