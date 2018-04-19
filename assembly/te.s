.globl main
.globl done
.data
.text
main:
	addi $v0, $0, 5
	syscall
	add $t7, $0, $v0
	add $t6, $0, $t7
	addi $t6, $t6, -1
	add $t5, $0, $t7
	add $t4, $0, $t7
	addi $t4, $t4, -1
	add $t3, $0, $t4
check:	beq $t6, $0, end
	add $0, $0, $0
go:	beq $t4, $0, exp2
	add $0, $0, $0
	add $t5, $t5, $t7
	addi $t4, $t4, -1
	j go
	add $0, $0, $0
exp2:	addi $t6, $t6, -1
	add $t7, $0, $t5
	add $t4, $0, $t3
	j check
	add $0, $0, $0
end:	addi $v0, $0, 1
	add $a0, $0, $t5
	syscall
done:	add $0, $0, $0
	
