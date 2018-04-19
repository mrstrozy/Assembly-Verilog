.globl main
.globl multip
.globl exit
.globl end
.data
.text

#$a0 & $a1 contain factors
multip:	add $a3, $0, $0
con:	blez $a1, exit
	add $0, $0, $0
	add $a3, $a3, $a0
	addi $a1, $a1, -1
	j con
	add $0, $0, $0

exit:
	jr $ra
	add $0, $0, $0
main:
	addi $v0, $0, 5
	syscall
	add $a0, $0, $v0
	add $a1, $0, $a0
	jal multip
	add $0, $0, $0
	add $a0, $0, $a3
	addi $v0, $0, 1
	syscall
end:	add $0, $0, $0	
