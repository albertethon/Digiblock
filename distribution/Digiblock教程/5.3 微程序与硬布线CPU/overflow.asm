addi a1,zero,1
xori a2,a1,-1
srai a2,a2,1
add a3,a2,a1 
sltu a0,a3,a2
csrw a0,0x330
ebreak
add a5,a1,zero
lui a4,0xfffff
loop:
add a4,a4,a5 
slli a5,a5,4
blt a4,zero,loop
ebreak




