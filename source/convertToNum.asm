# Description of used registers
#	$t0 - pointer on command buffer
#	$t1 - accumulator
#	$t2 - 0 constant for comparison
#	$t3 - 9 constant for comparison
#	$t4 - 10 constant for multiplication
#	$t5 - currently processed character and then converted digit
#	$t6 - buffer for multiplication result
	
	.text
	.globl	convertToNum
	
convertToNum:
	move	$t0, $a0	# load the address of last character in command buffer
	
	xor	$t1, $t1, $t1	# initialize accumulator
	
	xor	$t2, $t2, $t2	# 0 constant
	li	$t3, 9		# 9 constant
	li	$t4, 10		# 10 constant

conversionStart:
	lbu	$t5, ($t0)		# currently processed character
	beq	$t5, $zero, noError	# if \0 is being processed return value from accumulator
	
	subiu	$t5, $t5, '0'		# convert ASCII to actual numerical value
	
	blt	$t5, $t2, error		# return error code if it is not a valid digit
	bgt	$t5, $t3, error		# same as above
	
	mul	$t1, $t1, $t4		# multiply accumulated value by 10 to shift number to the left
	addu	$t1, $t1, $t5		# add converted value to the accumulator
	
	addiu	$t0, $t0, 1		# move input string pointer
	b	conversionStart

error:
	li	$v0, -1
	b	return

noError:
	move	$v0, $t1

return:
	jr	$ra
