onerror {resume}
add list /tb/Y
add list /tb/X
add list /tb/ALUFN
add list /tb/ALUout
add list /tb/cout
add list /tb/Icache
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
