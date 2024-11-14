## Task 1: (8 points)
##
## Write a function square in RISC-V that takes in an integer n and returns its
## square. If n is not positive, the function returns 0. Save your program as
## task1.s.
##
## Test cases:
## - n = -15;
## - n = 200
## - n = 11
##
	.data
n:	.word -15
	# square(n) => 0
# n:	.word 200
# 	# square(n) => 40000
# n:	.word 11
# 	# square(n) => 121

	.text

main:	la s0 n		# s0 <- &n
	# call square(a0)
	lw a0 0(s0)	# a0 <- n: n goes to arg position
	jal ra square
	# call p_int()
	# no setup needed returned result is in a0 already
	jal ra p_int

exit:
	addi a7, x0, 10		# set up exit call
	ecall			# exit

	# square(a0) is
	#   input:      a0 <- signed 32-bit integer
	#   output:     a0 <- 32-bit unsigned integer
square:
	blt a0 x0 isNeg # go to special handler if a0 < 0
	mul a0 a0 a0	# return a0 * a0
	jr ra		# return to caller
isNeg:  add a0 x0 x0	# return 0 if a0 is negative
	jr ra		# return to caller

	# p_int(a0) is
	#  input:	a0 <- signed 32-bit integer
	#  output:	none
	#  side-effect: prints a0 to stdout as int
p_int:
	add a1 a0 x0	# venus needs arg in a1
	li a0 1		# and print code in a0
	ecall		# exec print
	jr ra
