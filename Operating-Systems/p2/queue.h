#ifndef QUEUE_H
#define QUEUE_H
#include <stdio.h>
#include <stdint.h>

// process control block structure
struct pcb {
    uint64_t sp;
    uint32_t pid;
    struct pcb *next;
};
typedef struct pcb PCB_t;

// process queue structure
struct pcb_q {
    PCB_t *head;
    PCB_t *tail;
};
typedef struct pcb_q PCB_Q_t;

void enqueue(PCB_Q_t *q, PCB_t *pcb);
PCB_t* dequeue(PCB_Q_t *q);

#endif