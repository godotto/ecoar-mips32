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

	.eqv	nw 0x776e	# ASCII codes for strings; as register may store two characters,
	.eqv	ne 0x656e	# it is more convenient to compare register's value to ASCII
	.eqv	s_w 0x7773	# codes of two chars combined into string
	.eqv	se 0x6573
	
	.eqv	display, 0x10040000
	
	.text
	.globl	drawLine
	
drawLine:
	subiu	$sp, $sp, 12
	sw	$ra, ($sp)
	
	la	$t0, ($a0)		# instruction array pointer
	la	$t1, currentCoordinates	# current coordinates pointer
	li	$t2, display		# addres of the first pixel of display

	lw	$t3, ($t0)		# direction
	lw	$t4, 4($t0)		# number of steps
	
	lbu	$t5, ($t1)		# x coordinate
	lbu	$t6, 1($t1)		# y coordinate
	
	xor	$t9, $t9, $t9		# store information in which direction draw pixel for diagonal lines
	
	beq	$t3, nw, drawNorthWest
	beq	$t3, ne, drawNorthEast
	beq	$t3, s_w, drawSouthWest
	beq	$t3, se, drawSouthEast
	
	beq	$t3, 'w', drawWest
	beq	$t3, 'e', drawEast
	beq	$t3, 'n', drawNorth
	beq	$t3, 's', drawSouth
	
drawWest:
	beq	$t4, $zero, return
	
	li	$a0, -4
	xor	$a1, $a1, $a1
	jal	drawPixel
	
	bne	$t5, -4, drawWest
	li	$t5, 252		# if left boundary of display has been exceeded go to the right boundary
	b	drawWest
	
drawEast:
	beq	$t4, $zero, return
	
	li	$a0, 4
	xor	$a1, $a1, $a1
	jal	drawPixel
	
	bne	$t5, 256, drawEast
	li	$t5, 0		# if right boundary of display has been exceeded go to the left boundary
	b	drawEast
	
drawNorth:
	beq	$t4, $zero, return
	
	li	$a1, -4
	xor	$a0, $a0, $a0
	jal	drawPixel

	bne	$t6, -4, drawNorth
	li	$t6, 252		# if upper boundary of display has been exceeded go to the lower boundary
	b	drawNorth

drawSouth:
	beq	$t4, $zero, return
	
	li	$a1, 4
	xor	$a0, $a0, $a0
	jal	drawPixel

	bne	$t6, 256, drawSouth
	li	$t6, 0		# if lower boundary of display has been exceeded go to the upper boundary
	b	drawSouth

drawNorthWest:
	beq	$t4, $zero, return
	
	beq	$t9, 1, nwWest	# if 1 go left
	li	$a1, -4
	xor	$a0, $a0, $a0
	li	$t9, 1		# next time line will go left
	b	nwNextStep

nwWest:
	li	$a0, -4
	xor	$a1, $a1, $a1
	xor	$t9, $t9, $t9	# next time line will go upwards

nwNextStep:
	jal	drawPixel
	
	bne	$t6, -4, drawNorthWest
	li	$t6, 252		# if upper boundary of display has been exceeded go to the lower boundary
	bne	$t5, -4, drawNorthWest
	li	$t5, 252		# if left boundary of display has been exceeded go to the right boundary
	b	drawNorthWest

drawNorthEast:
	beq	$t4, $zero, return
	
	beq	$t9, 1, neEast	# if 1 go right
	li	$a1, -4
	xor	$a0, $a0, $a0
	li	$t9, 1		# next time line will go right
	b	neNextStep
	
neEast:
	li	$a0, 4
	xor	$a1, $a1, $a1
	xor	$t9, $t9, $t9	# next time line will go upwards

neNextStep:
	jal	drawPixel
	
	bne	$t6, -4, drawNorthEast
	li	$t6, 252		# if upper boundary of display has been exceeded go to the lower boundary
	bne	$t5, 256, drawNorthEast
	li	$t5, 0			# if right boundary of display has been exceeded go to the left boundary
	b	drawNorthEast

drawSouthWest:
	beq	$t4, $zero, return
	
	beq	$t9, 1, swWest	# if 1 go left
	li	$a1, 4
	xor	$a0, $a0, $a0
	li	$t9, 1		# next time line will go left
	b	swNextStep

swWest:
	li	$a0, -4
	xor	$a1, $a1, $a1
	xor	$t9, $t9, $t9	# next time line will go downwards

swNextStep:
	jal	drawPixel
	
	bne	$t6, 256, drawSouthWest
	li	$t6, 0		# if lower boundary of display has been exceeded go to the upper boundary
	bne	$t5, -4, drawSouthWest
	li	$t5, 252		# if left boundary of display has been exceeded go to the right boundary
	b	drawSouthWest

drawSouthEast:
	beq	$t4, $zero, return
	
	beq	$t9, 1, seEast	# if 1 go right
	li	$a1, 4
	xor	$a0, $a0, $a0
	li	$t9, 1		# next time line will go right
	b	seNextStep
	
seEast:
	li	$a0, 4
	xor	$a1, $a1, $a1
	xor	$t9, $t9, $t9	# next time line will go downwards

seNextStep:
	jal	drawPixel
	
	bne	$t6, 256, drawSouthEast
	li	$t6, 0		# if lower boundary of display has been exceeded go to the upper boundary
	bne	$t5, 256, drawSouthEast
	li	$t5, 0		# if right boundary of display has been exceeded go to the left boundary
	b	drawSouthEast

drawPixel:
	sll	$t7, $t6, 6	# y * display_width
	addu	$t7, $t7, $t5	# x + y * display_width
	addu	$t7, $t7, $t2	# current location on display
	
	lw	$t8, colourValue
	sw	$t8, ($t7)	# colour one pixel
	
	addu	$t5, $t5, $a0	# move 1 pixel
	addu	$t6, $t6, $a1	# as above
	subiu	$t4, $t4, 1	# decrement number of steps
	
	jr	$ra

return:
	sb	$t5, currentCoordinates		# save coordinates
	sb	$t6, currentCoordinates + 1
	lw	$ra, ($sp)
	addiu	$sp, $sp, 12
	
	jr	$ra
