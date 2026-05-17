[bits 16]
disk_load:
    push dx
    mov ah, 0x02    ; Функция чтения секторов BIOS
    mov al, dh      ; Читать DH секторов
    mov ch, 0x00    ; Цилиндр 0
    mov dh, 0x00    ; Головка 0
    mov cl, 0x02    ; Начинать со 2-го сектора (сразу после загрузчика)
    int 0x13        ; Прерывание диска BIOS
    jc disk_error   ; Если ошибка — прыгаем
    pop dx
    ret
disk_error:
    jmp $           ; Если диск не считался, зависаем тут
