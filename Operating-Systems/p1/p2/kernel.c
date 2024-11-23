#include "libos.h"
#include "process.h"

PCB_t *pcb_running;
int box(unsigned int srow, unsigned int scol, unsigned int erow, unsigned int ecol);
void dispatch();
void go();

// clear screen within number range
int clear_scr(int start_row, int start_col, int width, int height) {
    for (int i = start_row; i < width; i++) {
        for (int j = start_col; j < height; j++) {
            putc_to(i, j, ' ');
        }
    }
    return 0;
}

// processes
int p1() {
    int num = 0;
    char message[] = "Process 1: 0";
    box(9, 23, 11, 39);

    while (1 < 2) {
        print_to(10, 25, message);
        char c_num = num + '0';
        message[11] = c_num;
        num++;

        if (num > 9) {
            num = 0;
        }
        dispatch();
    }

    return 1;
}

int p2() {
    int num = 0;
    char message[] = "Process 2: 0";
    box(13, 23, 15, 39);

    while (1 < 2) {
        print_to(14, 25, message);
        char c_num = num + '0';
        message[11] = c_num;
        num++;

        if (num > 9) {
            num = 0;
        }
        dispatch();
    }

    return 2;
}

int p3() {
    int num = 0;
    char message[] = "Process 3: 0";
    box(9, 49, 11, 65);

    while (1 < 2) {
        print_to(10, 51, message);
        char c_num = num + '0';
        message[11] = c_num;
        num++;

        if (num > 9) {
            num = 0;
        }
        dispatch();
    }

    return 3;
}

int p4() {
    int num = 0;
    char message[] = "Process 4: 0";
    box(13, 49, 15, 65);

    while (1 < 2) {
        print_to(14, 51, message);
        char c_num = num + '0';
        message[11] = c_num;
        num++;

        if (num > 9) {
            num = 0;
        }
        dispatch();
    }

    return 4;
}

int main() {

    clear_scr(100, 100, 100, 100);
    print_to(0, 0, "Running processes");
    extern PCB_Q_t ready_queue;
    ready_queue.head = ready_queue.tail = NULL;

    // create processes
    int retval = create_process(p1);
    if (retval != 0) {
        print_to(1, 1, "ERROR with create_process(p1)");
    }
    retval = create_process(p2);
    if (retval != 0) {
        print_to(2, 2, "ERROR with create_process(p2)");
    }
    retval = create_process(p3);
    if (retval != 0) {
        print_to(3, 3, "ERROR with create_process(p3)");
    }
    retval = create_process(p4);
    if (retval != 0) {
        print_to(4, 4, "ERROR with create_process(p4)");
    }

    // run processes
    go();

    return 0;
}