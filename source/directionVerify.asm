	.text
	.globl	directionVerify
	
directionVerify:
	move	$t0, $a0	# load addres of command buffer
	lbu	$t1, ($t0)	# store the first character from command buffer
	lbu	$t2, 1($t0)	# store the second character from command buffer
	lh	$v0, ($t0)	# store command buffer's content into return value, it will be altered only in case of wrong input
	
	beq	$t1, 'N', firstCorrectNorthSouth
	beq	$t1, 'W', firstCorrectWestEast
	beq	$t1, 'E', firstCorrectWestEast
	beq	$t1, 'S', firstCorrectNorthSouth
	beq	$t1, 'n', firstCorrectNorthSouth
	beq	$t1, 'w', firstCorrectWestEast
	beq	$t1, 'e', firstCorrectWestEast
	beq	$t1, 's', firstCorrectNorthSouth
	
	b	error
	
firstCorrectNorthSouth:
	beq	$t2, $zero, return	# only north/south
	beq	$t2, 'W', return	# north-west/south-west
	beq	$t2, 'w', return	# north-west/south-west
	beq	$t2, 'E', return	# north-east/south-east
	beq	$t2, 'e', return	# north-east/south-east
	
	b	error
	
firstCorrectWestEast:
	beq	$t2, $zero, return	# only west/east

error:
	li	$v0, -1	# error return code
	
return:
	jr	$ra	#return