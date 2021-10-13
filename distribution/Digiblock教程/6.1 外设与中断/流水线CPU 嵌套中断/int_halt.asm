addi t0,zero,0x30
csrw t0,0x305           # set mtvec   
addi s1,zero,0x10
csrw s1,0x306           # set mtimecmp
addi t1,zero,0x80
csrw t1,0x304           # set  MTIE in mie   
slli t1 t1,4
csrs t1,0x304           # set  MEIE in mie
csrwi 0x300,0x8         # set mstatus  
loop:
sw s1,0x400
sw s1,0x404
jal loop
csrw zero,0x300         # clear mstatus
csrw ra,0x350           #  push ra
csrw t0,0x351           #  push t0 
csrw t1,0x352           #  push t1
csrr t0,0x344           # read mip
jal intmode 
csrr ra,0x350            #  pop ra
csrr t0,0x351            #  pop t0
csrr t1,0x352            #  pop t1
csrwi 0x300,0x8          # set mstatus
uret
intmode:
srli t1 t0,11
beq t1,zero,timeint
csrr t1,0x330            # read out0
xori t1 t1,-1
csrw t1,0x330            # write out0 
xori t1 t1,-1
csrw t1,0x330           # write out0 
timeint:
srli t1 t0,7
andi t1,t1,1 
beq t1,zero,over
addi s1,s1,0x10
csrw s1,0x306          # set mtimecmp
csrr t0,0x330          # read out0
srli t0 t0,31
sltiu t0,t0,1
slli t0 t0,31
csrw t0,0x330         # write out0 
over:
jalr ra