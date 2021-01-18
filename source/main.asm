# Description of used registers:
#	$s0 - information if program should be terminated or not

	.data

usageInfo:
	.asciiz	"Usage instruction:\n\t<direction> <steps> to draw (display 64x64 px, maximal amount of steps for input is 64)\n\tC <red> <green> <blue> to change colour\n\tq to end program\n"

prompt:
	.asciiz "Command: "
	
errorInfo:
	.asciiz "Wrong command\n"
	.align	1
	.align 	0
	
inputString:
	.space	50
	
colourValue:
	.byte	0, 0, 0
	.align	2
	
currentCoordinates:
	.byte	124, 124
	.align	2

	.text
	.globl main, prompt, errorInfo, inputString, colourValue, currentCoordinates
	
main:
	li	$v0, 4			# print string syscall
	la	$a0, usageInfo
	syscall
	
loopBeginning:
	jal	readString
	jal	executeCommand
	
	move	$s0, $v1
	bne	$s0, 1, loopBeginning	# if exit variable is true terminate program
	
	li	$v0, 10			# terminate execution syscall
	syscall
