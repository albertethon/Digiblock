addi t0,zero,0x4c
csrw t0,0x361           # set INT for key0     
addi t1,zero,0x5c
csrw t1,0x362           # set INT for key1   
addi t2,zero,0x6c
csrw t2,0x363           # set INT for uart 
csrsi 0x371,3         # set int0 mesh 
csrsi 0x372,2         # set int1 mesh 
csrsi 0x373,7         # set int2 mesh 
#addi s1,zero,0x02
lui s1,0x4e20            
csrw s1,0x332            # set uart rate  9600 bound
addi t3,zero,0x780
slli t3 t3,4
csrw t3,0x304           # set MEIE & ExINTx in mie   
csrwi 0x300,0x8         # set mstatus  
loop:
nop
nop
wfi
jal loop
#csrw zero,0x300         # clear mstatus 
csrw t0,0x330         # write out0 
xori t0,t0,-1
csrw t0,0x330           # write out0 
#csrwi 0x300,0x8          # set mstatus
uret
#csrw zero,0x300         # clear mstatus 
csrw t1,0x330            # write out0 
xori t1,t1,-1
csrw t1,0x330           # write out0 
#csrwi 0x300,0x8          # set mstatus
uret
#csrw zero,0x300         # clear mstatus
csrr t2,0x334           # read uart rxdata
csrw t2,0x330         # rxdata write out0 
csrw t2,0x333        # rxdata write txdata 
csrsi 0x332,1            # set TX_vld  uart is start
nop
nop
csrci 0x332,1            # clear TX_vld
#csrwi 0x300,0x8          # set mstatus
uret



