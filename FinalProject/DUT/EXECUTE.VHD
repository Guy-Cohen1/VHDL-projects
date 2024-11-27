LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-----------------------------------------
-- Entity Declaration for Execute
-----------------------------------------
ENTITY Execute IS
    PORT(
		opcode           : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
        Read_data_1      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        Read_data_2      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        Sign_extend      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        Function_opcode  : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
        ALUOp            : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        ALUSrc           : IN  STD_LOGIC;
        Zero             : OUT STD_LOGIC;
        ALU_result       : buffer STD_LOGIC_VECTOR(31 DOWNTO 0);
        Add_Result       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        PC_plus_4        : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        clock, reset     : IN  STD_LOGIC
    );
END Execute;
----------------------------------------
-- Architecture Definition
----------------------------------------
ARCHITECTURE behavior OF Execute IS
    SIGNAL Ainput, Binput         : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ALU_output_mux         : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL not_Rtype_result       : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL multiplication_result  : STD_LOGIC_VECTOR(63 DOWNTO 0);
	SIGNAL sll_slr_result         : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL slti_result            : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Branch_Add             : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL ALU_ctl                : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL amount_of_shifts       : INTEGER := 0;  
BEGIN
    -- ALU input mux
    Ainput <= Read_data_1;
    Binput <= Read_data_2 WHEN ALUSrc = '0' ELSE Sign_extend;

    -- Amount of shifts for SLL and SRL
    amount_of_shifts <= to_integer(unsigned(Sign_extend(10 DOWNTO 6))) WHEN (Function_opcode = "000000") ELSE
                        to_integer(unsigned(Sign_extend(10 DOWNTO 6))) WHEN (Function_opcode = "000010") ELSE
                        0;
	
	multiplication_result <= std_logic_vector(unsigned(Ainput) * unsigned(Binput)) WHEN (opcode = "011100") ELSE (OTHERS => '0');
	
	Zero <= '1' WHEN ALU_result = "00000000000000000000000000000000" ELSE '0';
	
    -- SLTI result
    slti_result <= X"00000001" WHEN (signed(Ainput) < signed(Sign_extend)) ELSE X"00000000";

    -- Generate ALU control bits
    PROCESS (Function_opcode, ALUOp)
    BEGIN
        IF (Function_opcode = "000000" OR Function_opcode = "000010") THEN
            ALU_ctl(0) <= '1';
            ALU_ctl(1) <= '0';
            ALU_ctl(2) <= '1';
        ELSE
            ALU_ctl( 0 ) <= ( Function_opcode( 0 ) OR Function_opcode( 3 ) ) AND ALUOp(1 );
			ALU_ctl( 1 ) <= ( NOT Function_opcode( 2 ) ) OR (NOT ALUOp( 1 ) );
			ALU_ctl( 2 ) <= ( Function_opcode( 1 ) AND ALUOp( 1 )) OR ALUOp( 0 );
        END IF;
    END PROCESS;
	
	sll_slr_result <= std_logic_vector(shift_left(unsigned(Binput), amount_of_shifts)) WHEN (Function_opcode = "000000") ELSE
                      std_logic_vector(shift_right(unsigned(Binput), amount_of_shifts)) WHEN (Function_opcode = "000010") ELSE
                      (OTHERS => '0');
	
    -- Adder to compute Branch Address
    -- Convert PC_plus_4(9 DOWNTO 2) and Sign_extend(9 DOWNTO 2) to unsigned
	Branch_Add	<= std_logic_vector(unsigned(PC_plus_4( 9 DOWNTO 2 )) +  unsigned(Sign_extend( 7 DOWNTO 0 ))) ;
	Add_result 	<= Branch_Add( 7 DOWNTO 0 );
	
	ALU_result <=  not_Rtype_result WHEN (NOT (opcode = "000000")) 
				ELSE sll_slr_result WHEN ((opcode = "000000") and (Function_opcode = "000000" or Function_opcode = "000010"))
				ELSE ALU_output_mux;

    PROCESS (ALU_ctl, Ainput, Binput, ALUOp)
    BEGIN
        -- Select ALU operation
        CASE ALU_ctl IS
            WHEN "000" => ALU_output_mux <= Ainput AND Binput;
            WHEN "001" => ALU_output_mux <= Ainput OR Binput;
            WHEN "010" => ALU_output_mux <= std_logic_vector(unsigned(Ainput) + unsigned(Binput)); 
            WHEN "100" => ALU_output_mux <= Ainput XOR Binput;
            WHEN "101" => ALU_output_mux <= sll_slr_result;  
            WHEN "110" => ALU_output_mux <= std_logic_vector(unsigned(Ainput) - unsigned(Binput));
            WHEN "111" =>
                IF (signed(Ainput) < signed(Binput)) THEN
                    ALU_output_mux <= "00000000000000000000000000000001";
                ELSE
                    ALU_output_mux <= "00000000000000000000000000000000";
                END IF;
            WHEN OTHERS => ALU_output_mux <= "00000000000000000000000000000000";
        END CASE;
		
		
		CASE ALUOp IS
            WHEN "0000" => not_Rtype_result <= Ainput xor Binput; --XORI
            WHEN "0001" => not_Rtype_result <= std_logic_vector(unsigned(Ainput) - unsigned(Binput)); --BEQ, BNE
			WHEN "0010" => not_Rtype_result <= Sign_extend(15 DOWNTO 0) & "0000000000000000"; --lui
            WHEN "0011" => not_Rtype_result <= Ainput and Binput;   --ANDI
            WHEN "0100" => not_Rtype_result <= Ainput XOR Binput; --XORI
            WHEN "0101" => not_Rtype_result <= Ainput or Binput;  --ORI
			WHEN "0110" => not_Rtype_result <= std_logic_vector(unsigned(Ainput) + unsigned(Binput)); --ADDI, LW, SW
            WHEN "0111" => not_Rtype_result <= slti_result; --SLTI
			WHEN "1000" => not_Rtype_result <= multiplication_result(31 DOWNTO 0); --MUL
            WHEN OTHERS => not_Rtype_result <= "00000000000000000000000000000000";
        END CASE;
		
	
	
    END PROCESS;
	
END behavior;
