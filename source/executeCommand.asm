	.text
	.globl executeCommand
	
executeCommand:
	subiu	$sp, $sp, 12	# allocate stack frame and save $s0, $ra and $fp
	sw	$s0, 8($sp)
	sw	$ra, 4($sp)
	sw	$fp, 0($sp)
	addiu	$fp, $sp, 8
	
	
return:				# restore saved registers
	lw	$s0, 8($sp)
	lw	$ra, 4($sp)
	lw	$fp, 0($sp)
	addiu	$sp, $sp, 12
	jr	$ra		# return
