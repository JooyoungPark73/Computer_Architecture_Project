    AREA text, code

    ENTRY       ; this is 'main'

    IMPORT  print_char
    IMPORT  print
    IMPORT  heap_init
    IMPORT  heap_input
    IMPORT  heap_sort
    IMPORT  print_loop
    EXPORT  print_input

start
    bl      heap_init
input_heap
    bl      heap_input
sort_heap
    bl      heap_sort
    bl      print_heap
    b       input_heap

print_sorted
    stmfd   sp!, {r4-r12, lr}
    adr     r0, sortedvalue_print
    bl      print
    ldmfd   sp!, {r4-r12, pc}


sortedvalue_print
    dcb     "    Sorted : ", 0


print_heap
    mov     r0, #32
    bl      print_char
    bl      print_sorted
    mov     r1, #0x00
    ldr     r3, [r1]            ; r3 = number of nodes
    ldr     r2, [r1]            ; r2 = count remaining loop
print_pop_loop
    mov     r4, r2, lsl#2       ; r4 = r2 address
    ldr     r0, [r4]            ; r0 = r4 value
    mov     r5, r3, lsl#3       ; r5 = add of last node
    sub     r5, r5, r4          
    add     r5, r5, #4          ; r5 = 2*r5 - r4 + 4
    str     r0, [r5]            ; store it
    bl      print_loop
    mov     r0, #32
    bl      print_char          ; print space
    cmp     r2, #1              ; compare number of node and loop time
    beq     restore
    sub     r2, r2, #1          ; decrement loop time
    bl      print_pop_loop

restore							; restore heap property by flipping
    ldr     r3, [r1]            ; r3 = number of node
    mov     r3, r3, lsl#2       ; r3 = last node address
    mov     r4, #0
    mov     r8, #0
restore_loop
    add     r4, r4, #4
    ldr     r6, [r4]
    ldr     r7, [r3, r4]
    str     r8, [r3, r4]
    str     r7, [r4]
    cmp     r4, r3
    beq     exit
    bl restore_loop
    
exit
    mov     r0, #10
    bl      print_char
    b       input_heap

print_input
    stmfd   sp!, {r4-r12, lr}
    adr     r0, inputvalue_print
    bl      print
    ldmfd   sp!, {r4-r12, pc}

inputvalue_print
    dcb     "Input: ", 0

    END