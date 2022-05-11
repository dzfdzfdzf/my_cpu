# test sll sra srl slt sltu srai slti sltiu slli srli 
.text
    ori x29, x0, 12
    ori x7, x0, 0x2
	ori x8, x0, 0x123
	ori x9, x0, -2048
	ori x14,x0,0x222
    slt x12, x9, x8
    sltu x12,x9, x8
    slti x12 ,x9,0x1
    sltiu x12,x9,0x1
    sll x8 ,x8,x7
    sra x10,x9,x7
    srl x11,x9,x7
    slli x10,x8,0x2
    srai x10,x9,0x2
    srli x10,x9,0x2
    
