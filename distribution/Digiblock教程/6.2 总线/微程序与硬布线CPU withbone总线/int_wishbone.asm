addi t0,zero,0x3C
csrw t0,0x305  # set mtvec   
csrr t1,0x33F #  read IN0
csrw t1, 0x323 # write wb_DATo
addi t0,zero,0x01
csrw t0,0x322  # write wb_ADR
addi a0,zero,0x13 
csrw a0,0x321  # write wb_Config: 0001xx11
jal wait
addi t1,zero,0x80
slli t1 t1,4
csrw t1,0x304    # set MEIE in mie   
csrwi 0x300,0x8  # set mstatus  
loop:
wfi
jal loop
csrw zero,0x300  # clear mstatus
csrw ra,0x350   #  push ra
addi t0,zero,0x01
csrw t0,0x322  # write wb_ADR
addi a0,zero,0x31 
csrw a0,0x321 # write wb_Config: 0011xx01
jal wait
csrr ra,0x350   #  pop ra
csrwi 0x300,0x8 # set mstatus
uret
wait:
addi t2,zero,0x04 
csrr a1,0x325 #  read wb_Status
bnez a1, ack
addi,t3,t3,1
bge t3,t2,nack
jal zero, wait
ack:
andi a0,a0,0x02
bnez a0, nack
csrr a2, 0x324 # read wb_DATi
csrw a2,0x330 # write out0
nack:
csrw zero,0x321 # clear wb_Config
jalr ra



