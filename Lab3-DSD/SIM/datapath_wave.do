onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb200/clk
add wave -noupdate /tb200/rst
add wave -noupdate /tb200/ld
add wave -noupdate /tb200/mov
add wave -noupdate /tb200/A_ND
add wave -noupdate /tb200/sub
add wave -noupdate /tb200/jc
add wave -noupdate /tb200/add
add wave -noupdate /tb200/st
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {122132 ps} 0}
quietly wave cursor active 1
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
