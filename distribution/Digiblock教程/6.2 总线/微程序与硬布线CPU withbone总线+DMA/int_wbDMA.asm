addi t0,zero,0x38
csrw t0,0x305  # set mtvec   
addi t0,zero,0x100
csrw t0,0x328  # write rADR
addi t0,zero,0x01
csrw t0,0x329  # write wADR
addi a0,zero,0x4F2 
csrw a0,0x326  # DMA_Config: 01001111xx10
addi t1,zero,0x80
slli t1 t1,4
csrw t1,0x304    # set MEIE in mie   
csrwi 0x300,0x8  # set mstatus  
loop:
wfi
jal loop
csrw zero,0x300  # clear mstatus
csrw ra,0x350   #  push ra
csrr a1,0x327
beqz a1,INTR
addi t0,zero,0x01
csrs t0,0x326  # set DMA_Config: xxx1
jal over
INTR:
csrw zero,0x326  # clear DMA_Config
over:
csrr ra,0x350   #  pop ra
csrwi 0x300,0x8 # set mstatus
uret



