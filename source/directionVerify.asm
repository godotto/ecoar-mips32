# Description of used registers
#	$t0 - pointer on command buffer
#	$t1 - the first character from command buffer
#	$t2 - the second character from command buffer

	.text
	.globl	directionVerify

directionVerify:
	move	$t0, $a0	# load addres of command buffer
	lbu	$t1, ($t0)	# store the first character from command buffer
	lbu	$t2, 1($t0)	# store the second character from command buffer
	lh	$v0, ($t0)	# store command buffer's content into return value, it will be altered only in case of wrong input

	bge	$t1, 'a', lowerCase	# if upper case then convert to lower case, else do nothing and jump
	addiu	$t1, $t1, 32

lowerCase:
	beq	$t1, 'n', firstCorrectNorthSouth
	beq	$t1, 'w', firstCorrectWestEast
	beq	$t1, 'e', firstCorrectWestEast
	beq	$t1, 's', firstCorrectNorthSouth

error:
	li	$v0, -1	# error return code
	b	return

firstCorrectNorthSouth:
	beq	$t2, $zero, return		# only north/south

	bge	$t2, 'a', lowerCaseSecondLetter	# if upper case then convert to lower case, else do nothing and jump
	addiu	$t2, $t2, 32

lowerCaseSecondLetter:
	beq	$t2, 'w', return	# north-west/south-west
	beq	$t2, 'e', return	# north-east/south-east

	b	error

firstCorrectWestEast:
	bne	$t2, $zero, error	# only west/east

return:
	beq	$v0, -1, returnError
	sb	$t1, ($t0)
	sb	$t2, 1($t0)
	lh	$v0, ($t0)

returnError:	
	jr	$ra	#return
