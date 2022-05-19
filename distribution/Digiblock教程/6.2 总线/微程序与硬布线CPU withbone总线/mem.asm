addi a0,zero,6
loop: 
lw s1,(s0)
sw s1,0x400(s2)
sw s1,0x404(s2)
jal operate
addi s0,s0,4
addi s2,s2,8
addi a0,a0,-1 
bne a0,zero,loop
ebreak
operate:
blt s1,zero,negative 
beq s1,zero,zeros 
addi a3,a3,1
jalr ra
negative:
addi a1,a1,1
jalr ra
zeros:
addi a2,a2,1
jalr ra

