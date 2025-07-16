.section .text
.global stage2
.align 4

.macro uart_write reg, value
    li \reg, 0x10000000
    li t2, \value
    sb t2, 0(\reg)
    li t2, 10000
1:  addi t2, t2, -1
    bnez t2, 1b
.endm

stage2:
    call _start_kernel
1:
    wfi
    j 1b
