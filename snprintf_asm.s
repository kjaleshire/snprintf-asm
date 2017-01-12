bits 64

section .data

first_last:
    db      "first last", 0

section .bss
buffer:
    resb    128
.length: equ     $ - buffer

section .text

; assert.h
extern _assert
; stdarg.h
extern _va_list
extern _va_start, _va_arg, _va_end
; stdlib.h
extern _exit
; stdio.h
extern _printf
; strings.h
extern _strcmp

global _write_char

_write_char:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov qword [rbp - 8], rdi
    mov qword [rbp - 16], rsi
    mov qword [rbp - 24], rdx
    mov byte [rbp - 32], cl

    mov rax, [rdx + 0]
    cmp rax, rsi
    jae .fail

    mov byte [rdi + rdx], cl
    inc rdx

    mov rax, 0
    jmp .end
.fail:
    mov rax, -1
.end:
    add rsp, 32
    pop rbp
    ret

_main:
    mov rbp, rsp

    mov rdi, [rel buffer]
    mov rsi, buffer.length
    mov rax, [rel first_last]
    push rax
    call _snprintf

    mov rax, 0
    call _exit
_snprintf:
    ret
