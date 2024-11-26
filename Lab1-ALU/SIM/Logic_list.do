onerror {resume}
add list /tb1/Y
add list /tb1/X
add list /tb1/ALUFN
add list /tb1/ALUout
add list /tb1/Icache
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
