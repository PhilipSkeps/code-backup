#include <stdio.h>
#include <stdlib.h>

int main() {

    int * x = malloc(sizeof(int) * 2);

    x[2] = 2;
    printf("%s\n", "HelloWorld");
    return 0;
}