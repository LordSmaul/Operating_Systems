#include "queue.h"

// enqueue function
void enqueue(PCB_Q_t *q, PCB_t *pcb) {
    if (q->tail) {
        q->tail->next = pcb;
    }
    else {
        q->head = pcb;
    }
    q->tail = pcb;
    pcb->next = NULL;
}

// dequeue function
PCB_t* dequeue(PCB_Q_t *q) {
    if (q->head == NULL) { return NULL; }

    PCB_t *pcb = q->head;
    q->head = pcb->next;

    if (q->head == NULL) { q->tail = NULL; }

    return pcb;
}