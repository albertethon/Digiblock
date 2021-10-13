addi t0,zero,0x40
csrw t0,0x305           # set mtvec   

addi t1,zero,0x80
slli t1 t1,4
csrw t1,0x304           # set  MEIE in mie   
csrwi 0x300,0x8         # set mstatus  
csrwi 0x333,0x8        # write 0x08 to txdata 
csrsi 0x332,1            # set TX_vld  uart is start
nop
nop
nop
csrci 0x332,1            # clear TX_vld
wfi
