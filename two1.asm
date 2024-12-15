.model small  
.stack 100h

.data
    MAX_BUFFER_SIZE EQU 200           ; Максимальный размер буфера
    buffer db MAX_BUFFER_SIZE dup(0)  ; Буфер для хранения 200 символов

    msgInput db 'Input a string (maximum 200 characters): $' ; Введите строку (максимум 200 символов)
    msgOutput db 0Dh, 0Ah, 'Modified string: $'            ; Измененная строка: 
    msgEnd db 0Dh, 0Ah, 'End of input.$'                    ; Конец ввода.
    msgOverflow db 0Dh, 0Ah, 'Error: buffer overflow.$'      ; Ошибка: переполнение буфера.
    strLength db 0                       ; Длина введенной строки

.code
main proc
    ; Инициализация сегментов
    mov ax, @data
    mov ds, ax

    ; Вывод сообщения о вводе
    mov dx, offset msgInput
    mov ah, 09h
    int 21h

    ; Ввод строки символов
    lea dx, buffer                ; Указатель на буфер
    mov byte ptr [buffer], MAX_BUFFER_SIZE ; Максимальная длина
    mov ah, 0Ah                   ; Функция для ввода строки
    int 21h

    ; Проверка переполнения буфера
    mov al, [buffer + 1]           ; Получаем длину введенной строки (второй байт)
    cmp al, MAX_BUFFER_SIZE        ; Сравниваем с максимальным размером
    ja overflow_error              ; Если превышает, переходим к ошибке
    mov [strLength], al               ; Сохраняем длину

    ; Добавляем символ '$' в конец строки для корректного вывода
    lea si, buffer + 2             ; Пропускаем первый байт (максимальная длина) и байт длины
    mov cl, [strLength]               ; Загружаем длину строки в CL
    add si, cx                     ; Устанавливаем указатель на конец строки
    mov byte ptr [si], '$'         ; Добавляем '$' в конец строки

    ; Вызов функции реверса строки
    call reverse_string

    ; Выводим сообщение "Измененная строка:"
    mov dx, offset msgOutput
    mov ah, 09h                    ; Функция для вывода строки
    int 21h

    ; Выводим реверсированную строку
    lea dx, buffer + 2             ; Указатель на строку (пропускаем 2 байта)
    mov ah, 09h                    ; Функция для вывода строки
    int 21h

    ; Завершение программы
    mov dx, offset msgEnd
    mov ah, 09h
    int 21h

    ; Завершение программы
    mov ax, 4C00h
    int 21h

overflow_error:
    ; Выводим сообщение об ошибке переполнения
    mov dx, offset msgOverflow
    mov ah, 09h
    int 21h
    ; Завершение программы
    mov ax, 4C00h
    int 21h

; Функция реверса строки
reverse_string proc
    lea si, buffer + 2            ; Начало строки (пропускаем 2 байта)
    mov cl, [strLength]              ; Длина строки в CL
    dec cl                         ; Декрементируем для работы с индексами
    lea di, buffer + 2            ; Указатель на начало строки
    add di, cx                     ; Устанавливаем указатель DI на последний символ строки

reverse_loop:
    ; Проверка на завершение реверса (если SI >= DI)
    cmp si, di
    jge reverse_end

    ; Меняем местами символы по адресам SI и DI
    mov al, [si]
    xchg al, [di]
    mov [si], al

    ; Смещаем SI вправо, а DI влево
    inc si
    dec di
    jmp reverse_loop

reverse_end:
    ret
reverse_string endp

main endp
end main

Код для C++:
#include <iostream>
#include <cstring>
using namespace std;
const int MAX_BUFFER_SIZE = 200;  // Максимальный размер буфера

void reverseString(char* str, int length) {
    int start = 0;
    int end = length - 1;
    while (start < end) {
        swap(str[start], str[end]);
        start++;
        end--;
    }
}

int main() {
    char buffer[MAX_BUFFER_SIZE + 1]; // Буфер для ввода с дополнительным байтом под завершающий символ
    int length = 0;

    // Сообщение о вводе строки
    cout << "Input a string (maximum 200 characters): ";

    // Ввод строки
    cin.getline(buffer, MAX_BUFFER_SIZE);

    // Определение длины строки
    length = strlen(buffer);

    // Проверка на переполнение буфера
    if (length >= MAX_BUFFER_SIZE) {
        cout << "\nError: buffer overflow.\n";
        return 1;
    }

    // Выполнение реверса строки
    reverseString(buffer, length);

    // Вывод измененной строки
    cout << "\nModified string: " << buffer << "\n";

    // Сообщение о завершении программы
    cout << "End of input.\n";
    return 0;
}

