.data  
	arr1: 	.word 	1,2,3,4,5,6,7,8
	arr2: 	.word 	8,7,6,5,4,3,2,1
	res1:	.space 	32 			# 8*4=32
	res2:	.space 	32 			# 8*4=32
	size:	.word 	8
.text

	move	$s0,$0
	lw	$s1,size
Loop:	lw 	$t0,arr1($s0)
	lw 	$t1,arr2($s0)
	add 	$t2,$t1,$t0
	sub 	$t3,$t1,$t0
	sw 	$t2,res1($s0)
	sw 	$t3,res2($s0)
	addi	$s0,$s0,4
	addi	$s1,$s1,-1
	slt	$s2,$0,$s1
	bne 	$s2,$0,Loop	
	
END:	beq $0,$0,END	
