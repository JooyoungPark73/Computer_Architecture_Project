    AREA text, CODE

    EXPORT  print
    EXPORT  print_char
    EXPORT  scan
    EXPORT  scan_loop
    EXPORT  print_loop
    EXPORT  div
    EXPORT  print_enter
    EXPORT  print_space
    EXPORT  div_signed
    EXPORT  print_signed
	
div
    ; Divides R0 by R1  r0/r1
    ; Returns the quotient in R2, and the remainder in R0
    stmfd   sp!,{r3-r12,LR}         ; Push the existing registers on to the stack
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
    ldmfd   sp!, {r3-r12,PC}         ; Pop the registers off of the stack and return

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

print_enter
	stmfd	sp!, {r0, lr}
	mov		r0, #10
	bl		print_char
	ldmfd	sp!, {r0, pc}

print_space
	stmfd	sp!, {r0, lr}
	mov		r0, #32
	bl		print_char
	ldmfd	sp!, {r0, pc}

print_minus
    stmfd	sp!, {r0, lr}
	mov		r0, #45
	bl		print_char
	ldmfd	sp!, {r0, pc}

print_dot
    stmfd	sp!, {r0, lr}
	mov		r0, #46
	bl		print_char
	ldmfd	sp!, {r0, pc}


div_signed                      ; still r0/r1 = r2 + r0
    stmfd   sp!, {r3-r12, lr}
    mov     r11, #1000
    mov     r12, #10            ; for roundup
    mov     r10, #0             ; r10 = 0
    mul     r0, r11, r0         ; r0 times 1000
    cmp     r1, #0              ; r1 cannot be 0 due to run.s error control
    blt     div_signed_loop_A   ; if r1 < 0, branch
    cmp     r0, #0
    beq     all_0              ;
    blt     div_signed_loop_3   ; if r1 > 0, r0 < 0, branch
    b       div_signed_loop_4   ; r1 > 0, r0 > 0
div_signed_loop_A               ; r1 < 0
    cmp     r0, #0
    blt     div_signed_loop_1   ; r1 < 0, r0 < 0
    b       div_signed_loop_2   ; r1 < 0, r0 > 0
div_signed_loop_1               ; -, -
    sub     r1, r10, r1          ; ABS(r1)
    sub     r0, r10, r0          ; ABS(r0)
    bl      div
    mov     r3, r2              ; r3 = quutient(r2)
    mul     r0, r12, r0         ; remainder*10
    bl      div
    cmp     r2, #5              ; round up?
    mov     r2, r3
    addge   r2, r3, #1
    b       div_signed_exit
div_signed_loop_2               ; -, +
    sub     r1, r10, r1          ; ABS(r1)
    bl      div
    mov     r3, r2              ; r3 = quutient(r2)
    mul     r0, r12, r0         ; remainder*10
    bl      div
    cmp     r2, #5              ; round up?
    mov     r2, r3
    addge   r2, r3, #1
    sub     r2, r10, r2          ; restore sign
    b       div_signed_exit
div_signed_loop_3               ; +, -
    sub     r0, r10, r0          ; ABS (r0)
    bl      div
    mov     r3, r2              ; r3 = quutient(r2)
    mul     r0, r12, r0         ; remainder*10
    bl      div
    cmp     r2, #5              ; round up?
    mov     r2, r3
    addge   r2, r3, #1
    sub     r2, r10, r2          ; restore sign
    b       div_signed_exit
div_signed_loop_4               ; +, +
    bl      div
    mov     r3, r2              ; r3 = quutient(r2)
    mul     r0, r12, r0         ; remainder*10
    bl      div
    cmp     r2, #5              ; round up?
    mov     r2, r3
    addge   r2, r3, #1
    b       div_signed_exit
all_0
    mov     r2, #0
    mov     r0, #0
    b       div_signed_exit
div_signed_exit
    ldmfd   sp!, {r3-r12, pc}


print_signed                    ; specified for two-digit fixed point
    stmfd   sp!, {r1-r12, lr}
    mov     r1, #10             ; r1 always hold 10, for decimal operation
    mov     r11, r0             ; r11 hold original value
    mov     r12, #0x500000      ; 
    mov     r10, #0             ; r10 = digit
    cmp     r11, #0             ;compare r11 and 0
    blge    print_space         ; if value +, print space
    sublt  r0, r10, r0
    mov     r9, r0
    bllt    print_minus         ; if value -, print -
print_signed_1
    cmp     r0, #0              ; if r0 = 0
    beq     print_signed_zero   ; go here
    cmp     r0, r1              ; compare r0 and r1
    blt     print_signed_3      ; if one digit, goto loop3
    bl      div                 ; r0 = first digit, r2 = else
    str     r0, [r12, r10]      ; store first digit
    mov     r0, r2              ; move r0 <- r2
    add     r10, r10, #4        ; increment r10
    cmp     r0, r1              ; compare if r0 with 10
    bge    print_signed_1       ; if r0 > 10, recursive loop again, else goto next stage
    str     r2, [r12, r10]
    add     r10, r10, #4
print_signed_2
    sub     r10, r10, #4        ; decrement r10 by 4
    cmp     r10, #8             ; if three digit left
    bleq    print_signed_4      ; if 0.xxx
    cmp     r10, #4
    bleq    print_signed_5      ; if 0.0xx
    cmp     r10, #0
    bleq    print_signed_6      ; if 0.00x
    ldr     r0, [r12, r10]      ; r0 = relative addressing r12 + r10
    add     r0, r0, #'0'
    bl      print_char
    cmp     r10, #0
    ble     print_signed_exit     ; if no more left to print,  exit
    b       print_signed_2
print_signed_3
    add     r0, r0, #'0'
    bl print_char
print_signed_4
    stmfd   sp!, {r0-r8, r10-r12, lr}
    mov     r0, #'0'
    cmp     r9, #1000
    bllt    print_char
    bl      print_dot
    ldmfd   sp!, {r0-r8, r10-r12, pc}
print_signed_5
    stmfd   sp!, {r0-r8, r10-r12, lr}
    mov     r0, #'0'
    cmp     r9, #100
    bllt    print_char
    bllt    print_dot
    bllt    print_char
    ldmfd   sp!, {r0-r8, r10-r12, pc}
print_signed_6
    stmfd   sp!, {r0-r8, r10-r12, lr}
    mov     r0, #'0'
    cmp     r9, #10
    bllt    print_char
    bllt    print_dot
    bllt    print_char
    bllt    print_char
    ldmfd   sp!, {r0-r8, r10-r12, pc}
print_signed_zero
    adr     r0, printsignedzero_print
    bl      print
    b       print_signed_exit
printsignedzero_print
    DCB     "0.000", 0

print_signed_exit
    mov     r0, r11             ; restore r0's original value
    ldmfd   sp!, {r1-r12, pc}
    END