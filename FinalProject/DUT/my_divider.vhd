library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE work.aux_package.ALL;
-----------------------------------------
-- Entity Declaration for Divider
-----------------------------------------
entity Divider is
    Port (
        clk : in STD_LOGIC;          -- Clock signal
		
		Addr	: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		DIVRead	: IN	STD_LOGIC;
		
        reset : in STD_LOGIC;        -- Asynchronous reset signal
        ena : in STD_LOGIC;        -- Start signal to begin the division
        dividend : in  STD_LOGIC_VECTOR (31 downto 0); -- Input for dividend (32-bit)
        divisor : in  STD_LOGIC_VECTOR (31 downto 0); -- Input for divisor (32-bit)
        quotient_OUT : out  STD_LOGIC_VECTOR (31 downto 0); -- Output for quotient (32-bit)
        remainder_OUT : out  STD_LOGIC_VECTOR (31 downto 0); -- Output for remainder (32-bit)
		DIVIFG : buffer STD_LOGIC         -- Indicates an overflow condition
    );
end Divider;
----------------------------------------
-- Architecture Definition
----------------------------------------
architecture Behavioral of Divider is

    -- Define the states for the Finite State Machine (FSM)
    type state_type is (idle, shift, op);

    -- Signals for FSM state registers and next state values
    signal state_reg, state_next : state_type;   
    -- Registers for intermediate values during the division
    signal z_reg, z_next : unsigned(64 downto 0);  -- z_reg needs to store 64 bits: 32 for remainder + 32 for quotient
    signal divisor_reg, divisor_next : unsigned(31 downto 0);  -- divisor_reg is 32 bits for the divisor
    signal i_reg, i_next : unsigned(5 downto 0);   -- Counter to count 32 iterations
	signal quotient : STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); -- Output for quotient (32-bit)
    signal remainder:  STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); -- Output for remainder (32-bit)

    -- Signal for the result of subtraction
    signal sub : unsigned(32 downto 0);
              
begin

	quotient_OUT <= quotient;
	
	remainder_OUT <= remainder;
					
    -- Control path: Registers of the FSM
    process(clk, reset)
    begin
        if (reset='1') then
            state_reg <= idle; -- Reset the FSM to idle state
        elsif (clk'event and clk='1') then
            state_reg <= state_next; -- Update the state register
        end if;
    end process;
    
    -- Control path: Logic to determine the next state of the FSM
    process(state_reg, ena, dividend, divisor, i_next)
    begin
        case state_reg is 
            when idle =>
				if(i_reg = 32 and ena = '1') then
					DIVIFG <= '1';
				else
					DIVIFG <= '0';
				end if;
                if (ena='1') then
                    state_next <= shift; -- Move to shift state if start is asserted
                else
                    state_next <= idle; -- Stay in idle state if not started
                end if;
                        
            when shift =>
                state_next <= op; -- Move to operation state after shifting
				if(i_reg = i_next) then
					DIVIFG <= '0';
				end if;
                
            when op =>
                if (i_next = 32) then
                    state_next <= idle; -- Return to idle state when done
					--quotient_OUT <= quotient;
					--remainder_OUT <= remainder;
                else
                    state_next <= shift; -- Continue shifting
                end if;
                
        end case;
    end process;
    
    -- Control path: Output logic
    --DIVIFG <= '1' when (state_reg=idle and i_next = 0) else '0'; -- Signal when division is complete
    

    -- Control path: Registers for the counter used to count iterations
    process(clk, reset)
    begin
        if (reset='1') then
            i_reg <= (others => '0'); -- Reset the iteration counter
        elsif (clk'event and clk='1') then
            i_reg <= i_next; -- Update iteration counter
        end if;
    end process;
    
    -- Control path: Logic for the iteration counter
    process(state_reg, i_reg)
    begin
        case state_reg is
            when idle =>
                i_next <= (others => '0'); -- Initialize counter to zero in idle state
                
            when shift =>
                i_next <= i_reg; -- Keep counter value during shifting
                
            when op =>
                i_next <= i_reg + 1; -- Increment counter during operation
        end case;
    end process;
        
    -- Data path: Registers used in the data path
    process(clk, reset)
    begin
        if (reset='1') then
            z_reg <= (others => '0'); -- Reset the z register
            divisor_reg <= (others => '0'); -- Reset the d register
			
        elsif (clk'event and clk='1') then
            z_reg <= z_next; -- Update z register
            divisor_reg <= divisor_next; -- Update d register
        end if;
    end process;
    
    -- Data path: Multiplexers of the data path (handle register assignments based on FSM state)
    process(state_reg, dividend, divisor, z_reg, divisor_reg, sub)
    begin
        divisor_next <= unsigned(divisor); -- Update divisor register
        case state_reg is
            when idle =>
                z_next <=   "000000000000000000000000000000000" & unsigned(dividend); -- Initialize z with dividend in idle state (upper 32 bits are zero)
                
            when shift =>
                z_next <= z_reg(63 downto 0) & '0'; -- Shift left during shift state
                
            when op =>
                if (z_reg(63 downto 32) < divisor_reg) then
                    z_next <= z_reg; -- Keep z value if upper 32 bits are less than divisor
                else
                    z_next <= (z_reg(64 downto 32) - divisor_reg) & z_reg(31 downto 1) & '1'; -- Subtract divisor and update z with quotient bit
                end if;
        end case;
    end process;
    
    -- Data path: Functional units for subtraction
    sub <= z_reg(64 downto 32) - divisor_reg; -- Perform subtraction operation
    
    -- Data path: Output assignment
    quotient <= std_logic_vector(z_reg(31 downto 0)); -- Assign quotient output
    remainder <= std_logic_vector(z_reg(63 downto 32)); -- Assign remainder output
    
end Behavioral;
