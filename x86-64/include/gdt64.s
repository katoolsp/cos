    align 16
gdt64_start:
    dd 0x0
    dd 0x0

gdt64_code_segment:
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10011010b
    db 10101111b
    db 0x00

gdt64_data_segment:
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10010010b
    db 10101111b
    db 0x00

gdt64_end:

gdt64_pseudo_descriptor:
    dw gdt64_end - gdt64_start - 1
    dd gdt64_start

CODE_SEG64 equ gdt64_code_segment - gdt64_start
DATA_SEG64 equ gdt64_data_segment - gdt64_start
