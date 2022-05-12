# Test File for 8 Instruction, include:
# ADD/SUB/OR/AND/LW/SW/ORI/BEQ
################################################################
### Make sure following Settings :
# Settings -> Memory Configuration -> Compact, Data at address 0

.text
	 ori x29, x0, 12
	 ori x8, x0, 0x123
	 lui x9 , 0x77458
	 ori x14,x0,0x222
	# andi x10,x8,0x111
	# addi x11,x9,0x113
	 add x7, x8, x9
	# sub x6, x7, x9
	# xor x6,x7,x6
    # or  x10, x8, x9
    # and x11, x9, x10
	# xori x15,x14,0x789
	sw x8, 0(x0)
	sw x9, 4(x0)
	sh x7, 1(x29)
	sb x7, 8(x0)
	lbu x5, 5(x0)
	# beq x8, x5, _lb2
	# _lb1:
	# lw x9, 4(x29)
	# _lb2:
	# lw x5, 4(x0)
	# beq x9, x5, _lb1
	
	# Never return
	
