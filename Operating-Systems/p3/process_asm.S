.global dispatch, go
.extern ready_queue, pcb_running

go:
    b restore_context

dispatch:
    // disable interrupts
    msr DAIFSet, #0x2

    // save x1
    str x1, [sp, -8]!
    mrs x1, SP_EL0

    // subtract 16*17 from stack
    sub x1, x1, 272

    // copy registers to stack
    // store x0 and x1 first
    str x0, [x1]
    ldr x0, [sp]
    str x0, [x1]
    // store x2-x30
    stp x2, x3, [x1, 16]
    stp x4, x5, [x1, 32]
    stp x6, x7, [x1, 48]
    stp x8, x9, [x1, 64]
    stp x10, x11, [x1, 80]
    stp x12, x13, [x1, 96]
    stp x14, x15, [x1, 112]
    stp x16, x17, [x1, 128]
    stp x18, x19, [x1, 144]
    stp x20, x21, [x1, 160]
    stp x22, x23, [x1, 176]
    stp x24, x25, [x1, 192]
    stp x26, x27, [x1, 208]
    stp x28, x29, [x1, 224]
    str x30, [x1, 240]

    // save PSTATE to stack 
    mrs x0, SPSR_EL1
    str x0, [x1, 248]

    // interrupt return address to stack
    mrs x0, ELR_EL1
    str x0, [x1, 256]

    // store x1 value into pcb_running
    adr x2, pcb_running
    ldr x2, [x2]
    str x1, [x2]
    mov x1, x2

    // enqueue pcb_running
    adr x0, ready_queue 
    adr x2, pcb_running
    ldr x1, [x2]
    bl enqueue

restore_context:
    // dequeue process
    adr x0, ready_queue
    bl dequeue

    // move return value of dequeue into pcb_running
    adr x1, pcb_running
    str x0, [x1]
    // read returned value and store into sp register
    ldr x2, [x0]
    mov x1, x2

    // restore PSTATE
    ldr x0, [x1, 248]
    msr SPSR_EL1, x0

    // restore interrupt return address
    ldr x0, [x1, 256]
    msr ELR_EL1, x0

    // Store new stack top into system exception register
    mov x0, x1
    add x0, x0, 272
    msr SP_EL0, x0

    // restore registers
    ldp x2, x3, [x1, 16]
    ldp x4, x5, [x1, 32]
    ldp x6, x7, [x1, 48]
    ldp x8, x9, [x1, 64]
    ldp x10, x11, [x1, 80]
    ldp x12, x13, [x1, 96]
    ldp x14, x15, [x1, 112]
    ldp x16, x17, [x1, 128]
    ldp x18, x19, [x1, 144]
    ldp x20, x21, [x1, 160]
    ldp x22, x23, [x1, 176]
    ldp x24, x25, [x1, 192]
    ldp x26, x27, [x1, 208]
    ldp x28, x29, [x1, 224]

    // save x1 and x2 before clear_timer
    stp x0, x1, [sp, -16]!
    bl clear_timer

    // restore x30 and original x0 and x1
    ldp x0, x1, [sp], 16
    ldr x30, [x1, 240]

    // restore x0 and x1
    ldp x0, x1, [x1]

    // enable interrupts
    msr DAIFClr, #0x2

    eret