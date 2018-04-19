.globl main
.globl division
.globl multiplication
.data
.text

division:
	sub	$a1, $a1, $a2
	bltz	$a1,(destination TBD)
	add	$0, $0, $0
	addi	$v1, $v1, 1
	beq	$0, $0, division
	add	$0, $0, $0
	jr	$ra
	add	$0, $0, $0

# $a1 = multiplicand , $a2 = multiplier, $a3 = product
multiplication:
	blez	$a2,(destination TBD)
	addi	$a2, $a2, -1
	add	$a3, $a1, $a3
	beq	$0, $0, multiplication
	add	$0, $0, $0

# $a1 = minuend , $a2 = subtrahend , $a3 = difference		
subtraction:
	sub 	$a3, $a1, $a2
	beq	$0, $0, (destination TBD)
	add 	$0, $0, $0

# $a1 = augend , $a2 = addend , $a3 = sum
addition:
	add	$a3, $a1, $a2
	beq	$0, $0, (destination TBD)
	add 	$0, $0, $0

#need to check if power = 0 before running through
# $a1 = base , a3 = result, $s0 = power
exponent:
	beq	$0, $s0, (destination TBD)
	add	$0, $0, $0
	add	$a2, $a2, $a1
	addi	$s0, $s0, -1
loop:	
	
	
	
main:
	
