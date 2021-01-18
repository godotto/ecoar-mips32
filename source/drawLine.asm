# Description of used registers:
#	$t0 - pointer on instruction array
#	$t1 - pointer on currentCoordinates global variable
#	$t2 - pointer on display's address
#	$t3 - direction
#	$t4 - number of steps
#	$t5 - x coordinate
#	$t6 - y coordinate
#	$t7 - current location on display
#	$t8 - value of coloured from colourValue global variable
#	$t9 - information in which direction draw pixel for diagonal lines
	
	.eqv	NW 0x574e	# ASCII codes for strings; as register may store two characters,
	.eqv	Nw 0x774e	# it is more convenient to compare register's value to ASCII
	.eqv	nW 0x576e	# codes of two chars combined into string
	.eqv	nw 0x776e
	
	.eqv	NE 0x454e
	.eqv	Ne 0x654e
	.eqv	nE 0x456e
	.eqv	ne 0x656e
	
	.eqv	S_W 0x5753	# underscore character is needed as sw is MIPS32 store word instruction
	.eqv	S_w 0x7753
	.eqv	s_W 0x5773
	.eqv	s_w 0x7773
	
	.eqv	SE 0x4553
	.eqv	Se 0x6553
	.eqv	sE 0x4573
	.eqv	se 0x6573
	
	.eqv	display, 0x10040000
	
	.text
	.globl	drawLine
	
drawLine:
	la	$t0, ($a0)		# instruction array pointer
	la	$t1, currentCoordinates	# current coordinates pointer
	li	$t2, display		# addres of the first pixel of display
	
	lw	$t3, ($t0)		# direction
	lw	$t4, 4($t0)		# number of steps
	
	lbu	$t5, ($t1)		# x coordinate
	lbu	$t6, 1($t1)		# y coordinate
	
	xor	$t9, $t9, $t9		# store information in which direction draw pixel for diagonal lines
	
	beq	$t3, NW, drawNorthWest
	beq	$t3, Nw, drawNorthWest
	beq	$t3, nW, drawNorthWest
	beq	$t3, nw, drawNorthWest
	
	beq	$t3, NE, drawNorthEast
	beq	$t3, Ne, drawNorthEast
	beq	$t3, nE, drawNorthEast
	beq	$t3, ne, drawNorthEast
	
	beq	$t3, S_W, drawSouthWest
	beq	$t3, S_w, drawSouthWest
	beq	$t3, s_W, drawSouthWest
	beq	$t3, s_w, drawSouthWest
	
	beq	$t3, SE, drawSouthEast
	beq	$t3, Se, drawSouthEast
	beq	$t3, sE, drawSouthEast
	beq	$t3, se, drawSouthEast
	
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
	addu	$t7, $t7, $t2	# current location on display
	
	lw	$t8, colourValue
	sw	$t8, ($t7)	# colour one pixel
	
	subiu	$t5, $t5, 4	# go 1 pixel left
	subiu	$t4, $t4, 1	# decrement number of steps
	
	bne	$t5, -4, drawWest
	li	$t5, 252		# if left boundary of display has been exceeded go to the right boundary
	b	drawWest
	
drawEast:
	beq	$t4, $zero, return
	
	mul	$t7, $t6, 64	# y * display_width
	addu	$t7, $t7, $t5	# x + y * display_width
	addu	$t7, $t7, $t2	# current location on display
	
	lw	$t8, colourValue
	sw	$t8, ($t7)	# colour one pixel
	
	addiu	$t5, $t5, 4	# go 1 pixel right
	subiu	$t4, $t4, 1	# decrement number of steps
	
	bne	$t5, 256, drawEast
	li	$t5, 0		# if right boundary of display has been exceeded go to the left boundary
	b	drawEast
	
drawNorth:
	
	beq	$t4, $zero, return
	
	mul	$t7, $t6, 64	# y * display_width
	addu	$t7, $t7, $t5	# x + y * display_width
	addu	$t7, $t7, $t2	# current location on display
	
	lw	$t8, colourValue
	sw	$t8, ($t7)	# colour one pixel
	
	subiu	$t6, $t6, 4	# go 1 pixel upwards
	subiu	$t4, $t4, 1	# decrement number of steps
	
	bne	$t6, -4, drawNorth
	li	$t6, 252		# if upper boundary of display has been exceeded go to the lower boundary
	b	drawNorth
	
drawSouth:
	beq	$t4, $zero, return
	
	mul	$t7, $t6, 64	# y * display_width
	addu	$t7, $t7, $t5	# x + y * display_width
	addu	$t7, $t7, $t2	# current location on display
	
	lw	$t8, colourValue
	sw	$t8, ($t7)	# colour one pixel
	
	addiu	$t6, $t6, 4	# go 1 pixel downwards
	subiu	$t4, $t4, 1	# decrement number of steps
	
	bne	$t6, 256, drawSouth
	li	$t6, 0		# if lower boundary of display has been exceeded go to the upper boundary
	b	drawSouth
	
