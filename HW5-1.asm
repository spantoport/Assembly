.data
A:	.word	
.text

main: 
	li   $t0, 0	# int i=0
	li   $t1,40     # limit 40
	addi $t2, $0, 20 #Value 20 
	
	la   $a0,A      #call global var. A
	li   $a1,77	#A=77
	sw   $a1,($a0) #Value 77 into global var. A
		
loop:
	beq  $t0,$t1,end  # i<40
	div  $a0, $t2
	mfhi $s1
	
	addi $a0,$0,0
	add  $a0,$s1,$t0
	add  $t0,$t0,1
	j loop #loop
end:
	addi $v0,$zero, 10
	syscall
	
	
	
