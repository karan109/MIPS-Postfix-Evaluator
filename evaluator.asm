.globl main
.data
	message: .asciiz "Enter: "
	error_msg: .asciiz "Enter a valid string\n"
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

		# Store stack pointer address
		move $t0, $sp

		# Using $t1 to store top element of stack to save calls to stack.
		# li $t1, 0

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
			li $v0, 1
			lw $a0, 0($sp)
			add $sp, $sp, 4
			bne $sp, $t0, error
			syscall
			li $v0, 11
			la $a0, '\n'
			syscall
			li $v0, 4
			la $a0, exit_msg
			syscall
			li $v0, 10						# load 10 in $v0 for termination
			syscall							# syscall
		
		numeral:
			addi $sp, $sp, -4
			sw $t3, 0($sp)	
			li $v0, 1
			move $a0, $t3
			syscall
			li $v0, 11
			la $a0, '\n'
			syscall
			jal loop

		multiply:
			jal load_values_for_operator
			mul $t1, $t1, $t2
			addi $sp, $sp, -4
			sw $t1, 0($sp)
			li $v0, 4
			la $a0, mult_msg
			syscall
			jal loop

		addition:
			jal load_values_for_operator
			add $t1, $t1, $t2
			addi $sp, $sp, -4
			sw $t1, 0($sp)
			li $v0, 4
			la $a0, add_msg
			syscall
			jal loop

		subtract:
			jal load_values_for_operator
			sub $t1, $t1, $t2
			addi $sp, $sp, -4
			sw $t1, 0($sp)
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

		load_values_for_operator: 
			beq $sp, $t0, error
			lw $t2, 0($sp)
			addi $sp, $sp, 4
			beq $sp, $t0, error
			lw $t1, 0($sp)
			addi $sp, $sp, 4
			jr $ra