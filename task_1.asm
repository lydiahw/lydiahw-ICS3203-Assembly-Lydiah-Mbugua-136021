section .data
    prompt_msg db "Enter a number: "
    prompt_len equ $ - prompt_msg
    input_buffer times 20 db 0
    error_msg db "Invalid input. Please enter a number.", 10
    error_msg_len equ $ - error_msg
    zero_msg db "The number is zero.", 10
    zero_msg_len equ $ - zero_msg
    negative_msg db "The number is negative.", 10
    negative_msg_len equ $ - negative_msg
    positive_msg db "The number is positive.", 10
    positive_msg_len equ $ - positive_msg

section .text
    global _start

_start:
    ; Display the prompt
    mov rax, 1 ; System call number for write
    mov rdi, 1 ; File descriptor for standard output
    mov rsi, prompt_msg
    mov rdx, prompt_len
    syscall

    ; Read the input number
    mov rax, 0 ; System call number for read
    mov rdi, 0 ; File descriptor for standard input
    mov rsi, input_buffer
    mov rdx, 20 ; Maximum number of bytes to read
    syscall

    ; Null-terminate the input buffer (replace newline with null)
    mov byte [rsi + rax - 1], 0 ; Replace the last byte (newline) with null

    ; Parse the input string and convert it to a number
    mov rsi, input_buffer
    xor rdx, rdx ; Initialize the result to 0
    mov rcx, 1   ; Flag for negative number (1 means positive)

parse_loop:
    movzx eax, byte [rsi]
    cmp eax, '-'
    je handle_negative_sign
    cmp eax, '0'
    jb invalid_input
    cmp eax, '9'
    ja invalid_input

    sub eax, '0'
    imul rdx, rdx, 10
    add rdx, eax
    inc rsi
    cmp byte [rsi], 0
    jne parse_loop

    ; Negate the number if it's negative
    test rcx, rcx
    jz negate_result

    jmp process_input

handle_negative_sign:
    inc rsi
    mov rcx, 0 ; Set flag to indicate negative
    jmp parse_loop
    
invalid_input:
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, error_msg_len
    syscall
    jmp _start

negate_result:
    neg rdx ; Negate the result if it was negative
    jmp process_input

process_input:
    cmp rdx, 0
    je zero_output
    jl negative_output
    jg positive_output

zero_output:
    mov rax, 1
    mov rdi, 1
    mov rsi, zero_msg
    mov rdx, zero_msg_len
    syscall
    jmp exit_program

negative_output:
    mov rax, 1
    mov rdi, 1
    mov rsi, negative_msg
    mov rdx, negative_msg_len
    syscall
    jmp exit_program

positive_output:
    mov rax, 1
    mov rdi, 1
    mov rsi, positive_msg
    mov rdx, positive_msg_len
    syscall

exit_program:
    mov rax, 60 ; System call number for exit
    xor rdi, rdi ; Exit code 0
    syscall 
