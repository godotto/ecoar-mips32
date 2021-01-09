	.data
	
	.align	2
commandBuffer:
	.space	12
	
	.text
	.globl executeCommand
	
executeCommand:
	subiu	$sp, $sp, 12		# allocate stack frame and save $s0, $ra and $fp
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
	
colour:
	la	$s2, commandBuffer	# clear command buffer
	sw	$zero, ($s2)
	sw	$zero, 4($s2)
	sw	$zero, 8($s2)		
	
	addiu	$s0, $s0, 2	# move input string pointer (and skip one space)
	lbu	$s1, ($s0)	# currently processed character
	sb	$s1, ($s2)	# store character in command buffer
	addiu	$s2, $s2, 1	# move command buffer pointer
	
	subiu	$sp, $sp, 12	# allocate space on stack for 3 elements array
	la	$s3, -12($fp)	# rgb[] array pointer
	
colourLoopBeginning:
	beq	$s1, $zero, endColourLoop
	beq	$s1, '\n', coulourConvertFromCommandBuffer
	bne	$s1, ' ', nextColourCharacter

coulourConvertFromCommandBuffer:	
	sb	$zero, -1($s2)
	la	$a0, -2($s2)	# load one parameter from colour command to convertToNum function argument
	jal	convertToNum
	sw	$v0, ($s3)		# save converted value into rgb[]
	addiu	$s3, $s3, 4		# move rgb[] pointer
	
	la	$s2, commandBuffer	# clear command buffer
	sw	$zero, ($s2)
	sw	$zero, 4($s2)
	sw	$zero, 8($s2)
	
nextColourCharacter:
	addiu	$s0, $s0, 1	# move input string pointer
	lbu	$s1, ($s0)	# currently processed character
	sb	$s1, ($s2)	# store the first character in command buffer
	addiu	$s2, $s2, 1	# move command buffer pointer
	
	b	colourLoopBeginning
	
endColourLoop:
	
	
return:	
	addiu	$sp, $sp, 12	# pop array from stack
	
	
	lw	$s0, 8($sp)	# restore saved registers
	lw	$ra, 4($sp)
	lw	$fp, 0($sp)
	addiu	$sp, $sp, 12
	jr	$ra		# return
