#		Assembly					Description
#
main:	addi 	$2, $0, 5			# init $2 = 5
		addi 	$3, $0, 12			# init $3 = 12
		addi 	$7, $3, -9			# add 12 + -9 = $7 = 3
		or		$4, $7, $2			# $4 = 3 or 5 = 7
		and		$5, $3, $4			# $5 = 12 and 7 = 4
		add 	$5, $5, $4			# $5 = 4 + 7 = 11
		beq		$5, $7, end 		# 11 - 3 = 8 != 0 -> no branch
		slt		$4, $3, $4			# $4 = 12 < 7 = 0
		beq 	$4, $0, around		# 0 - 0 = 0 -> branch to around
		addi 	$5, $0, 0			# should not be executed

around:
		slt		$4, $7, $2			# $4 = 3 < 5 = 1
		add 	$7, $4, $5			# $7 = 1 + 11 = 12
		sub 	$7, $7, $2			# $7 = 12 - 5 = 7
		sw 		$7, 68($3)			# [80] = 7
		lw		$2, 80($0)			# $2 = [80] = 7
		j		end					# jump to end
		addi	$2, $0, 1 			# should not happen

end:
		sw		$2, 84($0)			# [84] = 7