gdt_start:
gdt_null: dd 0x0, 0x0
gdt_code: 
    dw 0xffff, 0x0
    db 0x0, 0x9a, 0xcf, 0x0
gdt_data: 
    dw 0xffff, 0x0
    db 0x0, 0x92, 0xcf, 0x0
gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start