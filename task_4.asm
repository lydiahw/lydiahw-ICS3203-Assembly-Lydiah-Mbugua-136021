section .data
    sensor_value db 0            ; Simulated sensor value (0: low, 1: moderate, 2: high)
    motor_state db 0             ; Motor state (0: off, 1: on)
    alarm_state db 0             ; Alarm state (0: off, 1: triggered)
    msg_motor_on db "Motor is ON", 0
    msg_motor_off db "Motor is OFF", 0
    msg_alarm_triggered db "ALARM! Water level too high!", 0

section .text
    global _start

_start:
    ; Read the sensor value
    mov al, [sensor_value]       ; Load the sensor value into AL

    ; Check the sensor value
    cmp al, 0                    ; Check if sensor value is 0 (low)
    je turn_on_motor             ; If yes, turn on the motor

    cmp al, 1                    ; Check if sensor value is 1 (moderate)
    je stop_motor                ; If yes, stop the motor

    cmp al, 2                    ; Check if sensor value is 2 (high)
    je trigger_alarm             ; If yes, trigger the alarm

    jmp end_program              ; End if no conditions met

turn_on_motor:
    mov byte [motor_state], 1    ; Set motor state to ON
    ; Print motor on message
    mov rax, 1                   ; sys_write
    mov rdi, 1                   ; file descriptor (stdout)
    mov rsi, msg_motor_on        ; message
    mov rdx, 15                  ; message length
    syscall
    jmp end_program

stop_motor:
    mov byte [motor_state], 0    ; Set motor state to OFF
    ; Print motor off message
    mov rax, 1                   ; sys_write
    mov rdi, 1                   ; file descriptor (stdout)
    mov rsi, msg_motor_off       ; message
    mov rdx, 15                  ; message length
    syscall
    jmp end_program

trigger_alarm:
    mov byte [alarm_state], 1    ; Set alarm state to TRIGGERED
    ; Print alarm triggered message
    mov rax, 1                   ; sys_write
    mov rdi, 1                   ; file descriptor (stdout)
    mov rsi, msg_alarm_triggered  ; message
    mov rdx, 34                  ; message length
    syscall
    jmp end_program

end_program:
    ; Exit the program
    mov rax, 60                  ; sys_exit
    xor rdi, rdi                 ; exit code 0
    syscall
