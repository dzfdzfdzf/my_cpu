.text
    ori x7, x0, 0x2
	ori x8, x0, 0x2
    ori x9, x0, 0x3
    bltu x8, x9, L1
    add x2, x8, x9
L1: sub x2, x8, x9
    
