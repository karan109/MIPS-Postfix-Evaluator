.globl main
.data
	input_msg: .asciiz "Enter: "
	error_msg: .asciiz "Invalid postfix string\n"
	ans_msg  : .asciiz "Answer: "
	userInput: .space 1005 # Max length of string user can input
.text
	main:
		# Display inputs message
		li $v0, 4
		la $a0, input_msg
		syscall

		# Take string input
		li $v0, 8
		la $a0, userInput
		li $a1, 1005
		syscall

		# Load input string address into s1
		la $s1 userInput

		# Using $t1 to store top element of stack to save calls to stack.
		li $t1, 0

		# Store initial stack pointer address for checking empty condition
		# 1 extra space used for storing initial value of 0 during first iteration of loop
		addi $t0, $sp, -4


		# Loop over each character of the string
		loop:
			# Point to head of s1
			lb $t3, ($s1)

			
			# Newline or Null detected => exit
			beq $t3, 10, exit
			beq $t3, 0, exit

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
			# If stack not empty at end or input string was empty then error
			bne $sp, $t0, error 

			# Print answer message
			li $v0, 4
			la $a0, ans_msg
			syscall

			# Print answer
			li $v0, 1
			move $a0, $t1
			syscall
			
			# Print newline
			li $v0, 11
			la $a0, '\n'
			syscall

			# Reset stack pointer
			addi $sp, $t0, 4 

			# Terminate execution
			li $v0, 10
			syscall
		
		numeral:
			# Add current top element stored in $t1 to the stack
			addi $sp, $sp, -4
			sw $t1, 0($sp)
			
			# Transfer current input to $t1
			move $t1, $t3

			# jump back to loop to read the next character
			jal loop

		multiply:
			# Top value present in $t1 and load next in $t2 and apply operator
			jal load_values_for_operator
			mul $t1, $t2, $t1

			# jump back to loop to read the next character
			jal loop

		addition:
			# Top value present in $t1 and load next in $t2 and apply operator
			jal load_values_for_operator
			add $t1, $t2, $t1
			
			# jump back to loop to read the next character
			jal loop

		subtract:
			# Top value present in $t1 and load next in $t2 and apply operator
			jal load_values_for_operator
			sub $t1, $t2, $t1
			
			# jump back to loop to read the next character
			jal loop
		
		load_values_for_operator: 
			# If stack pointer at base then stack is empty
			# This implies an error due to excess of operators
			beq $sp, $t0, error
			# Load stack top most value in $t2
			lw $t2, 0($sp)
			addi $sp, $sp, 4
			jr $ra

		error:
			# Print error message
			li $v0, 4
			la $a0, error_msg
			syscall
			
			# Reset stack pointer
			addi $sp, $t0, 4 

			# Terminate Execution
			li $v0, 10
			syscall
			