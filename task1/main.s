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
# n:	.word -15
# 	# square(n) => 0
# n:	.word 200
# 	# square(n) => 40000
n:	.word 11
	# square(n) => 121

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
	mul a0 a0 a0	# return reg gets a0 * a0
	jr ra

	# p_int(a0) is
	#  input:	a0 <- signed 32-bit integer
	#  output:	none
	#  side-effect: prints a0 to stdout as int
p_int:
	# value already in a0, no need to move it for ecall
	li a7 1         #   arg7 <- 1: print int
	ecall           #   exec print
	jr ra
