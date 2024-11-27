library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

ENTITY Pwm IS
    GENERIC (n : INTEGER := 8);
    PORT (
        x, y: IN std_logic_vector(n-1 downto 0);
        fn, rst, clk, ena : IN std_logic;
        pwm_out : OUT std_logic
    );
END Pwm;

ARCHITECTURE Hord OF Pwm IS
    signal q_int : std_logic_vector(n-1 downto 0) := (others => '0');
BEGIN

    process (clk)
    begin
        if (rst = '1') then
            q_int <= (others => '0');
            if (fn = '0') then
                pwm_out <= '0';
            else
                pwm_out <= '1';
            end if;
        elsif rising_edge(clk) then
            if ena = '1' then
                q_int <= q_int + 1;
                if (fn = '0') then
                    if (q_int > x) then
                        pwm_out <= '1';
                    else
                        pwm_out <= '0';
                    end if;
                else
                    if (q_int > x) then
                        pwm_out <= '0';
                    else
                        pwm_out <= '1';
                    end if;
                end if;
                if (q_int = y) then
                    q_int <= (others => '0');
                end if;
            end if;
        end if;
    end process;

END Hord;
