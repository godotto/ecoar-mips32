	.text
	.globl readString
	
readString:
	li	$v0, 4		# print string syscall
	la	$a0, prompt
	syscall
	
	li	$v0, 8		# read string syscall
	la	$a0, inputString
	li	$a1, 50
	syscall
	
	jr	$ra		# return
