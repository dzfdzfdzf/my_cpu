start:
lui x2 0xD0000 #x2=0xD0000000,1位置的拷贝
lui x6 0xF0000 #x6=0xF0000000
ori x3 x3 0x0F
slli x3 x3 8 
ori x3 x3 0x0FF #x3=0xfff
lui x9 0xD0000#1左上角位置
lui x28 0xD0000
addi x28  x28 60#2左上角位置 
addi x30 x0 0x0f#x30=0xf
addi x31 x0 0x0f0#x31=0xf0
slli x29 x31 4#x29=x=f00
addi x10 x0 1#上
addi x11 x0 2#下
addi x12 x0 4#左
addi x13 x0 8#右 
addi x14 x0 256#终止
addi x15 x0 512#重启
addi x26 x0 0#切换哪个玩家
addi x25 x0 1#常数1
addi x1 x0 0# i
addi x4 x0 0# j
addi x5 x0 16
init:
sw x3 0(x2)
sw x3 0(x27)
addi x2 x2 1
addi x27 x27 1
addi x1 x1 1#i++
blt x1 x5 init
addi x2 x2 0b10000000000
addi x27 x27 0b10000000000
addi x4 x4 1#j++
addi x1 x0 0
blt x4 x5 init
loop:
lw x7 0(x6)
xori x26 x26 1
and x20 x7 x30#取SW[3:0]的数值
and x21 x7 x31#取sw[7:4]的数值
and x22 x7 x29#取sw[11:8]的数值
srai x21 x21 4
beq  x22 x14 stop
beq x22 x15 start

beq x26 x0 player1
beq x26 x25 player2

player2:
beq x21 x10 up2
beq x21 x11 down2
beq x21 x12 left2
beq x21 x13 right2
player1:
beq x20 x10 up1
beq x20 x11 down1
beq x20 x12 left1
beq x20 x13 right1
up1:
addi x9 x9 -1024
add x2 x9 x0
addi x1 x0 0# i
addi x5 x0 16 
uploop11:#执行16次
sw x3 0(x2)
addi x2 x2 1
addi x1 x1 1
blt x1 x5 uploop11
addi x1 x0 0# i
addi x16 x9 1024
addi x5 x0 15
uploop12:#执行15次
addi x16 x16 1024
addi x1  x1 1
blt x1 x5 uploop12
addi x1 x0 0# i
addi x5 x0 16 
uploop13:#执行16次
sw x0 0(x16)
addi x16 x16 1
addi x1  x1 1
blt x1 x5 uploop13
jal x0 loop
down1:
add x2 x9 x0
addi x1 x0 0# i
addi x5 x0 16 
downloop11:
sw x0 0(x2)
addi x2 x2 1
addi x1 x1 1
blt x1 x5 downloop11#执行16次
addi x9 x9 1024 
addi x16 x9 1024
addi x1 x0 0# i
addi x5 x0 14 
downloop12:
addi x16 x16 1024
addi x1 x1 1
blt x1 x5 downloop12 #执行14次
addi x1 x0 0# i
addi x5 x0 16
downloop13:
sw x3 0 (x16)
addi x1 x1 1
addi x16 x16 1
blt x1 x5 downloop13#执行16次
jal x0 loop
left1:
addi x9 x9 -1
sw x3 0   (x9)
sw x3 1024(x9)
addi x16 x9 1024
addi x1 x0 0# i
addi x5 x0 14
leftloop11:
sw x3 1024(x16)
addi x16 x16 1024
addi x1 x1 1
blt x1 x5 leftloop11#执行14次
addi x16 x9 16
addi x1 x0 0
addi x5 x0 16
leftloop12:
sw x0 0(x16)
addi x16 x16 1024
addi x1 x1 1
blt x1 x5 leftloop12#执行16次
jal x0 loop
right1:
sw x0 0   (x9)
sw x0 1024(x9)
addi x16 x9 1024
addi x1 x0 0
addi x5 x0 14
rightloop11:
sw x0 1024(x16)
addi x16 x16 1024
addi x1 x1 1
blt x1 x5 rightloop11#执行14次
addi x9 x9 1
addi x16 x9 15
addi x1 x0 0
addi x5 x0 16
rightloop12:
sw x0 0(x16)
addi x16 x16 1024
addi x1 x1 1
blt x1 x5 rightloop12
jal x0 loop

up2:
addi x28 x28 -1024
add x2 x28 x0
addi x1 x0 0# i
addi x5 x0 16 
uploop21:#执行16次
sw x3 0(x2)
addi x2 x2 1
addi x1 x1 1
blt x1 x5 uploop21
addi x1 x0 0# i
addi x16 x28 1024
addi x5 x0 15
uploop22:#执行15次
addi x16 x16 1024
addi x1  x1 1
blt x1 x5 uploop22
addi x1 x0 0# i
addi x5 x0 16 
uploop23:#执行16次
sw x0 0(x16)
addi x16 x16 1
addi x1  x1 1
blt x1 x5 uploop23
jal x0 loop
down2:
add x2 x28 x0
addi x1 x0 0# i
addi x5 x0 16 
downloop21:
sw x0 0(x2)
addi x2 x2 1
addi x1 x1 1
blt x1 x5 downloop21#执行16次
addi x28 x28 1024 
addi x16 x28 1024
addi x1 x0 0# i
addi x5 x0 14 
downloop22:
addi x16 x16 1024
addi x1 x1 1
blt x1 x5 downloop22 #执行14次
addi x1 x0 0# i
addi x5 x0 16
downloop23:
sw x3 0 (x16)
addi x1 x1 1
addi x16 x16 1
blt x1 x5 downloop23#执行16次
jal x0 loop
left2:
addi x28 x28 -1
sw x3 0   (x28)
sw x3 1024(x28)
addi x16 x28 1024
addi x1 x0 0# i
addi x5 x0 14
leftloop21:
sw x3 1024(x16)
addi x16 x16 1024
addi x1 x1 1
blt x1 x5 leftloop21#执行14次
addi x16 x28 16
addi x1 x0 0
addi x5 x0 16
leftloop22:
sw x0 0(x16)
addi x16 x16 1024
addi x1 x1 1
blt x1 x5 leftloop22#执行16次
jal x0 loop
right2:
sw x0 0   (x28)
sw x0 1024(x28)
addi x16 x28 1024
addi x1 x0 0
addi x5 x0 14
rightloop21:
sw x0 1024(x16)
addi x16 x16 1024
addi x1 x1 1
blt x1 x5 rightloop21#执行14次
addi x28 x28 1
addi x16 x28 15
addi x1 x0 0
addi x5 x0 16
rightloop22:
sw x0 0(x16)
addi x16 x16 1024
addi x1 x1 1
blt x1 x5 rightloop22
jal x0 loop
stop:
addi x4 x0 0# j
addi x5 x0 16
addi x1 x0 0# i
add x2 x9 x0
add x27 x28 x0
exit:
sw x0 0(x2)
sw x0 0(x27)
addi x2 x2 1
addi x27 x27 1
addi x1 x1 1
blt  x1 x5 exit
addi x2 x2 0b10000000000
addi x27 x27 0b10000000000
addi x4 x4 1
addi x1 x0 0
blt x4 x5 exit
jal x0 loop

