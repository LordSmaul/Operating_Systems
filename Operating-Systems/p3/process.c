#include "process.h"

// stack variables
#define MAX_STACKS 10
uint64_t stacks[MAX_STACKS][1024];
uint32_t next_stack = 0;
// static array to help with PCB initialization
PCB_t pcbs[MAX_STACKS];
uint32_t pcbs_index = 0;
// other variables
PCB_Q_t ready_queue;
int next_pid = 0;

// allocates stack
uint64_t* alloc_stack() {
    if (next_stack == MAX_STACKS) { return NULL; }

    return stacks[next_stack++];
}

// allocates new pcb structure
PCB_t* alloc_pcb() {
    // adds PCB to static array
    if (pcbs_index > MAX_STACKS) { return NULL; }
    PCB_t* new_pcb = &pcbs[pcbs_index];
    pcbs_index++;
    new_pcb->sp = 0;
    new_pcb->pid = 0;
    new_pcb->next = NULL;
    return new_pcb;
}

// create process
int create_process(int (*code_address)()) {
    
    uint64_t* stackptr = alloc_stack();
    if (stackptr == NULL) { return -1; }

    uint64_t* sp = stackptr + 1024;

    // set general purpose registers all to 0
    for (int i = 0; i <= 32; i++) {
        sp--;
        *sp = 0;
    }

    // set sp+32 to code_address (stack pointer)
    *(sp + 32) = (uint64_t)code_address;

    // allocate new PCB
    PCB_t* pcb = alloc_pcb();
    if (pcb == NULL) { return -1; }

    pcb->sp = (uint64_t)sp;
    pcb->pid = next_pid++;

    // add PCB to queue
    enqueue(&ready_queue, pcb);

    return 0;
}