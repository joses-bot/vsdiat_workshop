#include <stdio.h>

int main() {
    int array1[4][4]  = {{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}, {13, 14, 15, 16}};
    int array2[4][4]  = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
    int mresult[4][4] = {{0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}};
    int ii,jj,kk;

    for (ii = 0; ii < 4; ii++) {
        for (jj = 0; jj < 4; jj++) {
            for (kk = 0; kk < 4; kk++) {
                mresult[ii][jj] = mresult[ii][jj] + array1[ii][kk] * array2[kk][jj];
            }
        }
    }

    printf("Matrix Mult Result:\n");
    for (ii = 0; ii < 4; ii++) {
        for (jj = 0; jj < 4; jj++) {
            printf("%d ", mresult[ii][jj]);
        }
        printf("\n");
    }

    return 0;
}

