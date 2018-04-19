.globl main
.globl done
.globl sum

.data
prompt:	 .asciiz	"Enter a number:"
result:  .asciiz	"The sum is: "

.text
sum:	add $v1, $a1, $a2
	jr $ra
	add $0, $0, $0
main:	addi $v0, $0, 4
	lui $a0, 0x1000
	syscall
	addi $v0, $0, 5
	syscall
	add $a1, $0, $v0
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5
	syscall
	jal sum
	add $a2, $0, $v0
	addi $v0, $0, 4
	lui $a0, 0x1000
	addi $a0, $a0, 16
	syscall
	addi $v0, $0, 1
	add $a0, $0, $v1
	syscall
done:	add $0, $0, $0
