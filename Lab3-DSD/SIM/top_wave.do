onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /our_top_tb/done_FSM
add wave -noupdate /our_top_tb/rst
add wave -noupdate /our_top_tb/ena
add wave -noupdate /our_top_tb/clk
add wave -noupdate /our_top_tb/TBactive
add wave -noupdate /our_top_tb/TBWrEnDataMem
add wave -noupdate /our_top_tb/TBWrEnProgMem
add wave -noupdate /our_top_tb/TBdataInDataMem
add wave -noupdate /our_top_tb/TBdataOutDataMem
add wave -noupdate /our_top_tb/TBdataInProgMem
add wave -noupdate /our_top_tb/TBWrAddrDataMem
add wave -noupdate /our_top_tb/TBWrAddrProgMem
add wave -noupdate /our_top_tb/TBRdAddrDataMem
add wave -noupdate /our_top_tb/donePmemIn
add wave -noupdate /our_top_tb/doneDmemIn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {8400 ns}
