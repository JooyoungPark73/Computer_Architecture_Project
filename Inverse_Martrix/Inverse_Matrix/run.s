    AREA text, CODE
    ENTRY

    IMPORT  input_matrix
    IMPORT  calc_transposed
    IMPORT  calc_determinant
    IMPORT  print_space
    IMPORT  print_enter
    IMPORT  print
    IMPORT  det_trans_calc
    IMPORT  print_inverse

start
    mov     r4, #0x0            ; offset  for input value
    mov     r5, #0x40           ; offset for transposed and calculated
    mov     r6, #0x80           ; offset for inverse matrix
    bl      input_matrix
    bl      calc_transposed
    bl      calc_determinant            ; r12 = det (reserved)
    cmp     r12, #0                     ; if det = 0
    beq     inverse_invalid              ; return error
    bl      det_trans_calc
    bl      print_inverse
    b       start



inverse_invalid
    adr     r0, inverseerror_print
    bl      print
    bl      print_enter
    bl      print_enter
    b       start
inverseerror_print
    dcb     " determinant = 0, no inverse matirx", 0
    END