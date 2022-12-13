#include <stdio.h>

void flushstdin() {
    char c;
    while((c = getchar()) != '\n' && c != EOF) {}
}