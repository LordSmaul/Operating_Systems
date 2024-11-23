.global box
box:
 
    // standard entry: save link and stack frame registers
    //    load the stack frame with the pointer to current frame
    stp     x29, x30, [sp, -16]!

    // Save the arguments.  Called functions may overwrite x0-x3
    sub     sp, sp, 32
    stp     x0, x1, [sp]
    stp     x2, x3, [sp, 16]

    // sr in w0, sc in w1, er int w2, ec in w3
    
    // Make sure the argument are valid
    bl      _box_check_box_
    cmp     w0, 0
    bne     _box_error_
 
    // draw the corners
    ldp     x0, x1, [sp]
    ldp     x2, x3, [sp, 16]
    bl      _box_draw_corners_

    // draw the top and bottom
    ldp     x0, x1, [sp]
    ldp     x2, x3, [sp, 16]
    bl      _box_draw_top_bottom_

    // draw left and right sides
    ldp     x0, x1, [sp]
    ldp     x2, x3, [sp, 16]
    bl      _box_draw_right_left_

    // exit program
    mov     w0, 0
    b       _box_exit_

_box_error_:
    mov     w0, 1

_box_exit_:
    add     sp, sp, 32   // pop save arg regs

    ldp     x29, x30, [sp], 16
    ret

_box_check_box_:
    cmp w2, height
    blo _box_check_error_
    cmp w3, width
    blo _box_check_error_
    cmp w2, w0
    bls _box_check_error_
    cmp w3, w1
    bls _box_check_error_

    mov w0, 0
    b _box_check_end_

    _box_check_error_:
    mov w0, 1

    _box_check_end_:
    ret

_box_draw_corners_:     // draw corners of box
    str w29, [x8]       // saving stack pointers (they were getting overwritten sometimes)
    str w30, [x9]

    adr x3, corner      // saving corner value
    ldr w2, [x3]        // position is already fixed for this one
    bl putc_to

    ldr w0, [sp]        // corner at (sr, ec)
    ldr w1, [sp, 24]
    adr x3, corner
    ldr w2, [x3]
    bl putc_to

    ldr w0, [sp, 16]    // corner at (er, sc)
    ldr w1, [sp, 8]
    adr x3, corner
    ldr w2, [x3]
    bl putc_to

    ldr w0, [sp, 16]    // corner at (er, ec)
    ldr w1, [sp, 24]
    adr x3, corner
    ldr w2, [x3]
    bl putc_to

    ldr w29, [x8]      // loading stack pointers back after function call
    ldr w30, [x9]
    ret

_box_draw_top_bottom_:  // draw top and bottom of box
    str w29, [x8]       // saving stack pointers
    str w30, [x9]
    ldr x10, [sp, 8]    // saving initial values for next function
    ldr x11, [sp, 24] 

    ldr w0, [sp, 8]     // incrementing start_column
    add w0, w0, 1
    str w0, [sp, 8]
    ldr w0, [sp, 24]    // decrementing end_column
    sub w0, w0, 1
    str w0, [sp, 24]

    loop_1:
    ldr w0, [sp]        // print top
    ldr w1, [sp, 8]
    adr x2, side_1
    ldr w2, [x2]
    bl putc_to

    ldr w0, [sp, 16]    // print bottom
    ldr w1, [sp, 8]
    adr x2, side_1
    ldr w2, [x2]
    bl putc_to

    ldr w0, [sp, 8]     // increment start_column
    add w0, w0, 1
    str w0, [sp, 8]

    ldr w0, [sp, 8]     // check if it's hit a corner
    ldr w1, [sp, 24]
    cmp w0, w1
    bhi loop_end_1
    b loop_1

    loop_end_1:         // loading stack pointers
    ldr w29, [x8]
    ldr w30, [x9]
    str w10, [sp, 8]    // re-saving initial values back into stack
    str w11, [sp, 24]
    ret

_box_draw_right_left_:  // draw sides of the box
    str w29, [x8]       // saving stack pointers
    str w30, [x9]

    ldr w0, [sp]        // increment start_row
    add w0, w0, 1
    str w0, [sp]
    ldr w0, [sp, 16]    // decrement end_row
    sub w0, w0, 1
    str w0, [sp, 16]

    loop_2:
    ldr w0, [sp]        // print left side
    ldr w1, [sp, 8]
    adr x2, side_2
    ldr w2, [x2]
    bl putc_to

    ldr w0, [sp]        // print right side
    ldr w1, [sp, 24]
    adr x2, side_2
    ldr w2, [x2]
    bl putc_to

    ldr w0, [sp]        // increment start_row
    add w0, w0, 1
    str w0, [sp]

    ldr w0, [sp]        // check if it's hit a corner
    ldr w1, [sp, 16]
    cmp w0, w1
    bhi loop_end_2
    b loop_2

    loop_end_2:         // loading stack pointers
    ldr w29, [x8]
    ldr w30, [x9]
    ret

.section .data
height: .int term_txtheight
width: .int term_txtwidth
corner: .byte '+'
side_1: .byte '-'
side_2: .byte '|'