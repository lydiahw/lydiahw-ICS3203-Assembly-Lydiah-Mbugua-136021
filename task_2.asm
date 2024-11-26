section .data
    prompt_msg db "Enter 5 integers, separated by spaces:", 10
    prompt_msg_len equ $ - prompt_msg
    input_buffer times 20 db 0 ; Buffer to store input
    newline db 10
section .bss
    array_size equ 5
    array resd array_size ; Reserve space for 5 integers (4 bytes each)
section .text
    global _start

_start:
    ; Display prompt
    mov rax, 1 ; System call number for write
    mov rdi, 1 ; File descriptor for standard output
    mov rsi, prompt_msg
    mov rdx, prompt_msg_len
    syscall

    ; Read input
    mov rax, 0 ; System call number for read
    mov rdi, 0 ; File descriptor for standard input
    mov rsi, input_buffer
    mov rdx, 20 ; Maximum number of bytes to read
    syscall

    ; Parse input and store in array
    mov rsi, input_buffer
    mov rdi, array
    xor rcx, rcx ; Counter for number of integers parsed

parse_loop:
    cmp byte [rsi], 10 ; Check for newline
    je end_parse
    cmp byte [rsi], ' ' ; Check for space
    je next_number

    ; Convert ASCII digit to numeric value
    sub byte [rsi], '0' ; Convert ASCII to integer
    movzx eax, byte [rsi]
    add [rdi], eax ; Add to the current array element

    inc rsi
    jmp parse_loop

next_number:
    inc rsi
    add rdi, 4 ; Move to the next array element
    inc rcx ; Increment the count of numbers parsed
    cmp rcx, array_size
    jl parse_loop ; Continue parsing if we haven't reached the limit

end_parse:

    ; Reverse the array
    mov rsi, array
    mov rdi, array + (array_size - 1) * 4
    mov rcx, array_size / 2 ; Halfway point for reversal

reverse_loop:
    cmp rsi, rdi
    jge end_reverse

    ; Swap the elements
    mov eax, [rsi]
    xchg eax, [rdi]
    mov [rsi], eax

    add rsi, 4
    sub rdi, 4
    loop reverse_loop

end_reverse:

    ; Print the reversed array
    mov rsi, array
    mov rcx, array_size

print_loop:
    mov eax, [rsi]
    call print_integer
    add rsi, 4
    loop print_loop

    ; Print a newline character
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit the program
    mov rax, 60 ; System call number for exit
    xor rdi, rdi ; Exit code 0
    syscall 

; Function to print an integer
print_integer:
    ; Convert integer in EAX to string and print
    mov rbx, 10
    xor rcx, rcx ; Clear counter

.convert_loop:
    xor rdx, rdx ; Clear RDX before division
    div rbx ; Divide EAX by 10
    push rdx ; Store remainder (digit)
    inc rcx ; Increment digit counter
    test eax, eax
    jnz
