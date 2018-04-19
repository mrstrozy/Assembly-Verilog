##*****************************************************************
##
##File: project-1.s written by Matthew Strozyk.
##
##Notes: I couldn't get it all to work together but I wrote the 
##	subroutines that should all work when tested. Also you
##	will see a parser that I planned on parsing all of the
##	string digits into ints. From there I tried to rewrite it
##	into a separate memory location. Then I tried to go layer
##	by layer, looking for different signs as to follow the 
##	order of operations. Thanks
##
##
##
##*****************************************************************
.globl main
.globl end
.data
.text

#$a1 & $a2 = factors, $a3 = result
multiplication:
	add $a3, $0, $0		#set result = 0 to start
loop:	beq $0, $a2, exit	#if done multiplying, exit
	add $0, $0, $0
	add $a3, $a3, $a1	#add factor to result
	j loop
	addi $a2, $a2, -1	#decrement factor counter
exit:	jr $ra
	add $0, $0, $0

#used for division and modulus where remainder is modulus value
#$a1 = dividend, $a2 = divisor, AFTER: $v1 = result, $a1 = remainder
division:
	sub $a1, $a1, $a2
	bltz $a1, end
	add $0, $0, $0
	addi $v1, $v1, 1
	beq $0, $0, division
	add $0, $0, $0
	jr $ra
	add $0, $0, $0

#$a1 & $a2 = numbers to be added , $a3 = sum
#can be used for subtraction as well
addition:
	add $a3, $a1, $a2
	jr $ra




#$t3 has to be set to read string location
parse:	
	lui $t3, 0x1000
	lui $t2, 0x1000
	addi $s7, $0, 1		#set not found digit to true
	addi $t2, $t2, 2000	#parsed location
fresh:	add $t7, $0, $0		#holds distance since farthest seen digit
pbeg:	lb $t0, 0($t3)		#load first byte of string into $t0
	add $0, $0, $0
	beq $0, $t0, pstore	#check if new line char
	add $t1, $0, $t0	#duplicate value into $t1
	addi $t1, $t1, -0x30	#check to see if it's an integer
	bltz $t1, store		#if it is not within the digit range, 
	addi $t1, $t1, -0x10	#then copy it over
	bltz $t1, store
	add $0, $0, $0		#confirmed it's a digit
	addi $t7, $t7 1		#increment distance
	j pinc	

pstore: add $s7, $0, $0
store:	beq $0, $t7, pst	#if no digits before sign
	add $0, $0, $0		#if here then $t7 > 0 means there are digits to convert
	jal convert
	add $0, $0, $0
scon:	sw $t5, 0($t2)
	add $0, $0, $0
	addi $t2, $t2, 4
pst:	sw $t0, 0($t2)
	add $0, $0, $0
	addi $t2, $t2, 4
	beq $0, $s7, pexit	#if endline char reached, exit
	add $0, $0, $0
	j fresh
	add $0, $0, $0
	

pinc:	addi $t3, $t3, 1	#increment memory location
	j pbeg
	add $0, $0, $0

pexit:	beq $0, $0, pmain
	add $0, $0, $0

#$t4 at sign location, $t5 = output buffer , $t7 > 0, $t5 = sum
convert:
	add $t5, $0, $0
	addi $t6, $0, 1		#placeholder value
	add $t4, $0, $t3	#copy pointer to curr location in string
dec:	addi $t4, $t4, -1	#cover first offset
	lb $a1, 0($t4)		#load digit into $a1
	addi $a1, $a1, -0x30	#convert to int 
	add $a2, $0, $t6	#put placeholder value into $a2
	jal multiplication	#multiply by placeholder
	add $0, $0, $0
	addi $t7, $t7, -1	#decrement offset
	add $t5, $t5, $a3	#update number
	addi $a1, $0, 10	#multiply by 10
	add $a2, $0, $t6
	jal multiplication	#multiply placeholder by 10
	add $0, $0, $0
	add $t6, $0, $a3
	j dec
	add $0, $0, $0	
	

#calculate exponential values	
#$t7 holds base, $t6 holds power, $t5 holds result
exp:
	addi $t6, $t6, -1	#start at power - 1
	add $t5, $0, $t7	#result starts at base
	add $t4, $0, $t7	
	addi $t4, $t4, -1	#mult by itself
	add $t3, $0, $t4	#hold value of mult
check:	beq $t6, $0, main	#if power = 0 then Branch
	add $0, $0, $0
go:	beq $t4, $0, exp2	#if mult is over, go to exp2
	add $0, $0, $0
	add $t5, $t5, $t7	#add $t7 to running sum
	add $t4, $t4, -1
	j go
	add $0, $0, $0
exp2:	addi $t6, $t6, -1	
	add $t7, $0, $t5	
	add $t4, $0, $t3	
	j check
	add $0, $0, $0
	
	
	
main:
	lui $a0, 0x1000		#memory address of stored string
	addi $a1, $0, 32	#32 bits allowed
	addi $v0, $0, 8		#read in string
	syscall			#get string
	jal parse		#all digits are in int form
	add $0, $0, $0
pmain:	j test
	add $0, $0, $0
#	jal combine



test:	lui $a1, 0x1000
	addi $a1, $a1, 2000
	addi $t5, $0, 5
yes:	beq $t5, $0, end
	lw $t0, 0($a1)
	add $0, $0, $0
	add $a0, $0, $t0
	addi $v0, $0, 1
	syscall
	addi $a1, $a1, 4
	addi $t5, $t5, -1
	j yes
	add $0, $0, $0

end:	add $0, $0, $0
