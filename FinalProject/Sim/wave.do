onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group MCU /mcu_tb/U_0/HEX0
add wave -noupdate -expand -group MCU /mcu_tb/U_0/HEX1
add wave -noupdate -expand -group MCU /mcu_tb/U_0/HEX2
add wave -noupdate -expand -group MCU /mcu_tb/U_0/HEX3
add wave -noupdate -expand -group MCU /mcu_tb/U_0/HEX4
add wave -noupdate -expand -group MCU /mcu_tb/U_0/HEX5
add wave -noupdate -expand -group MCU /mcu_tb/U_0/LEDR
add wave -noupdate -expand -group MCU /mcu_tb/U_0/Switches
add wave -noupdate -expand -group MCU /mcu_tb/U_0/BTOUT
add wave -noupdate -expand -group MCU /mcu_tb/U_0/KEY1
add wave -noupdate -expand -group FETCH /mcu_tb/U_0/CPU/IFE/PC_plus_4_out
add wave -noupdate -expand -group FETCH /mcu_tb/U_0/CPU/IFE/Add_result
add wave -noupdate -expand -group FETCH /mcu_tb/U_0/CPU/IFE/jump_address
add wave -noupdate -expand -group FETCH /mcu_tb/U_0/CPU/IFE/Ainput
add wave -noupdate -expand -group FETCH /mcu_tb/U_0/CPU/IFE/Branch
add wave -noupdate -expand -group FETCH /mcu_tb/U_0/CPU/IFE/Zero
add wave -noupdate -expand -group FETCH /mcu_tb/U_0/CPU/IFE/jump
add wave -noupdate -expand -group FETCH /mcu_tb/U_0/CPU/IFE/clock
add wave -noupdate -expand -group FETCH /mcu_tb/U_0/CPU/IFE/reset
add wave -noupdate -expand -group FETCH /mcu_tb/U_0/CPU/IFE/ISRAddr
add wave -noupdate -expand -group FETCH /mcu_tb/U_0/CPU/IFE/PC
add wave -noupdate -expand -group FETCH /mcu_tb/U_0/CPU/IFE/PC_plus_4
add wave -noupdate -expand -group FETCH /mcu_tb/U_0/CPU/IFE/Next_PC
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/read_data_1
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/databus
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/AddressBus
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/read_data_2
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/jump_address
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/Instruction
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/Opcode
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/read_data
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/ALU_result
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/PC_PLUS_4
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/PC_PLUS_4_jr
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/PC
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/RegWrite
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/MemtoReg
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/RegDst
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/Sign_extend
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/GIE
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/Read_ISR_PC
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/EPC
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/INTR
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/INTR_Active
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/CLR_IRQ
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/jump
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/clock
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/reset
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/IFG
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/IntrEn
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/register_array
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/write_register_address
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/write_data
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/read_register_1_address
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/read_register_2_address
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/write_register_address_1
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/write_register_address_0
add wave -noupdate -group DECODE /mcu_tb/U_0/CPU/ID/Instruction_immediate_value
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/opcode
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/Read_data_1
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/Read_data_2
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/Sign_extend
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/Function_opcode
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/ALUOp
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/ALUSrc
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/Zero
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/ALU_result
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/Add_Result
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/PC_plus_4
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/clock
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/reset
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/Ainput
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/Binput
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/ALU_output_mux
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/not_Rtype_result
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/multiplication_result
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/sll_slr_result
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/slti_result
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/Branch_Add
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/ALU_ctl
add wave -noupdate -group EXECUTE /mcu_tb/U_0/CPU/EXE/amount_of_shifts
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/MemWidth
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/SIM
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/read_data
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/is_ra
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/address
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/write_data
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/MemRead
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/Memwrite
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/clock
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/reset
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/index_11
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/write_clock
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/write_enable
add wave -noupdate -group MEM /mcu_tb/U_0/CPU/MEM/dMemAddr
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/CtrlBusSize
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/AddrBusSize
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/DataBusSize
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/INTA
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/MemReadBus
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/clock
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/reset
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/MemWriteBus
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/AddressBus
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/DataBus
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/HEX0
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/HEX1
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/HEX2
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/HEX3
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/HEX4
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/HEX5
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/LEDR
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/Switches
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/CS_LEDR
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/CS_SW
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/CS_HEX0
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/CS_HEX1
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/CS_HEX2
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/CS_HEX3
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/CS_HEX4
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/CS_HEX5
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/ChipSelect
add wave -noupdate -group GPIO /mcu_tb/U_0/IO_interface/OADAddr
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/clk
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/Addr
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/DIVRead
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/reset
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/ena
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/dividend
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/divisor
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/quotient_OUT
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/remainder_OUT
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/DIVIFG
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/state_reg
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/state_next
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/z_reg
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/z_next
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/divisor_reg
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/divisor_next
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/i_reg
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/i_next
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/quotient
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/remainder
add wave -noupdate -expand -group DIV /mcu_tb/U_0/div_acc/sub
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/DataBusSize
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/Addr
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTRead
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTWrite
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/MCLK
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/reset
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTCTL
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTCCR0
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTCCR1
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTCNT_io
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/IRQ_OUT
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTIFG
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTOUT
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/CLK
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/DIV
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTCNT
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTCL0
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTCL1
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/PWM
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTOUTEN
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTHOLD
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTSSEL
add wave -noupdate -group BT /mcu_tb/U_0/Basic_Timer/BTIPx
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/DataBusSize
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/AddrBusSize
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/IrqSize
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/RegSize
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/reset
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/clock
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/MemReadBus
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/MemWriteBus
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/AddressBus
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/DataBus
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/IntrSrc
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/ChipSelect
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/INTR
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/INTA
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/IRQ_OUT
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/INTR_Active
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/CLR_IRQ_OUT
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/GIE
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/IFG
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/IntrEn
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/IRQ
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/CLR_IRQ
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/TypeReg
add wave -noupdate -group {INT CON} /mcu_tb/U_0/Intr_Controller/INTA_Delayed
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10203629 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 263
configure wave -valuecolwidth 233
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {10500 ns}
