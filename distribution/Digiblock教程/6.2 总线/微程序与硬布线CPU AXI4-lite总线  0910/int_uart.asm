addi t0,zero,0x28
csrw t0,0x305       # set mtvec   
#addi s1,zero,0x02
lui s1,0x4e20            
csrw s1,0x332       # set uart rate 9600 bound
addi t1,zero,0x80
slli t1 t1,4
csrw t1,0x304       # set  MEIE in mie   
csrwi 0x300,0x8     # set mstatus  
loop:
wfi
jal loop
csrw zero,0x300     # clear mstatus
csrwi 0x330,0x8     # write out0
csrw ra,0x350       #  push ra
csrw t0,0x351       #  push t0 
csrw t1,0x352      #  push t1
jal intmode 
csrr ra,0x350      #  pop ra
csrr t0,0x351      #  pop t0
csrr t1,0x352      #  pop t1
csrwi 0x300,0x8    # set mstatus
uret
intmode:
#csrr t0,0x344     # read mip
#srli t1 t0,11
#beq t1,zero,over
csrr t2,0x334      # read uart rxdata
csrw t2,0x330      # rxdata write out0 
csrw t2,0x333      # rxdata write txdata 
csrsi 0x332,1      # set TX_vld  uart is start
nop
nop
csrci 0x332,1     # clear TX_vld
over:
jalr ra



