onerror {resume}
add list -width 11 /tb200/st
add list /tb200/ld
add list /tb200/mov
add list /tb200/done_DM
add list /tb200/add
add list /tb200/sub
add list /tb200/jmp
add list /tb200/jc
add list /tb200/jnc
add list /tb200/O_R
add list /tb200/X0R
add list /tb200/A_ND
add list /tb200/clk
add list /tb200/rst
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
