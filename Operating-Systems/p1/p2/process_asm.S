.global dispatch, go
.extern ready_queue, pcb_running

go:
    b restore_context

dispatch:
    sub sp, sp, 256             // subtract 16*16 from stack

    stp x0, x1, [sp]            // copy registers to stack
    stp x2, x3, [sp, 16]
    stp x4, x5, [sp, 32]
    stp x6, x7, [sp, 48]
    stp x8, x9, [sp, 64]
    stp x10, x11, [sp, 80]
    stp x12, x13, [sp, 96]
    stp x14, x15, [sp, 112]
    stp x16, x17, [sp, 128]
    stp x18, x19, [sp, 144]
    stp x20, x21, [sp, 160]
    stp x22, x23, [sp, 176]
    stp x24, x25, [sp, 192]
    stp x26, x27, [sp, 208]
    stp x28, x29, [sp, 224]
    str x30, [sp, 240]

    mrs x0, SPSR_EL1            // save PSTATE to stack 
    str x0, [sp, 248]

    adr x1, pcb_running         // store sp value into pcb_running
    ldr x1, [x1]
    mov x4, sp
    str x4, [x1]

    adr x1, ready_queue         // enqueue pcb_running 
    mov x0, x1
    adr x2, pcb_running
    ldr x1, [x2]
    bl enqueue

restore_context:
    adr x1, ready_queue         // dequeue process
    mov x0, x1
    bl dequeue

    adr x1, pcb_running         // move return value of dequeue into pcb_running
    str x0, [x1]
    ldr x2, [x0]                // read returned value and store into sp register
    mov sp, x2

    ldr x0, [sp, 248]           // restore PSTATE
    msr SPSR_EL1, x0

    ldp x0, x1, [sp]            // restore registers
    ldp x2, x3, [sp, 16]
    ldp x4, x5, [sp, 32]
    ldp x6, x7, [sp, 48]
    ldp x8, x9, [sp, 64]
    ldp x10, x11, [sp, 80]
    ldp x12, x13, [sp, 96]
    ldp x14, x15, [sp, 112]
    ldp x16, x17, [sp, 128]
    ldp x18, x19, [sp, 144]
    ldp x20, x21, [sp, 160]
    ldp x22, x23, [sp, 176]
    ldp x24, x25, [sp, 192]
    ldp x26, x27, [sp, 208]
    ldp x28, x29, [sp, 224]
    ldr x30, [sp, 240]

    add sp, sp, 256             // add 16*16 to stack

    ret