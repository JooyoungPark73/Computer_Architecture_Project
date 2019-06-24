    AREA text, CODE

    EXPORT  print_char
    EXPORT  scan
    EXPORT  print
    EXPORT  scan_loop
    EXPORT  print_loop
    EXPORT  div

div
    ; Divides R0 by R1  r0/r1
    ; Returns the quotient in R2, and the remainder in R0
    stmfd   sp!,{r4-r12,LR}         ; Push the existing registers on to the stack
    mov     r4,r1               ; Put the divisor in R4
    mov     r5, #0              ; r5 count quotient
div_loop_1
    cmp     r0, r1              ; compare r0 and r1
    blt     div_loop_2          ; r0 < r1, branch
    sub     r0, r0, r1          ; sub once
    add     r5, r5, #1          ; increment r5
    b       div_loop_1
div_loop_2
    mov     r2, r5
    ldmfd   sp!, {r4-r12,PC}         ; Pop the registers off of the stack and return

print
    stmfd   sp!, {r1, r4-r12, lr}
    mov     r1, r0
    mov     r0, #4
    swi     0x123456
    ldmfd   sp!, {r1, r4-r12, pc}

scan
    stmfd   sp!, {lr}
    mov     r0, #7
    swi     0x123456
    ldmfd   sp!, {pc}



print_char
    stmfd   sp!, {r0, r1, lr}   ; push register you want to save
    adr     r1, char
    strb    r0, [r1]
    mov     r0, #3
    swi     0x123456
    ldmfd   sp!, {r0, r1, pc}


char
    DCB 0


scan_loop
    stmfd   sp!, {r1-r12, lr}
    mov     r2, #0              ;initialize r2
scan_loop_1
    bl      scan
    cmp     r0, #10             ; check if input value is Enter
    beq     scan_loop_exit
    bl      print_char
    sub     r0, r0, #'0'
    mov     r1, #10             ; will be used below
    mul     r2, r1, r2              ; make current value *10
    add     r2, r2, r0          ; add current value*10 and input value
    b      scan_loop_1
scan_loop_exit
    mov     r0, r2
    ldmfd   sp!, {r1-r12, pc}



print_loop
    stmfd   sp!, {r1-r12, lr}
    mov     r1, #10             ; r1 always hold 10, for decimal operation
    mov     r11, r0             ; r11 hold original value
    mov     r12, #0x500000      ; 
    mov     r10, #0             ; r10 = digit
print_loop_1
    cmp     r0, r1              ; compare r0 and r1
    blt     print_loop_3        ; if one digit, goto loop3
    bl      div                 ; r0 = first digit, r2 = else
    str     r0, [r12, r10]           ; store first digit
    mov     r0, r2              ; move r0 <- r2
    add     r10, r10, #4        ; increment r10
    cmp     r0, r1              ; compare if r0 with 10
    bge    print_loop_1         ; if r0 > 10, recursive loop again, else goto next stage
    str     r2, [r12, r10]
    add     r10, r10, #4
print_loop_2
    sub     r10, r10, #4        ; decrement r10 by 4
    ldr     r0, [r12, r10]      ; r0 = relative addressing r12 + r10
    add     r0, r0, #'0'
    bl      print_char
    cmp     r10, #0
    ble     print_loop_exit     ; if no more left to print,  exit
    b       print_loop_2
print_loop_3
    add     r0, r0, #'0'
    bl print_char
print_loop_exit
    mov     r0, r11             ; restore r0's original value
    ldmfd   sp!, {r1-r12, pc}
    END