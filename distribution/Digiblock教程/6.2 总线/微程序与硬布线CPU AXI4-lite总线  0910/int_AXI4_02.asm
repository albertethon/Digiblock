addi t0,zero,0x68    #interrupt address
csrw t0,0x305  # set mtvec   
addi t1,zero,0x12  #data
csrw t1, 0x32F # write axi_wDATA
addi t0,zero,0x01  #address
csrw t0,0x32C  # write axi_wADDR
addi t0,zero,0x20  
csrw t0,0x32A # clear wb_Config & status 
addi a0,zero,0x1C 
csrw a0,0x32A  # write axi_Config: xx011100
addi t1,zero,0x04 
w_wait:
csrr a1,0x32D # read axi_Status
andi t0,a1,0x8
bnez t0,w_ack
addi t1,t1,-1
beqz t1,w_ack
jal w_wait
w_ack:
andi a1,a1,0x30
srai a1,a1,4
csrw a1,0x330 # BRESP write out0
addi t1,zero,0x80
slli t1 t1,4
csrw t1,0x304    # set MEIE in mie   
csrwi 0x300,0x8  # set mstatus  
loop:
wfi
jal loop
csrw zero,0x300  # clear mstatus
csrw ra,0x350   #  push ra
addi t0,zero,0x01  #address
csrw t0,0x32B  # write axi_rADDR
addi t0,zero,0x20  
csrw t0,0x32A # clear wb_Config & status 
addi a0,zero,0x03 
csrw a0,0x32A  # write axi_Config: xxx00011
addi t1,zero,0x04 
r_wait:
csrr a1,0x32D # read axi_Status
andi a1,a1,2
bnez a1,r_ack
addi t1,t1,-1
beqz t1,r_nack
jal r_wait
r_ack:
csrr a2,0x32E # read rDATA
csrw a2,0x330 # rDATA write out0
r_nack:
csrr ra,0x350   #  pop ra
csrwi 0x300,0x8 # set mstatus
uret




