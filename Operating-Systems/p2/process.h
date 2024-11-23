#ifndef PROCESS_H
#define PROCESS_H
#include "queue.h"

uint64_t* alloc_stack();
PCB_t* alloc_pcb();
int create_process(int (*code_address)());

#endif