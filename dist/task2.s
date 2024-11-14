## Task 2: (8 points)
##
## Write a function sumSquare in RISC-V that, when given an integer n, returns
## the summation of all squared odd numbers smaller than or equal to n. If the
## input, n, is not positive, the function returns 0. That is:
##
##	𝑠𝑢𝑚𝑆𝑞𝑢𝑎𝑟𝑒(𝑛) = 𝑛^2 + (𝑛 − 2)^2 + … + 1^2, 𝑤ℎ𝑒𝑛 𝑛 𝑖𝑠 𝑎𝑛 𝑜𝑑𝑑 𝑛𝑢𝑚𝑏𝑒𝑟
## 	𝑠𝑢𝑚𝑆𝑞𝑢𝑎𝑟𝑒(𝑛) = (𝑛 − 1)^2 + (𝑛 − 3)^2 + … + 1^2, 𝑤ℎ𝑒𝑛 𝑛 𝑖𝑠 𝑎𝑛 𝑒𝑣𝑒𝑛 𝑛𝑢𝑚𝑏𝑒𝑟.
##
## To code for this problem, you should implement sumSquare by calling the
## function of square from task1 as a subroutine. The program must be compiled
## by Venus. To print your results, please call ecall.
##
## Test cases:
## - n = 28;
## - n = -190
## - n = 17
##
	.data
# n:	.word 4
# 	# sumSquare(n) => 10
# n:	.word 5
# 	# sumSquare(n) => 35
# n:	.word 7
# 	# sumSquare(n) => 84
# n:	.word 28
#	# sumSquare(n) => 3654
# n:	.word -190
# 	# sumSquare(n) => 0
n:	.word 17
	# sumSquare(n) => 969

	.text

main:	la s0 n		# s0 <- &n
	# call square(a0)
	lw a0 0(s0)	# a0 <- n: n goes to arg position
	jal ra sumSquare
	# call p_int()
	# no setup needed returned result is in a0 already
	jal ra p_int

exit:
	addi a7, x0, 10		# set up exit call
	ecall			# exit

	# sumSquare(a0) is
	#  input:	a0 <- signed 32-bit integer
	#  output:	a0 <- 32-bit unsigned integer
	#
	#  returns sum{ a^2 | ∀ a ∈ (0,a0]: a % 2 == 1 }
sumSquare:
	# setup
	addi sp sp -8	# grow stack
	sw s0 4(sp)
	sw ra 0(sp)

	# body
	add s0 a0 x0	# save a0 to s0
	jal ra isEven	# decrement if even
	bne a0 x0 loop
	addi s0 s0 -1
loop:	# count down by 2 from s0 to 1, squaring on every odd
	bge x0 s0 qloop	# term loop if a0 == 0
	mul t0 s0 s0
	add t1 t1 t0
	addi s0 s0 -2
	j loop
qloop:  # continue below...

	# teardown
	# place res in a0
	add a0 t1 x0
	lw ra 0(sp)
	lw s0 4(sp)
	addi sp sp 8	# grow stack
	jr ra

	# isEven(a0) is
	#  input:	a0 <- signed 32-bit integer
	#  output:	a0 <- signed 32-bit integer
	#
	# returns 0 if a0 is even, 1 if it is odd
isEven:
	# a0 is even if least-significant bit is 0
	li t0 1		# create bitmask of 00...01
	and a0 a0 t0	# use bitmask w/ and to isolate 0th bit
	jr ra

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
	ecall           #   exec print
	jr ra
