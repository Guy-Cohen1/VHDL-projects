onerror {resume}
add list -width 22 /our_top_tb/done_FSM
add list /our_top_tb/rst
add list /our_top_tb/ena
add list /our_top_tb/clk
add list /our_top_tb/TBactive
add list /our_top_tb/TBWrEnDataMem
add list /our_top_tb/TBWrEnProgMem
add list /our_top_tb/TBdataInDataMem
add list /our_top_tb/TBdataOutDataMem
add list /our_top_tb/TBdataInProgMem
add list /our_top_tb/TBWrAddrDataMem
add list /our_top_tb/TBWrAddrProgMem
add list /our_top_tb/TBRdAddrDataMem
add list /our_top_tb/donePmemIn
add list /our_top_tb/doneDmemIn
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
