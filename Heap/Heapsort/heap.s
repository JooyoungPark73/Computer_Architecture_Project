    AREA text, code

    IMPORT  print_char
    IMPORT  scan
    IMPORT  print
    IMPORT  print_input
    IMPORT  scan_loop
    IMPORT  print_loop
    IMPORT  scan_loop

    EXPORT  heap_init
    EXPORT  heap_input
    EXPORT  heap_sort


heap_init                       ; initialize heap property
    stmfd   sp!, {r1, lr}
    mov     r0, #0x000
    mov     r1, #0              ; this will be used below
    str     r1, [r0]            ; init 0x000 to 0, as there is no node
    ldmfd   sp!, {r1, pc}




heap_input                      ; this func include adding a node at the end of the tree
                                ; and heapify using bottom-up heap
    stmfd   sp!, {r1-r12, lr}
    mov     r1, #0x000
    ldr     r12, [r1]         ; r12 has heap size

    bl      print_input
    bl      scan_loop                ; input value to r0
    add     r12, r12, #1        ; increment r12
    str     r12, [r1]           ; update heap size
    mov     r1, r12, lsl#2      ;r1 = address of end of the heap
    str     r0, [r1]            ; save r0 at the end of the heap
    mov     r8, r12             ; r8 has current node index
    mov     r7, r8, lsl#2       ; r7 has current node address
heap_shift_up
    cmp     r8, #1             ; is this root node?
    beq     heap_input_exit     ; then return true
    mov     r9, r8, lsr#1       ; r9 = parent node index
    mov     r10, r9, lsl#2      ; r10 = mem location of parent node
    ldr     r11, [r7]           ; r11 = current node value
    ldr     r12, [r10]          ; r12 = parent node value
    cmp     r12, r11            ; compare parent node with current node
    bge     heap_input_exit     ; if parent >= currnet, retrun success
    str     r11, [r10]          ; otherwise
    str     r12, [r7]           ; swap node
    mov     r7, r10             ; set current node address to parent node address
    mov     r8, r9              ; set current node index to parent node index
    b       heap_shift_up

heap_input_exit
    ldmfd   sp!, {r1-r12, pc}





    ; as we keep heap property everytime we get input, array is now heap.
heap_sort
    stmfd   sp!, {r1-r12, lr}
    mov     r0, #0x000          ; will be used below
    ldr     r12, [r0]           ; r12 holds heap size
heap_swap_last_and_root
    cmp     r12, #1              ; if no element left
    beq     heap_sort_exit
    mov     r6, #0x0004          ; r6 = root node address
    ldr     r0, [r6]            ; r0 = root node value
    mov     r7, r12, lsl#2      ; r7 = last node address
    ldr     r1, [r7]            ; r1 = last node value
    str     r1, [r6]            ; swap
    str     r0, [r7]            ; two nodes
    sub     r12, r12, #1        ; now exclude last node, r1 is root node value
    mov     r10, #1             ; r10 = cursor, now pointing root
heap_shift_down
    cmp     r10, r12            ; is cursor in heap?
    bgt     heap_swap_last_and_root ; if not, go back to heap_sort
    mov     r5, r10, lsl#1      ; r5 = left child index
    add     r11, r5, #1        ; r11 = right child index
    mov     r6, r5, lsl#2      ; r6 = left child address
    mov     r7, r11, lsl#2      ; r7 = right child addresss
    mov     r10, r10, lsl#2     ; r10 = current node address
    ldr     r9, [r10]           ; r9 = current node value
    ldr     r2, [r6]            ; r2 = left child value
    ldr     r3, [r7]            ; r3 = right child valued
    cmp     r12, r5            ; is left child in heap?
    blt     heap_swap_last_and_root ; if not, exit
    cmp     r12, r11            ; is right child in heap?
    blt     make_last_heap      ; if right child is not in heap, left child is last value in heap
    cmp     r2, r3              ; if both exist, compare two child
    ble     heap_shift_down_1   ; if right child is bigger, branch
    cmp     r9, r2              ; else compare cursor and left child
    ble     heap_down_1         ; if left child > cursor, goto heap_down_1
    b       heap_swap_last_and_root ;if left child < cursor, right child < cursor, go to top
heap_shift_down_1
    cmp     r9, r3              ; compare cursor and right node
    ble     heap_down_2         ; if right child > cursor and left child < cursor, goto heap_down_2
    b       heap_swap_last_and_root ;if right child < cursor and left child < cursor



heap_down_1
    str     r9, [r6]            ; else swap
    str     r2, [r10]           ; current value and left value
    mov     r10, r6, lsr#2             ; update cursor to left child
    b       heap_shift_down

heap_down_2
    str     r9, [r6, #4]        ;swap cursor and right child node
    str     r3, [r10] 
    add     r6, r6, #4
    mov     r10, r6, lsr#2                ; update cursor to right child
    b       heap_shift_down

make_last_heap
    cmp     r9, r2              ; compare current node and left node
    bgt     heap_swap_last_and_root ;if current node > left node, go up
    str     r9, [r6]            ; else switch
    str     r2, [r10]
    b     heap_swap_last_and_root

heap_sort_exit
    ldmfd   sp!, {r1-r12, pc}
    END