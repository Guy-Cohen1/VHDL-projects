onerror {resume}
add list /tb2/Y
add list /tb2/X
add list /tb2/ALUFN
add list /tb2/ALUout
add list /tb2/cout
add list /tb2/Icache
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
