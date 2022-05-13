# Test File for 42 Instruction, include:
# 1. Subset 1:
# ADD/SUB/SLL/SRL/SRA/SLT/SLTU/AND/OR/XOR/ 
#SLLI/SRLI/SRAI/ 						13				
# 2. Subset 2:
# ADDI/ANDI/ORI/XORI/LUI/SLTI/SLTIU/AUIPC			8
# 3. Subset 3:
# LB/LBU/LH/LHU/LW/SB/SH/SW 		                                8
# 4. Subset 4:
# BEQ/BNE/BGE/BGEU/BLT/BLTU				6
# 5. Subset 5:
# JAL/JALR						2
#							37
##################################################################
### Make sure following Settings :
# Settings -> Memory Configuration -> Compact, Data at address 0


	##################
	# Test Subset 2  #
	ori x20, x0, 0x18F
                lui x21, 0x3FB95
                or x20,x20,x21                       
	lui x21, 0x98765                     
	addi x21, x21, 0x345
	addi x22, x20, -1024             
	xori x23, x20, 0x7bc
	sltiu x22, x20, 0x34
	sltiu x23, x20, -1
	andi x22, x20, 0x765
	slti x23, x20, -1
	
	
	##################
	# Test Subset 1  #
	sub x22, x21, x20               #x19=0x98763DCC
	xor x23, x20, x22               #x21=0x98765001
	add x22, x21, x20
	add x22, x22, x3
	sub x22, x22, x20                  #x23=0x00001236
	or  x23, x23, x22                 #x25=0x98767236
	and x23, x23, x22               #x26=0x00000236
	slt x22,  x20  x21                 #x27=1
	sltu x23, x20, x21               #x28=0
	
	### Test for shift
                addi x3, x3, 4   # pay attention to register shift
	sll x22, x20, x3
	srl x22, x21, x3
	sra x22, x21, x3
	slli  x23, x21, 16
	srli x23, x21, 8
	srai x23, x21, 8
	
	
	##################
	# Test Subset 3  #
	addi x3, x0, 0
                addi x5,x0, 0xF5
	
	
	### Test for store
	sw x20, 0(x3)
	sw x21, 4(x3)
	sw x23, 8(x3)
	sh x22, 4(x3)
	sh x20, 10(x3)
	sb x5, 7(x3)
	sb x5, 9(x3)
	sb x5, 8(x3)
	
	### Test for load
                lw  x22, 0(x3)           #x5=0x98763DCC
	sw x22, 12(x3)
	lh x23, 8(x3)             #x7=0xFFFF9876
	sw x23, 16(x3)
	lhu x23, 8(x3)           #x7=0x00009876
	sw x20, 20(x3)
	lb x22, 7(x3)              #x8=0xFFFFFF98
	sw x21, 24(x3)
	lbu x23, 7(x3)            #x8=0x00000098
	sw x23, 28(x3)
	lbu x23, 24(x3)            #x8=0x0000003D
	sw x23, 32(x3)

	
	##################
	# Test Subset 4  #
	sw x0, 4(x3)
	and x9, x0, x9
	bne x20, x21,  _lb1
	addi x9, x9, 1

              _lb1:
	bge x20, x21, _lb2
	addi x9, x9, 1

	_lb2:
	bgeu x20, x21, _lb3
	addi x9, x9, 2

	_lb3:
	blt x20, x21, _lb4
	addi x9, x9, 3

	_lb4:
	bltu x20, x21, _lb5
	addi x9, x9, 4

	_lb5:
                lw x25, 24(x3)
	beq x21, x25, _lb6
	addi x9, x9, 5

	_lb6:
	sw x9, 4(x3)        #x9=5

	
	##################
	# Test Subset 5  #
	lw x10, 4(x3)
	jal x1, F_Test_JAL
	addi x10, x10, 8
	sw x10, 4(x3)

F_Test_JAL:
	ori x10, x10, 0x45C
	sw x10, 4(x3)
	jalr x0, x1, 0


