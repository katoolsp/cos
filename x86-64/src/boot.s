section .boot_sector
global __start

[bits 16]

__start:
    mov si, disk_address_packet
    mov ah, 0x42
    mov dl, 0x80
    int 0x13
    jc ignore_disk_read_error

ignore_disk_read_error:
    SND_STAGE_ADDR equ (BOOT_LOAD_ADDR + SECTOR_SIZE)
    jmp 0:SND_STAGE_ADDR

end:
    hlt
    jmp end

align 4
disk_address_packet:
    db 0x10
    db 0
dap_sectors_num:
    dw READ_SECTORS_NUM
    dd (BOOT_LOAD_ADDR + SECTOR_SIZE)
    dq 1

READ_SECTORS_NUM equ 64
BOOT_LOAD_ADDR equ 0x7c00
SECTOR_SIZE equ 512
