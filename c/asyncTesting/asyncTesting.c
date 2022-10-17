#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
#include <ncurses.h>
#include <pthread.h>

void readKey(void* Key);

int main() {

    volatile char* Key = malloc(1);

    initscr(); // initialize curses
    keypad(stdscr, TRUE); // allow for F1-F12 and arrow keys
    cbreak(); // make characters available as soon as they are typed no buffering
    noecho(); // do not write back any characters when using getch()

    pthread_t thread_id;
    pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);
    pthread_create(&thread_id, NULL, (void *) readKey, (void *) Key);

    while(*Key != 'e') {
        if (*Key == 'a') {
            printw("%s\n", "ball out");
            *Key = 0;
            refresh();
        } else if (*Key == 'e'){
            printw("%s\n", "slick");
        }
    }

    pthread_cancel(thread_id); // kill thread
    endwin(); // end curses mode

    free((void *) Key);

    return EXIT_SUCCESS;
}

void readKey(void* Key) {
    while(true) {
        *( (char *) Key) = getch();
    }
}