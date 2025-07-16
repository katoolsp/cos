section .stage2

[bits 16]

    cli
    lgdt [gdt32_pseudo_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG32:start_prot_mode

[bits 32]

start_prot_mode:
    mov ax, DATA_SEG32
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebx, 0x1000
    call build_page_table
    mov cr3, ebx

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov ecx, 0xc0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    lgdt [gdt64_pseudo_descriptor]

    jmp CODE_SEG64:start_long_mode

end:
    hlt
    jmp end

build_page_table:
    pusha

    PAGE64_PAGE_SIZE equ 0x1000
    PAGE64_TAB_SIZE equ 0x1000
    PAGE64_TAB_ENT_NUM equ 512

    mov ecx, PAGE64_TAB_SIZE
    mov edi, ebx
    xor eax, eax
    rep stosd

    mov edi, ebx
    lea eax, [edi + (PAGE64_TAB_SIZE | 11b)]
    mov dword [edi], eax

    add edi, PAGE64_TAB_SIZE
    add eax, PAGE64_TAB_SIZE
    mov dword [edi], eax

    add edi, PAGE64_TAB_SIZE
    add eax, PAGE64_TAB_SIZE
    mov dword [edi], eax

    add edi, PAGE64_TAB_SIZE
    mov ebx, 11b
    mov ecx, PAGE64_TAB_ENT_NUM
build_page_table_set_entry:
    mov dword [edi], ebx
    add ebx, PAGE64_PAGE_SIZE
    add edi, 8
    loop build_page_table_set_entry

    popa
    ret

[bits 64]

start_long_mode:
    extern _start_kernel
    call _start_kernel

end64:
    hlt
    jmp end64

%include "include/gdt32.s"
%include "include/gdt64.s"
