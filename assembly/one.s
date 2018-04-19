.globl main
.globl parse
.globl loop
.globl end
.globl exit
.globl multiplication
.globl go

.data

.text

#$a1 & $a2 contain factors, $a3 returns product with $a3 starting as 0
multiplication:
	add $a3, $0, $0
cont:	blez $a2, exit
	add $0, $0, $0
	add $a3, $a3, $a1	#add $a1 to $a3 until count runs out
	addi $a2, $a2, -1
	j cont
	add $0, $0, $0

parse:	add $t0, $0, $0		#count for string length
loop:	lb $t1, 0($a0)		#load first byte into $t1


next:	addi $t0, $t0, -2	#t0 holds position of last byte of string
	addi $t2, $0, 1		#set permanent place holder
	add $t3, $0, $0		#holds sum of complete int
	lui $a0, 0x1000
	add $a0, $a0, $t0	#a0 now starts at end of it's string in memory
next2:	bltz $t0, go
	lb $t1, 0($a0)		#load last char of string
	add $0, $0, $0
	addi $t1, $t1, -0x30	#convert to int value
	add $a1, $0, $t1	#$t1 is int rep. by char digit
	add $a2, $0, $t2	#place holder is t2
	jal multiplication	#multiply int by placeholder
	add $0, $0, $0		
	add $t3, $t3, $a3	#add resulting int to running sum
	add $a1, $0, $t2	#$a1 now holds placeholder
	addi $a2, $0, 10	#mult placeholder by 10
	jal multiplication
	add $0, $0, $0
	add $t2, $0, $a3	#set new placeholder
	addi $t0, $t0, -1	#decrement count
	addi $a0, $a0, -1	#move back a char in the string
	j next2			#jump back and do again until string is parsed
	add $0, $0, $0		#***RESULT: at end of this, the value of the int is stored in $t3

	
	j exit
	add $0, $0, $0

exit:	jr $ra
	add $0, $0, $0


main:	add $s0, $0, $0
	add $t7, $0, $0
	lui $a0, 0x1000
	addi $v0, $0, 8
	addi $a1, $0, 32
	syscall




	jal parse
	add $0, $0, $0
go:	add $a0, $0, $t3
	addi $v0, $0, 1
	syscall			#print parsed int to screen

end:	add $0, $0, $0

#read string stored at 0x10000000
#running stored result save in $s0
#$t7 is a pointer to position in string
#
#
#

