#include <stdio.h>
#include "libos.h"

int box(unsigned int srow, unsigned int scol, unsigned int erow, unsigned int ecol);

int clear_scr(int start_row, int start_col, int width, int height) {
    for (int i = start_row; i < width; i++) {
        for (int j = start_col; j < height; j++) {
            putc_to(i, j, ' ');
        }
    }
    return 0;
}

int main() {

    clear_scr(21, 49, 27, 79);
    box(21, 49, 27, 79);
    print_to(24, 59, "Hello world");

    return 0;
}
