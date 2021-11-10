.data
question5:	.asciiz	"Provide a Value for n : "
result:		.asciiz "The result is"
.text

main:
	li	$v0, 4	#system call print string
	la	$a0, question5	#print out
	syscall
	
	li	$v0, 5	#Input
	syscall
	
	move	$a0, $v0
	
	jal recfun	#jump to "recfun" function
	
	li	$v0, 4
	la	$a0, result	
	syscall
	
	
	li	$v0, 3
	syscall

end:
	li	$v0, 10
	syscall

recfun:
	addi	$sp, $sp, -8	#update stack pointer; 8bytes
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	
	li	$t0, 2 # <-----
	bge  	$a0, $t0, recall # branch if greater than equal 2 
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	addi	$sp, $sp, 8	#return back 8 byte
	li	$t1, 5
	mtc1	$t1, $f12	#set $f12(floating point register)to value in $t1(int register)
	cvt.d.w	$f12, $f12	#format conversion
	jr $ra
	
recall:
	addi	$a0, $a0, -1	#(n-1)
	jal	recfun
	
	lw	$ra, 0($sp)	#restore $ra,can use$ra
	lw	$a0, 4($sp)	#restore $$a0, can use $a0
	addi	$sp, $sp, 8	#return back 8 byte
	
	li	$t1, 4		#t1=4
	mtc1	$t1, $f4	#note that desination is "second"reg. change format
	cvt.d.w $f4, $f4	#set $f4 double precision equivalent of integer value in $f4
	
	li	$t2, 1
	mtc1	$t2, $f14
	cvt.d.w $f14, $f14
	mtc1	$a0, $f6	# a0=n; n is $f6
	cvt.d.w $f6, $f6	
	
	#div.d	$f8, $f4, $f6
	#mul.d	$f10, $f6, $f6
	#mul.d	$f16, $f10, $f6
	#mul.d	$f14, $f14, $f16
	
	#add.d	$f8, $f8, $f16
	#add.d	$f12, $f12, $f8
	
	div.d $f4, $f4, $f6	# $f4=f4 / f6  ;   f4= 4 / n
	mul.d $f8, $f6, $f6	# f8 = f6 * f6 ;   f8 = n * n
	mul.d $f10, $f8, $f6	# f10 = f8 * f6 ;	f10 = (n*n)*n
	
	add.d $f4, $f4, $f10	# f4 = f4 + f10 ;	f4= (4/n) + (n*n*n)
	mul.d $f12, $f12, $f4	#f12 = f12 * f4 ; 	f12 = (4/n) + (n*n*n) * recfun(n-1)
	
	jr $ra			# back to loop
