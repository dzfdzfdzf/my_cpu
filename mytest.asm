# test jal and jalr
.text
    ori x29, x0, 12
	ori x8, x0, 0x123
	ori x9, x0, 0x456
	ori x14,x0,0x222
L1:
	add x15,x8,x9
	or x16,x8,x9
	jal x1,L2 
	xor x16,x8,x9
L2:
	sub x15,x15,x8
	sub x15,x15,x9
	jalr x0,x1,0