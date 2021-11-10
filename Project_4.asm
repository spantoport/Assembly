.macro printStr (%str)
.data
myString: .asciiz %str
.text
   	li $v0, 4
   	la $a0, myString
   	syscall
   	li $a0, '\n'
   	li $v0, 11
   	syscall
.end_macro

.macro getInt(%intReg)
   	li $v0, 5
   	syscall
   	add %intReg, $0, $v0
.end_macro
      
.macro printInt(%str, %int)
   	la $a0, %str
   	li $v0, 4
   	syscall
   	addi $a0, $0, %int
   	li $v0, 1
   	syscall
   	li $a0, '\n'
   	li $v0, 11
   	syscall
.end_macro
  
.macro printInt(%int)
  
   addi $a0, %int
   li $v0, 1
   syscall
   li $a0, '\n'
   li $v0, 11
   syscall
   
.end_macro
  
.macro printDouble(%double)
   	mov.d $f12, %double
   	li $v0, 3
   	syscall
   	li $a0, '\n'
   	li $v0, 11
   	syscall
.end_macro

.macro loadDouble(%int , %double)
	mtc1 %int, %double
	cvt.d.w %double,%double
.end_macro

.macro printInt (%int, %str)
.data
myString: .asciiz %str
   addi $a0, %int
   li $v0, 1
   syscall
   la $a0, myString
   li $v0, 4
   syscall
   li $a0, '\n'
   li $v0, 11
   syscall
   .end_macro
  
  
  
  
  
.macro printInt (%str1, %int, %str2)
.data
myString1: .asciiz %str1
myString2: .asciiz %str2
.text
   la $a0, myString1
   li $v0, 4
   syscall
   add $a0,$0, %int
   li $v0, 1
   syscall
   la $a0, myString2
   li $v0, 4
   syscall
   li $a0, '\n'
   li $v0, 11
   syscall
   .end_macro
  
#*****************************


.macro midpoint (%from, %to, %n, %result)
   addi $sp,$sp,-40   # Adjust stack pointer by 8 because we are dealing with doubles
  
   sdc1 $f20,0($sp)  #pSum
   sdc1 $f24,8($sp)  # h
   sdc1 $f26,16($sp) #sum
   sdc1 $f28,24($sp) #x
   sdc1 $f30,32($sp) #to-h
  
   sub.d $f24, %to, %from
   div.d $f24, $f24, %n        #this is the delta variable in the formula
  
   addi $sp, $sp,-4
   sw $s0, 0($sp)         
  
   li $s0, 0
   loadDouble ($s0, $f26)       #sum = 0.0
   loadDouble ($s0, $f28) 	#x = 0.0
   mov.d $f28, %from 		# x = from
   sub.d $f30, %to, $f24 	# end of the loop (to - h)
   
Loop:  
	c.lt.d $f30, $f28           # (to-h)< x (inverse condition
	bc1t Out
	li $s0, 2
   	loadDouble ($s0, $f20)
	div.d $f20, $f24, $f20      # (h/2)
   	add.d $f20, $f28,$f20       #x+(h/2)
  
  	fx($f20, $f20)
   	add.d $f26, $f20, $f26
   	add.d $f28, $f28, $f24
   	##############################
   	#mov.d $f20, $f20   #<-----------------------here the stack move to 
   	#################
   	li $v0, 3	#
   	syscall		#
   	li $a0, '\n'	#-------------> this part print out the value
   	li $v0, 11
   	syscall	#
   	##########	#
   	
   	
   	j Loop
   	
   	
   	
  
Out:  
  
   	mul.d %result, $f26, $f24
   	lw $s0, 0($sp)
   	addi $sp, $sp,4

   	ldc1 $f20,0($sp)  #pSum
 	ldc1 $f24,8($sp)  # h
  	ldc1 $f26,16($sp) #sum
  	ldc1 $f28,24($sp) #x
   	ldc1 $f30,32($sp) #to-h
   	addi $sp,$sp,40
.end_macro

.macro fx(%din, %dout)        #in represents x in the function, out represents the entire function that is created
   	
 	addi $sp,$sp,-4
 	sw $s0, 0($sp)
   	addi $sp,$sp,-16       # Adjust stack pointer
   	sdc1 $f18,0($sp)       # 8 bytes   this is equal to 5
   	sdc1 $f20,8($sp)       # 8 bytes   this is equal to 21
   	
	mov.d $f24,%dout
   	li $s0, 5
   	loadDouble($s0, $f26)
   	mul.d %dout, %dout, $f26
  
   	li $s0, 21
   	loadDouble($s0, $f26)
   	mul.d %dout, %dout, $f26
   	mul.d $f24, %din, %din	 #$f24 = x^2
    	mul.d $f24, $f24, $f26  # f24= 5x^2
    	mul.d $f24, $f24, $f24	#f24= x^4
    	div.d $f24, $f26, $f24	#21/x^4
	add.d %dout, %dout, $f24
                
	ldc1 $f24, 0($sp)
	ldc1 $f26, 8($sp)
   	
   	addi $sp, $sp, 16
   	lw $s0, 0($sp)
   	addi $sp, $sp, 4
.end_macro  
  
      
main:
  	printStr ("Welcome to Project 4, numerical integration \n")
        printStr ("Please Enter the start of the interval \n")
        getInt($t0)
        printStr ("Please Enter the end of the interval\n")
        getInt($t1)
        printStr ("Please Enter the number of iterations you wish to have\n")
        getInt($t2)
        printInt ("********** Calculating f(x) from ", $t0, " to")
        printInt (" ",$t1, " using the midpoint formula \n")

        #initialize
        addi $sp, $sp, -16
        andi $sp, $sp, 0xFFFFFFF8
        li $t3, 0			#this is clearing the register for the result
        li $t1, 10
        li $t0, 0
        li $t2, 20
        loadDouble ($t0, $f4)
        loadDouble ($t1, $f6)
        loadDouble ($t2, $f8)
        loadDouble ($t3, $f12)

        midpoint($f4,$f6,$f8,$f12)


done:
	li $v0, 10
	syscall
exit:
	li $v0, 10
	syscall
