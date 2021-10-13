addi sp,sp,-16
sw ra, 12(sp)
lui a0,0x21
addi a0,a0,-1520  #20a10 <string1>
lui a1,0x21
addi a1,a1,-1508   #20a1C <string2>
jalr ra 
lw ra,12(sp)
addi sp,sp,16
li a0,0

