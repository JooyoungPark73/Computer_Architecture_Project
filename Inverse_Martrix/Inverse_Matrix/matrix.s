    AREA text, CODE

    IMPORT  print
    IMPORT  print_char
    IMPORT  scan
    IMPORT  scan_loop
    IMPORT  print_loop
    IMPORT  div
    IMPORT  print_enter
    IMPORT  print_space
    IMPORT  div_signed
    IMPORT  print_signed

    EXPORT  input_matrix
    EXPORT  calc_transposed
    EXPORT  calc_determinant
    EXPORT  det_trans_calc
    EXPORT  print_inverse

input_matrix                    ; input matrix 0x00
    stmfd   sp!, {r0-r3, r7-r12, lr}
    bl      scan_loop
    str     r0, [r4]
    bl      print_space
    bl      scan_loop
    str     r0, [r4, #4]
    bl      print_space
    bl      scan_loop
    str     r0, [r4, #8]
    bl      print_enter         ; first row

    bl      scan_loop
    str     r0, [r4, #12]
    bl      print_space
    bl      scan_loop
    str     r0, [r4, #16]
    bl      print_space
    bl      scan_loop
    str     r0, [r4, #20]
    bl      print_enter         ; second row

    bl      scan_loop
    str     r0, [r4, #24]
    bl      print_space
    bl      scan_loop
    str     r0, [r4, #28]
    bl      print_space
    bl      scan_loop
    str     r0, [r4, #32]
    bl      print_enter         ; third row


    ldmfd   sp!, {r0-r3, r7-r12, pc}

; a  b  c
; d  e  f
; g  h  i


calc_transposed                        ; calculate transposed
    stmfd   sp!, {r0-r3, r7-r12, lr}
    ldr		r0, [r4, #16]
    ldr		r1, [r4, #32]
    mul		r2, r1, r0		; r2 = ei
    ldr		r0, [r4, #20]
    ldr		r1, [r4, #28]
    mul		r0, r1, r0		; r0 = fh
    sub		r2, r2, r0		; r2 = A = ei-fh
    str		r2,[r5]         ; save at transposed position
    
    ldr		r0, [r4, #4]
    ldr		r1, [r4, #32]
    mul		r2, r1, r0		; r2 = bi
    ldr		r0, [r4, #8]
    ldr		r1, [r4, #28]
    mul		r0, r1, r0		; r0 = ch
    sub		r2, r0, r2		;r2 = D = ch-bi = -(bi-ch)
    str		r2,[r5, #4]     ; save at transposed position
    
    ldr		r0, [r4, #4]
    ldr		r1, [r4, #20]
    mul		r2, r1, r0		; r2 = bf
    ldr		r0, [r4, #8]
    ldr		r1, [r4, #16]
    mul		r0, r1, r0		; r0 = ce
    sub		r2, r2, r0		; r2 = G = bf-ce
    str		r2,[r5, #8]     ; save at transposed position
    
    ldr		r0, [r4, #12]
    ldr		r1, [r4, #32]
    mul		r2, r1, r0		; r2 = di
    ldr		r0, [r4, #20]
    ldr		r1, [r4, #24]
    mul		r0, r1, r0		; r0 = fg
    sub		r2, r0, r2		; r2 = B = fg - di
    str		r2,[r5, #12]    ; save at transposed position
    
    ldr		r0, [r4]
    ldr		r1, [r4, #32]
    mul		r2, r1, r0		; r2 = ai
    ldr		r0, [r4, #8]
    ldr		r1, [r4, #24]
    mul		r0, r1, r0		; r0 = cg
    sub		r2, r2, r0		; r2 = E = ai - cg
    str		r2,[r5, #16]    ; save at transposed position
    
    ldr		r0, [r4]
    ldr		r1, [r4, #20]
    mul		r2, r1, r0		; r2 = af
    ldr		r0, [r4, #8]
    ldr		r1, [r4, #12]
    mul		r0, r1, r0		; r0 = cd
    sub		r2, r0, r2		; r2 = H = cd-af
    str		r2,[r5, #20]    ; save at transposed position
    
    ldr		r0, [r4, #12]
    ldr		r1, [r4, #28]
    mul		r2, r1, r0		; r2 = dh
    ldr		r0, [r4, #16]
    ldr		r1, [r4, #24]
    mul		r0, r1, r0		; r0 = eg
    sub		r2, r2, r0		; r2 = C = dh-eg
    str		r2,[r5, #24]    ; save at transposed position
    
    ldr		r0, [r4]
    ldr		r1, [r4, #28]
    mul		r2, r1, r0		; r2 = ah
    ldr		r0, [r4, #4]
    ldr		r1, [r4, #24]
    mul		r0, r1, r0		; r0 = bg
    sub		r2, r0, r2		; r2 = F = bg - ah
    str		r2,[r5, #28]    ; save at transposed position
    
    ldr		r0, [r4]
    ldr		r1, [r4, #16]
    mul		r2, r1, r0		; r2 = ae
    ldr		r0, [r4, #4]
    ldr		r1, [r4, #12]
    mul		r0, r1, r0		; r0 = bd
    sub		r2, r2, r0		; r2 = I = ae - bd
    str		r2,[r5, #32]    ; save at transposed position

    ldmfd   sp!, {r0-r3, r7-r12, pc}


calc_determinant
    stmfd   sp!, {r0-r3, r7-r11, lr}
    ldr     r1, [r4]        ; r1 = a
    ldr     r2, [r5]        ; r2 = A
    mul     r1, r2, r1      ; r1 = aA
    ldr     r2, [r4, #4]    ; r2 = b
    ldr     r3, [r5, #12]   ; r3 = B
    mul     r2, r3, r2      ; r2 = bB
    add     r1, r2, r1      ; r1 = aA + bB
    ldr     r2, [r4, #8]    ; r2 = c
    ldr     r3, [r5, #24]   ; r3 = C
    mul     r2, r3, r2      ; r2 = cC
    add     r1, r2, r1      ; r1 = aA + bB + cC = det
    mov     r12, r1         ; r12 = determinant
    ldmfd   sp!, {r0-r3, r7-r11, pc}


det_trans_calc
    stmfd   sp!, {r0-r4, r7-r12, lr}     ; r5 for offset
    mov     r10, #0
det_trans_calc_loop_1
    mov     r1, r12
    cmp     r10, #36
    beq     det_trans_calc_exit
    ldr     r0, [r5, r10]
    bl      div_signed
    str     r2, [r6, r10]
    add     r10, r10, #4
    b       det_trans_calc_loop_1
det_trans_calc_exit
    ldmfd   sp!, {r0-r4, r7-r12, pc}


print_inverse
    stmfd   sp!, {r0-r5, r7-r12, lr}

    bl      print_enter
    ldr     r0, [r6, #0]
    bl      print_signed
    bl      print_space
    ldr     r0, [r6, #4]
    bl      print_signed
    bl      print_space
    ldr     r0, [r6, #8]
    bl      print_signed
    bl      print_enter
    ldr     r0, [r6, #12]
    bl      print_signed
    bl      print_space
    ldr     r0, [r6, #16]
    bl      print_signed
    bl      print_space
    ldr     r0, [r6, #20]
    bl      print_signed
    bl      print_enter
    ldr     r0, [r6, #24]
    bl      print_signed
    bl      print_space
    ldr     r0, [r6, #28]
    bl      print_signed
    bl      print_space
    ldr     r0, [r6, #32]
    bl      print_signed
    bl      print_enter
    bl      print_enter

    ldmfd   sp!, {r0-r5, r7-r12, pc}
    END