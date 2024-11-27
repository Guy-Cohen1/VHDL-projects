onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb3/clk
add wave -noupdate /tb3/rst
add wave -noupdate /tb3/Y
add wave -noupdate /tb3/X
add wave -noupdate /tb3/p_out
add wave -noupdate /tb3/ALUFN
add wave -noupdate /tb3/ALUout
add wave -noupdate /tb3/Nflag
add wave -noupdate /tb3/Cflag
add wave -noupdate /tb3/Zflag
add wave -noupdate /tb3/Vflag
add wave -noupdate /tb3/ena
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1423152 ps} 0}
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
WaveRestoreZoom {0 ps} {4921403 ps}
