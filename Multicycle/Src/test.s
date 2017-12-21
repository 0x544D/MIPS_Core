#		Assembly					Address			Hex				Description
#
main:	addi 	$2, $0, 5			#0x0100			20020005		# init $2 = 5
		addi 	$3, $0, 12			#0x0104			2003000c		# init $3 = 12
		addi 	$7, $3, -9			#0x0108			2067fff7		# add 12 + -9 = $7 = 3
		or		$4, $7, $2			#0x010c			00e22025		# $4 = 3 or 5 = 7
		and		$5, $3, $4			#0x0110			00642824		# $5 = 12 and 7 = 4
		add 	$5, $5, $4			#0x0114			00a42820		# $5 = 4 + 7 = 11
		beq		$5, $7, end 		#0x0118			10a7000a		# 11 - 3 = 8 != 0 -> no branch
		slt		$4, $3, $4			#0x011c			0064202a		# $4 = 12 < 7 = 0
		beq 	$4, $0, around		#0x0120			10800001		# 0 - 0 = 0 -> branch to around
		addi 	$5, $0, 0			#0x0124			20050000		# should not be executed

around:								
		slt		$4, $7, $2			#0x0128			00e2202a		# $4 = 3 < 5 = 1
		add 	$7, $4, $5			#0x012c			00853820		# $7 = 1 + 11 = 12
		sub 	$7, $7, $2			#0x0130			00e23822		# $7 = 12 - 5 = 7
		sw 		$7, 68($3)			#0x0134			ac670044		# [80] = 7
		lw		$2, 80($0)			#0x0138			8c020050		# $2 = [80] = 7
		j		end					#0x013c			08000051		# jump to end
		addi	$2, $0, 1 			#0x0140			20020001		# should not happen

end:
		sw		$2, 84($0)			#0x0144			ac020054		# [84] = 7