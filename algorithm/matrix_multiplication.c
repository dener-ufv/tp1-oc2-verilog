#include <stdio.h>

#define N 2

int main() {

    int a[N][N], b[N][N], result[N][N];

    int i, j, k;
    for(i=0; i<N; i++) {
        for(int j=0; j<N; j++) {
            result[i][j] = 0;
            for(k=0; k<N; k++) {
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}