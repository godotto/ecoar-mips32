# Description of used registers
#	$t0 - pointer on command buffer
#	$t1 - accumulator
#	$t2 - 0 constant for comparison
#	$t3 - 9 constant for comparison
#	$t4 - digit counter
#	$t5 - 10's multiples needed for multiplication
#	$t6 - currently processed character
#	$t7 - number converted from ASCII
#	$t8 - buffer for multiplication result
	
	.text
	.globl	convertToNum
	
convertToNum:
	move	$t0, $a0	# load the address of last character in command buffer
	
	xor	$t1, $t1, $t1	# initialize accumulator
	
	xor	$t2, $t2, $t2	# 0 constant
	li	$t3, 9		# 9 constant
	
	li	$t4, 1		# initialize digit counter
	li	$t5, 1		# initialize 10's multiple register

conversionStart:
	lbu	$t6, ($t0)		# currently processed character
	beq	$t6, $zero, noError	# if \0 is being processed return value from accumulator
	bgt	$t4, 3, error		# return error code if number is too high
	
	subiu	$t7, $t6, 48		# convert ASCII to actual numerical value
	
	blt	$t7, $t2, error		# return error code if it is not a valid digit
	bgt	$t7, $t3, error		# same as above
	
	beq	$t4, 1, firstDigit	# do not multiply by 10's multiple if first digit
	mul	$t5, $t5, 10		# increase 10's multiple

firstDigit:
	mul	$t8, $t7, $t5
	addu	$t1, $t1, $t8		# add converted value to the accumulator
	
	subiu	$t0, $t0, 1		# move input string pointer
	addiu	$t4, $t4, 1		# increment digit counter
	b	conversionStart

error:
	li	$v0, -1
	b	return

noError:
	move	$v0, $t1

return:
	jr	$ra