drawNorthWest:
	beq	$t4, $zero, return
	
	mul	$t7, $t6, 64	# y * display_width
	addu	$t7, $t7, $t5	# x + y * display_width
	addu	$t7, $t7, $t2	# current location on display
	
	lw	$t8, colourValue
	sw	$t8, ($t7)	# colour one pixel
	
	beq	$t9, 1, nwWest	# if 1 go left
	subiu	$t6, $t6, 4	# go 1 pixel upwards
	li	$t9, 1		# next time line will go left
	b	nwNextStep
	
nwWest:
	subiu	$t5, $t5, 4	# go 1 pixel left
	xor	$t9, $t9, $t9	# next time line will go upwards

nwNextStep:
	subiu	$t4, $t4, 1	# decrement number of steps
	
	bne	$t6, -4, drawNorthWest
	li	$t6, 252		# if upper boundary of display has been exceeded go to the lower boundary
	bne	$t5, -4, drawNorthWest
	li	$t5, 252		# if left boundary of display has been exceeded go to the right boundary
	b	drawNorthWest
	
drawNorthEast:
	beq	$t4, $zero, return
	
	mul	$t7, $t6, 64	# y * display_width
	addu	$t7, $t7, $t5	# x + y * display_width
	addu	$t7, $t7, $t2	# current location on display
	
	lw	$t8, colourValue
	sw	$t8, ($t7)	# colour one pixel
	
	beq	$t9, 1, neEast	# if 1 go right
	subiu	$t6, $t6, 4	# go 1 pixel upwards
	li	$t9, 1		# next time line will go right
	b	neNextStep
	
neEast:
	addiu	$t5, $t5, 4	# go 1 pixel left
	xor	$t9, $t9, $t9	# next time line will go upwards

neNextStep:
	subiu	$t4, $t4, 1	# decrement number of steps
	
	bne	$t6, -4, drawNorthEast
	li	$t6, 252		# if upper boundary of display has been exceeded go to the lower boundary
	bne	$t5, 256, drawNorthEast
	li	$t5, 0		# if right boundary of display has been exceeded go to the left boundary
	b	drawNorthEast
	
drawSouthWest:
	beq	$t4, $zero, return
	
	mul	$t7, $t6, 64	# y * display_width
	addu	$t7, $t7, $t5	# x + y * display_width
	addu	$t7, $t7, $t2	# current location on display
	
	lw	$t8, colourValue
	sw	$t8, ($t7)	# colour one pixel
	
	beq	$t9, 1, swWest	# if 1 go left
	addiu	$t6, $t6, 4	# go 1 pixel downwards
	li	$t9, 1		# next time line will go left
	b	swNextStep
	
swWest:
	subiu	$t5, $t5, 4	# go 1 pixel south
	xor	$t9, $t9, $t9	# next time line will go downwards

swNextStep:
	subiu	$t4, $t4, 1	# decrement number of steps
	
	bne	$t6, 256, drawSouthWest
	li	$t6, 0		# if lower boundary of display has been exceeded go to the upper boundary
	bne	$t5, -4, drawSouthWest
	li	$t5, 252		# if left boundary of display has been exceeded go to the right boundary
	b	drawSouthWest
	
drawSouthEast:
	beq	$t4, $zero, return
	
	mul	$t7, $t6, 64	# y * display_width
	addu	$t7, $t7, $t5	# x + y * display_width
	addu	$t7, $t7, $t2	# current location on display
	
	lw	$t8, colourValue
	sw	$t8, ($t7)	# colour one pixel
	
	beq	$t9, 1, seEast	# if 1 go right
	addiu	$t6, $t6, 4	# go 1 pixel downwards
	li	$t9, 1		# next time line will go right
	b	seNextStep
	
seEast:
	addiu	$t5, $t5, 4	# go 1 pixel right
	xor	$t9, $t9, $t9	# next time line will go downwards

seNextStep:
	subiu	$t4, $t4, 1	# decrement number of steps
	
	bne	$t6, 256, drawSouthEast
	li	$t6, 0		# if lower boundary of display has been exceeded go to the upper boundary
	bne	$t5, 256, drawSouthEast
	li	$t5, 0		# if right boundary of display has been exceeded go to the left boundary
	b	drawSouthEast
	
return:
	sb	$t5, currentCoordinates		# save coordinates
	sb	$t6, currentCoordinates + 1
	
	jr	$ra
