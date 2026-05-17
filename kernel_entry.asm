[bits 32]
extern main
call main
jmp $

; Хакерское выравнивание: забиваем остаток сектора нулями!
times 512-($-$$) db 0