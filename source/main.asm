	.data
	
usageInfo:
	.asciiz	"Usage instruction:\n\t<direction> <steps> to draw\n\tC <red> <green> <blue> to change colour\n\tq to end program\n"
prompt:
	.asciiz "Command: "
errorInfo:
	.asciiz "Unknown command\n"
maxSize:
	.byte	63
	.align	1
inputString:
	.space	50
colour:
	.byte	0x0, 0x0, 0x0


	.text
	.globl main, prompt, maxSize, errorInfo, inputString
	
main:
	li	$v0, 4			# print string syscall
	la	$a0, usageInfo
	syscall
	
loopBeginning:
	jal	readString
	jal	executeCommand
	bne	$s0, 1, loopBeginning	# if exit variable is true terminate program
	
	li	$v0, 10			# terminate execution syscall
	syscall
