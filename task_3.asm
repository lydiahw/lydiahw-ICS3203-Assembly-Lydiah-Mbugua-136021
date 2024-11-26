section .data
    prompt_msg db "Enter a number: ", 0
    prompt_len equ $ - prompt_msg
    result_msg db "The factorial is: ", 0
    result_len equ $ - result_msg
    input_buffer times 10 db 0 ; Buffer for input

section .bss
    num resb 4 ; Reserve space for the input number

section .text
    global _start

_start:
    ; Display prompt
    mov rax, 1          ; sys_write
    mov rdi, 1          ; file descriptor (stdout)
    mov rsi, prompt_msg ; message
    mov rdx, prompt_len ; message length
    syscall

    ; Read input
    mov rax, 0          ; sys_read
    mov rdi, 0          ; file descriptor (stdin)
    mov rsi, input_buffer; buffer
    mov rdx, 10         ; number of bytes to read
    syscall

    ; Convert input to integer
    mov rax, 0          ; Clear RAX
    mov rsi, input_buffer ; Pointer to input buffer
    movzx rbx, byte [rsi] ; Get first byte (ASCII)
    sub rbx, '0'        ; Convert from ASCII to integer
    mov [num], rbx      ; Store the number

    ; Call factorial function
    mov rax, [num]      ; Load the number into RAX
    call factorial       ; Call factorial function

    ; Print result message
    mov rax, 1          ; sys_write
    mov rdi, 1          ; file descriptor (stdout)
    mov rsi, result_msg ; message
    mov rdx, result_len ; message length
    syscall

    ; Convert the result in RAX to string and print
    call print_integer   ; Print the integer result

    ; Exit program
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; exit code 0
    syscall

; Factorial function
; Input: RAX = n
; Output: RAX = n!
factorial:
    push rbp            ; Preserve base pointer
    mov rbp, rsp        ; Set base pointer to current stack pointer
    push rax            ; Preserve RAX (input number)

    cmp rax, 1          ; Check if n <= 1
    jle .base_case      ; If yes, go to base case

    dec rax             ; n = n - 1
    call factorial      ; Recursive call
    pop rbx            ; Restore original RAX (n)
    imul rax, rbx      ; RAX = n * factorial(n - 1)

    jmp .done

.base_case:
    mov rax, 1          ; Base case: factorial(0) = 1 or factorial(1) = 1

.done:
    pop rax             ; Restore original RAX
    pop rbp             ; Restore base pointer
    ret                 ; Return to caller

; Print integer in RAX
print_integer:
    ; Convert RAX to string and print it
    push rbx            ; Save registers
    push rcx
    push rdx
    push rsi
    push rdi

    mov rbx, 10         ; Divisor for decimal conversion
    xor rcx, rcx        ; Clear digit counter
    mov rsi, input_buffer ; Buffer for storing digits

.convert_loop:
    xor rdx, rdx        ; Clear RDX before division
    div rbx              ; RAX / 10
    add dl, '0'         ; Convert remainder to ASCII
    mov [rsi + rcx], dl ; Store ASCII character in buffer
    inc rcx             ; Increment digit counter
    test rax, rax       ; Check if RAX is zero
    jnz .convert_loop    ; If not, continue converting

    ; Print the number in reverse order
    mov rax, 1          ; sys_write
    mov rdi, 1          ; file descriptor (stdout)
    dec rcx             ; Set index to last character
.print_loop:
    mov dl, [rsi + rcx] ; Load character to print
    mov rdx, 1          ; Number of bytes to write
    syscall             ; Print character
    dec rcx             ; Move to the previous character
    jns
