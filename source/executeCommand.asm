	.data
	
	.align	2
	
commandBuffer:
	.space	12
	
	.text
	.globl executeCommand
	
executeCommand:
	subiu	$sp, $sp, 24		# allocate stack frame and save $s0-$s3, $ra and $fp
	sw	$s3, 20($sp)
	sw	$s2, 16($sp)
	sw	$s1, 12($sp)
	sw	$s0, 8($sp)
	sw	$ra, 4($sp)
	sw	$fp, 0($sp)
	move	$fp, $sp 
	
	la	$s0, inputString	# pointer on input string
	lbu	$s1, ($s0)		# currently processed character
	
	la	$s2, commandBuffer	# pointer on command buffer which stores single processed argument
	sb	$s1, ($s2)		# store the first character in command buffer
	addiu	$s2, $s2, 1		# move command buffer pointer
	
	beq	$s1, 'C', colour	# if 'C' then process changing colour command
	
	beq	$s1, 'q', quit		# if 'q' then terminate the program
	
	beq	$s1, 'N', draw		# if 'N' then process drawing command
	beq	$s1, 'W', draw		# if 'W' then process drawing command
	beq	$s1, 'S', draw		# if 'S' then process drawing command
	beq	$s1, 'E', draw		# if 'E' then process drawing command
	beq	$s1, 'n', draw		# if 'n' then process drawing command
	beq	$s1, 'w', draw		# if 'w' then process drawing command
	beq	$s1, 's', draw		# if 's' then process drawing command
	beq	$s1, 'e', draw		# if 'e' then process drawing command
	
colour:
	la	$s2, commandBuffer	# clear command buffer
	sw	$zero, ($s2)
	sw	$zero, 4($s2)
	sw	$zero, 8($s2)		
	
	addiu	$s0, $s0, 2		# move input string pointer (and skip one space)
	lbu	$s1, ($s0)		# currently processed character
	sb	$s1, ($s2)		# store character in command buffer
	addiu	$s2, $s2, 1		# move command buffer pointer
	
	subiu	$sp, $sp, 12		# allocate space on stack for 3 elements rgb[] array which stores each base colour value
	la	$s3, -12($fp)		# rgb[] array pointer
	
colourLoopBeginning:
	beq	$s1, $zero, endColourLoop			# if it is the end of input finish loop
	beq	$s1, '\n', saveColourIntoArray			# after last character of input there is always new line character, so it's necessary to cover that case
	bne	$s1, ' ', nextColourCharacter			 

saveColourIntoArray:	
	sb	$zero, -1($s2)			# remove space or new line character on the end of command buffer
	la	$a0, -2($s2)			# load one parameter from colour command to convertToNum function argument
	jal	convertToNum
	beq	$v0, -1, endColourLoop		# if number is incorrect stop processing
	bge	$v0, 255, endColourLoop		# if number exceeds 255 stop processing
	sw	$v0, ($s3)			# save converted value into rgb[]
	addiu	$s3, $s3, 4			# move rgb[] pointer
	
	la	$s2, commandBuffer		# clear command buffer
	sw	$zero, ($s2)
	sw	$zero, 4($s2)
	sw	$zero, 8($s2)
	
nextColourCharacter:
	addiu	$s0, $s0, 1	# move input string pointer
	lbu	$s1, ($s0)	# currently processed character
	sb	$s1, ($s2)	# store character in command buffer
	addiu	$s2, $s2, 1	# move command buffer pointer
	
	b	colourLoopBeginning
	
endColourLoop:
	addiu	$sp, $sp, 12	# pop array from stack
	beq	$v0, -1, error
	
	xor 	$v0, $v0, $v0	# non-termination signal for main
	
	lb	$t0, -12($fp)	# update RGB values
	sb	$t0, colourValue
	
	lb	$t0, -8($fp)
	sb	$t0, colourValue + 1
	
	lb	$t0, -4($fp)
	sb	$t0, colourValue + 2
	
	b	return
	
draw:
	subiu	$sp, $sp, 8	# allocate 2-elements array drawInstructions[] to store instructions for another function
	la	$s3, -8($fp)	# pointer on drawInstructions[]
	
	addiu	$s0, $s0, 1	# move input string pointer
	lbu	$s1, ($s0)	# currently processed character
	sb	$s1, ($s2)	# store character in command buffer
	addiu	$s2, $s2, 1	# move command buffer pointer
	
	xor	$s4, $s4, $s4	# variable telling if direction has been processed or not
	
drawLoopBeginning:
	beq	$s1, $zero, endDrawLoop			# if it is the end of input finish loop
	beq	$s1, '\n', saveInstructionsIntoArray	# after last character of input there is always new line character, so it's necessary to cover that case
	bne	$s1, ' ', nextDrawCharacter
	
saveInstructionsIntoArray:
	sb	$zero, -1($s2)		# remove space or new line character on the end of command buffer
	beq	$s4, 1, saveSteps
	
	la	$a0, commandBuffer		# load argument for directionVerify function
	jal	directionVerify
	beq	$v0, -1, endDrawLoop		# if direction is incorrect stop processing
	sw	$v0, ($s3)			# save verified input into drawInstructions[]
	addiu	$s3, $s3, 4			# move drawInstructions[] pointer
	addiu	$s4, $s4, 1			# mark that direction has been processed
	b	clearCommandBuffer
	
saveSteps:
	la	$a0, -2($s2)			# load one parameter from colour command to convertToNum function argument
	jal	convertToNum
	beq	$v0, -1, endDrawLoop		# if number is incorrect stop processing
	beq	$v0, 64, endDrawLoop		# if number exceeds size of picture stop processing
	sw	$v0, ($s3)			# save converted value into drawInstructions[]
	addiu	$s3, $s3, 4			# move drawInstructions[] pointer
	
clearCommandBuffer:
	la	$s2, commandBuffer	# clear command buffer
	sw	$zero, ($s2)
	sw	$zero, 4($s2)
	
nextDrawCharacter:
	addiu	$s0, $s0, 1	# move input string pointer
	lbu	$s1, ($s0)	# currently processed character
	sb	$s1, ($s2)	# store character in command buffer
	addiu	$s2, $s2, 1	# move command buffer pointer
	
	b	drawLoopBeginning
	
endDrawLoop:
	addiu	$sp, $sp, 8	# pop array from stack
	beq	$v0, -1, error
	
	b	return
error:
	li	$v0, 4		# print string syscall
	la	$a0, errorInfo
	syscall
	b	return
	
quit:
	li	$v0, 1		# program termination signal for main
	
return:				# restore saved registers
	lw	$s3, 20($sp) 
	lw	$s2, 16($sp)
	lw	$s1, 12($sp)
	lw	$s0, 8($sp)	
	lw	$ra, 4($sp)
	lw	$fp, 0($sp)
	addiu	$sp, $sp, 12
	jr	$ra		# return
