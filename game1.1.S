start:
lui x2 0xD0000 #x2=0xD0000000
lui x6 0xF0000 #x6=0xF0000000
ori x3 x3 0x0F
slli x3 x3 8 
ori x3 x3 0x0FF #x3=0xfff
addi x4 x0 0
addi x5 x0 16
lui x9 0xD0000#左上角位置
lui x30 0x0F
srai x31 x30 4
add x30 x30 x31
addi x30 x30 0xFF
init:
sw x3 0(x2)
sw x3 1(x2)
sw x3 2(x2)
sw x3 3(x2)
sw x3 4(x2)
sw x3 5(x2)
sw x3 6(x2)
sw x3 7(x2)
sw x3 8(x2)
sw x3 9(x2)
sw x3 10(x2)
sw x3 11(x2)
sw x3 12(x2)
sw x3 13(x2)
sw x3 14(x2)
sw x3 15(x2)
addi x2 x2 0b10000000000
addi x4 x4 1
blt x4 x5 init
addi x10 x0 1#上
addi x11 x0 2#下
addi x12 x0 4#左
addi x13 x0 8#右
addi x14 x0 16#终止
addi x15 x0 32#重启
loop:
lw x7 0(x6)
andi x7 x7 x30#取低16位SW的数值
beq  x7 x0 loop
beq x7 x15 start
beq x7 x10 up
beq x7 x11 down
beq x7 x12 left
beq x7 x13 right
beq x7 x14 stop
up:
addi x9 x9 -1024
sw x3 0(x9)
sw x3 1(x9)
sw x3 2(x9)
sw x3 3(x9)
sw x3 4(x9)
sw x3 5(x9)
sw x3 6(x9)
sw x3 7(x9)
sw x3 8(x9)
sw x3 9(x9)
sw x3 10(x9)
sw x3 11(x9)
sw x3 12(x9)
sw x3 13(x9)
sw x3 14(x9)
sw x3 15(x9)
addi x16 x9 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
sw x0 0 (x16)
sw x0 1 (x16)
sw x0 2 (x16)
sw x0 3 (x16)
sw x0 4 (x16)
sw x0 5 (x16)
sw x0 6 (x16)
sw x0 7 (x16)
sw x0 8 (x16)
sw x0 9 (x16)
sw x0 10(x16)
sw x0 11(x16)
sw x0 12(x16)
sw x0 13(x16)
sw x0 14(x16)
sw x0 15(x16)
jal x0 loop
down:
sw x0 0(x9)
sw x0 1(x9)
sw x0 2(x9)
sw x0 3(x9)
sw x0 4(x9)
sw x0 5(x9)
sw x0 6(x9)
sw x0 7(x9)
sw x0 8(x9)
sw x0 9(x9)
sw x0 10(x9)
sw x0 11(x9)
sw x0 12(x9)
sw x0 13(x9)
sw x0 14(x9)
sw x0 15(x9)
addi x9 x9 1024 
addi x16 x9 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
addi x16 x16 1024
sw x3 0 (x16)
sw x3 1 (x16)
sw x3 2 (x16)
sw x3 3 (x16)
sw x3 4 (x16)
sw x3 5 (x16)
sw x3 6 (x16)
sw x3 7 (x16)
sw x3 8 (x16)
sw x3 9 (x16)
sw x3 10(x16)
sw x3 11(x16)
sw x3 12(x16)
sw x3 13(x16)
sw x3 14(x16)
sw x3 15(x16)
jal x0 loop
left:
addi x9 x9 -1
sw x3 0   (x9)
sw x3 1024(x9)
addi x16 x9 1024
sw x3 1024(x16)
addi x16 x16 1024
sw x3 1024(x16)
addi x16 x16 1024
sw x3 1024(x16)
addi x16 x16 1024
sw x3 1024(x16)
addi x16 x16 1024
sw x3 1024(x16)
addi x16 x16 1024
sw x3 1024(x16)
addi x16 x16 1024
sw x3 1024(x16)
addi x16 x16 1024
sw x3 1024(x16)  
addi x16 x16 1024
sw x3 1024(x16)
addi x16 x16 1024
sw x3 1024(x16)
addi x16 x16 1024
sw x3 1024(x16)
addi x16 x16 1024
sw x3 1024(x16)
addi x16 x16 1024
sw x3 1024(x16)
addi x16 x16 1024
sw x3 1024(x16)

addi x16 x9 16
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)  
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
jal x0 loop
right:
sw x0 0   (x9)
sw x0 1024(x9)
addi x16 x9 1024
sw x0 1024(x16)
addi x16 x16 1024
sw x0 1024(x16)
addi x16 x16 1024
sw x0 1024(x16)
addi x16 x16 1024
sw x0 1024(x16)
addi x16 x16 1024
sw x0 1024(x16)
addi x16 x16 1024
sw x0 1024(x16)
addi x16 x16 1024
sw x0 1024(x16)
addi x16 x16 1024
sw x0 1024(x16)  
addi x16 x16 1024
sw x0 1024(x16)
addi x16 x16 1024
sw x0 1024(x16)
addi x16 x16 1024
sw x0 1024(x16)
addi x16 x16 1024
sw x0 1024(x16)
addi x16 x16 1024
sw x0 1024(x16)
addi x16 x16 1024
sw x0 1024(x16)

addi x9 x9 1
addi x16 x9 16

sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)  
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
addi x16 x16 1024
sw x0 0(x16)
jal x0 loop
stop:
addi x4 x0 0
addi x5 x0 16
jal x0 exit
exit:
add x2 x9 x0
sw x0 0(x2)
sw x0 1(x2)
sw x0 2(x2)
sw x0 3(x2)
sw x0 4(x2)
sw x0 5(x2)
sw x0 6(x2)
sw x0 7(x2)
sw x0 8(x2)
sw x0 9(x2)
sw x0 10(x2)
sw x0 11(x2)
sw x0 12(x2)
sw x0 13(x2)
sw x0 14(x2)
sw x0 15(x2)
addi x2 x2 0b10000000000
addi x4 x4 1
blt x4 x5 exit
jal x0 loop
