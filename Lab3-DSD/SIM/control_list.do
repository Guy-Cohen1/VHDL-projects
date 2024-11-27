onerror {resume}
add list -width 16 /tbcontrol/clk
add list /tbcontrol/rst
add list /tbcontrol/ena
add list /tbcontrol/st
add list /tbcontrol/ld
add list /tbcontrol/mov
add list /tbcontrol/done_in
add list /tbcontrol/add
add list /tbcontrol/sub
add list /tbcontrol/jmp
add list /tbcontrol/jc
add list /tbcontrol/jnc
add list /tbcontrol/Cflag
add list /tbcontrol/Zflag
add list /tbcontrol/Nflag
add list /tbcontrol/IRin
add list /tbcontrol/Imm1_in
add list /tbcontrol/Imm2_in
add list /tbcontrol/RFin
add list /tbcontrol/RFout
add list /tbcontrol/PCin
add list /tbcontrol/Ain
add list /tbcontrol/Cin
add list /tbcontrol/Cout
add list /tbcontrol/Mem_wr
add list /tbcontrol/Mem_out
add list /tbcontrol/Mem_in
add list /tbcontrol/a_nd
add list /tbcontrol/o_r
add list /tbcontrol/x0r
add list /tbcontrol/OPC
add list /tbcontrol/PCsel
add list /tbcontrol/RFaddr
add list /tbcontrol/done_out
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
