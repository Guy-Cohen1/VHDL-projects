onerror {resume}
add list /tb3/Y
add list /tb3/X
add list /tb3/ALUFN
add list /tb3/ALUout
add list /tb3/Nflag
add list /tb3/Cflag
add list /tb3/Zflag
add list /tb3/Vflag
add list /tb3/Icache
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
