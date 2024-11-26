section .data
    prompt_msg db "Enter a number: "
    prompt_len equ $ - prompt_msg
    input_buffer times 20 db 0
    error_msg db "Invalid input. Please enter a number.", 10, 
    error_msg_len equ $ - error_msg
    zero_msg db "The number is zero.", 10, 
    zero_msg_len equ $ - zero_msg
    negative_msg db "The number is negative.", 10, 
    negative_msg_len equ $ - negative_msg
    positive_msg db "The number is positive.", 10, 
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

    ; Parse the input string and convert it to a number
    mov rsi, input_buffer
    mov rdx, 0 ; Initialize the result to 0
    mov rcx, 1 ; Flag for negative number

parse_loop:
    movzx eax, byte [rsi]
    cmp eax, '-'
    je handle_negative_sign
    cmp eax, '0'
    jb invalid_input
    cmp eax, '9'
    ja invalid_input

    sub eax, '0'
    imul rdx, 10
    imul rdx, rcx ; Negate the sign flag if necessary
    add rdx, eax
    inc rsi
    cmp byte [rsi], 0
    jne parse_loop

    jmp process_input

handle_negative_sign:
    inc rsi
    jmp parse_loop
    
invalid_input:
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, error_msg_len
    syscall
    jmp _start


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



  

