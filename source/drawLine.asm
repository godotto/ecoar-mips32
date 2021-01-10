	.text
	.globl	drawLine
	
drawLine:
	la	$t0, ($a0)		# instruction array pointer
	la	$t1, currentCoordinates	# current coordinates pointer
	la	$t2, display		# addres of the first pixel of display
	
	lw	$t3, ($t0)		# direction
	lw	$t4, 4($t0)		# number of steps
	
	lbu	$t5, ($t1)		# x coordinate
	lbu	$t6, 1($t1)		# y coordinate
	
	beq	$t3, 'W', drawWest
	beq	$t3, 'w', drawWest
	beq	$t3, 'E', drawEast
	beq	$t3, 'e', drawEast
	beq	$t3, 'N', drawNorth
	beq	$t3, 'n', drawNorth
	beq	$t3, 'S', drawSouth
	beq	$t3, 's', drawSouth
	
drawWest:
	beq	$t4, $zero, return
	
	mul	$t7, $t6, 64	# y * display_width
	addu	$t7, $t7, $t5	# x + y * display_width
	mul	$t7, $t7, 4	# 4 * (x + y * display_width)
	addu	$t7, $t7, $t2	# current location on display
	
	lw	$t8, colourValue
	sw	$t8, ($t7)	# colour one pixel
	
	subiu	$t5, $t5, 1	# go 1 pixel left
	subiu	$t4, $t4, 1	# decrement number of steps
	
	bne	$t5, -1, drawWest
	li	$t5, 63		# if left boundary of display has been exceeded go to the right boundary
	b	drawWest
	
drawEast:
	beq	$t4, $zero, return
	
	mul	$t7, $t6, 64	# y * display_width
	addu	$t7, $t7, $t5	# x + y * display_width
	mul	$t7, $t7, 4	# 4 * (x + y * display_width)
	addu	$t7, $t7, $t2	# current location on display
	
	lw	$t8, colourValue
	sw	$t8, ($t7)	# colour one pixel
	
	addiu	$t5, $t5, 1	# go 1 pixel right
	subiu	$t4, $t4, 1	# decrement number of steps
	
	bne	$t5, 64, drawEast
	li	$t5, 0		# if right boundary of display has been exceeded go to the left boundary
	b	drawEast
	
drawNorth:
	
	beq	$t4, $zero, return
	
	mul	$t7, $t6, 64	# y * display_width
	addu	$t7, $t7, $t5	# x + y * display_width
	mul	$t7, $t7, 4	# 4 * (x + y * display_width)
	addu	$t7, $t7, $t2	# current location on display
	
	lw	$t8, colourValue
	sw	$t8, ($t7)	# colour one pixel
	
	subiu	$t6, $t6, 1	# go 1 pixel upwards
	subiu	$t4, $t4, 1	# decrement number of steps
	
	bne	$t6, -1, drawNorth
	li	$t6, 63		# if upper boundary of display has been exceeded go to the lower boundary
	b	drawNorth
	
drawSouth:
	beq	$t4, $zero, return
	
	mul	$t7, $t6, 64	# y * display_width
	addu	$t7, $t7, $t5	# x + y * display_width
	mul	$t7, $t7, 4	# 4 * (x + y * display_width)
	addu	$t7, $t7, $t2	# current location on display
	
	lw	$t8, colourValue
	sw	$t8, ($t7)	# colour one pixel
	
	addiu	$t6, $t6, 1	# go 1 pixel downwards
	subiu	$t4, $t4, 1	# decrement number of steps
	
	bne	$t6, 64, drawSouth
	li	$t6, 0		# if lower boundary of display has been exceeded go to the upper boundary
	b	drawSouth
	subiu	$t4, $t4, 1	# decrement number of steps
	
	bne	$t6, -1, drawSouth
	li	$t6, 0		# if right boundary of display has been exceeded go to the left boundary
	
return:
	sb	$t5, currentCoordinates
	sb	$t6, currentCoordinates + 1
	
	jr	$ra
