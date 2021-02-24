.globl main
.data
	message: .asciiz "Enter: "
	error_msg: .asciiz "Enter a valid string"
	mult_msg: .asciiz "Multiplication detected\n"
	add_msg: .asciiz "Addition detected\n"
	sub_msg: .asciiz "Subtraction detected\n"
	exit_msg: .asciiz "OK Bye\n"
	userInput: .space 20 # Max length of string user can input
.text
	main:
		li $v0, 4
		la $a0, message
		syscall

		# Take string input
		li $v0, 8
		la $a0, userInput
		li $a1, 20
		syscall

		# Load input into s1
		la $s1 userInput
		loop:

			# Point to head of s1
			lb $t3, ($s1)

			# Newline detected, exit
			beq $t3, 10, exit

			# Update pointer to point to next char
			addi $s1, $s1, 1

			# *
			beq $t3, 42, multiply

			# +
			beq $t3, 43, addition

			# -
			beq $t3, 45, subtract

			# No digit detected
			blt $t3, 48, error
			bgt $t3, 57, error

			# Get the digit as integer
			addi $t3, $t3, -48
			jal numeral

		exit:
			li $v0, 4
			la $a0, exit_msg
			syscall

			li $v0, 10						# load 10 in $v0 for termination
			syscall							# syscall
		numeral:
			li $v0, 1
			move $a0, $t3
			syscall
			li $v0, 11
			la $a0, '\n'
			syscall
			jal loop
		multiply:
			li $v0, 4
			la $a0, mult_msg
			syscall
			jal loop
		addition:
			li $v0, 4
			la $a0, add_msg
			syscall
			jal loop
		subtract:
			li $v0, 4
			la $a0, sub_msg
			syscall
			jal loop
		error:
			li $v0, 4
			la $a0, error_msg
			syscall
			li $v0, 10						# load 10 in $v0 for termination
			syscall							# syscall