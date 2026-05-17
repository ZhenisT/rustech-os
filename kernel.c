/*
    Kernel.c for RTos 1.1
    2026, Ruslan Aldan
*/
// Функция чтения байта из аппаратного порта железа
unsigned char inb(unsigned short port) {
    unsigned char result;
    // Напрямую дёргаем инструкцию процессора IN
    __asm__ volatile("inb %1, %0" : "=a"(result) : "Nd"(port));
    return result;
}

void print_string(char* txt, int row, int col, char color) {
    // Начало видеопамяти
    char* video_memory = (char*) 0xB8000;
    int position = (row * 80 + col) * 2;
    
    // Самопильный сдвиг-каунтер
    int i = 0;

    // Вывод
    while (txt[i] != '\0') {
        video_memory[position] = txt[i];
        video_memory[position + 1] = color;
        position += 2;
        i++;
    }
}

void main() {   
    // Сразу пишем приглашение на чистом экране
    print_string("RUSTECH OS v1.0 -> Press SPACE to call sys_info...", 2, 5, 0x0A); // Зелёный цвет

    // Спрашиваем с клавы
    while (1) {
        // Читаем текущий байт из порта клавиатуры 0x60
        unsigned char scancode = inb(0x60);

        // 0x39 — это скан-код нажатия клавиши ПРОБЕЛ
        if (scancode == 0x39) {
            print_string("SYS: RUSTECH OS v1.1 / Active and Ready!", 4, 5, 0x0E); // Жёлтый цвет
            break; // Выходим из цикла опроса клавиш
        }
    }

    // Вечный цикл чтоб не заглохнуть
    while (1);    
}
// Просто на всякий (биос чтоб не шуганул метелкой)
void _start() {
	main();
}

