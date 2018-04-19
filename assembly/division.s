#***************************************
#	Program: division.s
#	--->Programmed for CSE-341 Project 1
#	Programmer: Matthew Strozyk
#	Date: 9/19/14
#***************************************



.globl main
.globl done
.globl division 
.globl end
.data
dividend:	.asciiz	"Please enter the dividend:"  #26 
divisor:	.asciiz	"Please enter the divisor:"   #51
quotient:	.asciiz	"The quotient is: "           #68
remainder:	.asciiz " with a remainder of "       #90
gap:		.asciiz	"\n"
.text

division:
	sub	$a1, $a1, $a2
	bltz	$a1, end
	add	$0, $0, $0
	addi	$v1, $v1, 1
	beq	$0, $0, division 
	add	$0, $0, $0
	jr $ra
	add	$0, $0, $0
main:
start:
	addi	$v0, $0, 4		#Function Call
	lui	$a0, 0x1000		#Location of dividend prompt
	syscall
	addi	$v0, $0, 5		
	syscall			#Read in the integer and store in $v0
	add	$a1, $0, $v0	#a1 now holds the dividend
	addi	$v0, $0, 4
	lui	$a0, 0x1000
	addi	$a0, $a0, 27
	syscall
	addi	$v0, $0, 5	#Read in integer for divisor
	syscall
	add	$a2, $0, $v0	#a2 holds the divisor
	add	$v1, $0, $0
	jal division
	add	$0, $0, $0

##loop:	sub	$a1, $a1, $a2	#subtract divisor from dividend
##	bltz	$a1, end	#remainder is less than 0, GOTO: end
##	add	$0, $0, $0	#nop
##	addi	$v1, $v1, 1	#increment count by 1
##	beq	$0, $0, loop
##	add	$0, $0, $0	#nop

end:	add	$a1, $a1, $a2	#add divisor to negative remainder to get actual remainder
	lui	$a0, 0x1000
	addi	$v0, $0, 4	#print string code
	addi	$a0, $a0, 53
	syscall			#print quotient statement
	addi	$v0, $0, 1
	add	$a0, $0, $v1
	syscall			#print the integer of the quotient
	addi	$v0, $0, 4	#print string code
	lui	$a0, 0x1000
	addi	$a0, $a0, 71
	syscall			#print the remainder line
	addi	$v0, $0, 1
	add	$a0, $0, $a1	#put remainder into $a0
	syscall
	lui	$a0, 0x1000
	addi	$a0, $a0, 93	#put new line string into $a0
	addi	$v0, $0, 4
	syscall			#display new line
	add	$a0, $0, $0	#Make sure all registers are clear
	add	$v0, $0, $0	#''
	add	$v1, $0, $0	#''
	add	$a1, $0, $0	#''
	add	$a2, $0, $0	#''
	beq	$0, $0, start	#continuous loop
	add	$0, $0, $0	#nop
	
done:	add $0, $0, $0
	

