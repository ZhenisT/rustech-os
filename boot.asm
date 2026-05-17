[org 0x7c00]            ; BIOS загружает нас сюда
KERNEL_OFFSET equ 0x1000 ; Сюда в память мы загрузим наш Си-код

mov [BOOT_DRIVE], dl    ; BIOS сохраняет номер диска в регистр DL, запомним его

mov bp, 0x9000          ; Настраиваем стек подальше от кода
mov sp, bp

call load_kernel        ; Шаг 1: Читаем Си-код с диска
call switch_to_pm       ; Шаг 2: Включаем 32-битный режим (Protected Mode)
jmp $                   ; Сюда код никогда не дойдет

%include "disk.asm"     ; Подключаем наш код для чтения диска
%include "gdt.asm"      ; Подключаем таблицу GDT (нужна для 32-бит)

[bits 16]
switch_to_pm:
    cli                 ; Отключаем 16-битные прерывания
    lgdt [gdt_descriptor] ; Загружаем таблицу GDT
    mov eax, cr0
    or eax, 0x1         ; Включаем бит защищенного режима в процессоре
    mov cr0, eax
    jmp CODE_SEG:init_pm ; Делаем длинный прыжок для очистки конвейера

[bits 32]
init_pm:
    mov ax, DATA_SEG    ; Настраиваем старые сегменты на новые данные
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000    ; Обновляем стек под 32-битный режим
    mov esp, ebp
    call BEGIN_PM       ; Прыгаем к запуску Си!

[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET ; Адрес в памяти, куда загружать код
    mov dh, 2           ; Сколько секторов читать с диска (наша Си-программа)
    mov dl, [BOOT_DRIVE] ; С какого диска читать
    call disk_load      ; Вызываем функцию чтения
    ret

[bits 32]
BEGIN_PM:
    jmp KERNEL_OFFSET   ; МАГИЯ! Прыгаем прямо в твою программу на Си!

BOOT_DRIVE db 0
times 510-($-$$) db 0
dw 0xaa55
