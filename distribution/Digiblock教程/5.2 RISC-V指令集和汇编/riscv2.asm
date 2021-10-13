.section .rodata
.align 4 
string1: 
.string "Hello,%s!\n"
string2: 
.string "world"
.text
.align 2 
.globl main
main:   # label for start of main
addi sp,sp,-16
sw ra,12(sp)
lui a0, %hi(string1)
addi a0,a0 %lo(string2)
# call printf  
lw ra 12(sp)
addi sp,sp,16
li a0,0
lui ra 0x400
ret
