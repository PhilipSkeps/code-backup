#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
#include <ncurses.h>
#include <pthread.h>
#include <math.h>

#include "../incps/macrosps.h"

#ifdef WIN32
    #include <dos.h>
#else
    #include <unistd.h>
#endif

#define SIZE 100
#define BODYSEG 'O'
#define HEAD '+'

typedef enum Direction { L = 'a', R = 'd', U = 'w', D = 's' } Direc;

int main() {

    srand(time(NULL)); // use time to get random seed for the game 
    initscr(); // initialize curses
    keypad(stdscr, TRUE); // allow for F1-F12 and arrow keys
    cbreak(); // make characters available as soon as they are typed no buffering
    noecho(); // do not write back any characters when using getch()

    // initialize player and score
    volatile Direc* ChosenDirec = malloc(1);
    *ChosenDirec = R;
    unsigned char Score = 0;
    unsigned char* Snake = malloc(1 * sizeof(unsigned char));
    *Snake = rand() % 100;

    // create board and set player
    char Board[SIZE];
    memset(Board, '*', SIZE);
    Board[Snake[0]] = HEAD;

    // set up async environment THIS COULD BE HORRIBLY WRONG AND CAUSE WEIRD RACE CONDITIONS
    pthread_t thread_id;
    pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);
    pthread_create(&thread_id, NULL, (void *) readKey, (void *) ChosenDirec);

    while(!lose(Board, Snake[ARRAYSIZE(Snake) - 1])) {
        update(Board, ChosenDirec, Snake);
        sleep(0.25);
        refresh(); // print all changes to terminal
    }

    pthread_cancel(thread_id); // kill thread
    endwin(); // end curses mode

    free(ChosenDirec);
    free(Snake);

    return EXIT_SUCCESS;

}

// wait for key to be pressed and change it in heap 
// but use this function on another thread to prevent the halt of main job
void readKey(void * ChosenDirec) {
    while(TRUE) {
        *((Direc *) ChosenDirec) = getch();
    }
}

void update(char Board[SIZE], Direc *ChosenDirec, unsigned char* Snake) {
    
    TODO(Make sure snake does not double up)
    static Direc PrevChosenDirec;
    char advanceVal = calcAdvanceVal(ChosenDirec, Snake);

    memcpy(Snake, Snake + 1, ARRAYSIZE(Snake) - 2 );
    Snake[ARRAYSIZE(Snake) - 1] = Snake[ARRAYSIZE(Snake) - 2] + advanceVal;

    if (Board[Snake[ARRAYSIZE(Snake) - 1]] == '@') {
        Snake = realloc(Snake, ARRAYSIZE(Snake) + 1);
        Snake[ARRAYSIZE(Snake) - 1] = Snake[ARRAYSIZE(Snake) - 2] + advanceVal;
    }

    PrevChosenDirec = *ChosenDirec;
}

char calcAdvanceVal(Direc *ChosenDirec, unsigned char* Snake) {

    char advanceVal = 0;
    
    switch(*ChosenDirec) {
        case L:

            if (Snake[ARRAYSIZE(Snake) - 1] % (int) sqrt(SIZE) == 0) { // left edge mode
                advanceVal = sqrt(SIZE) - 1;
            } else { // normal mode
                advanceVal = -1;
            }

            break;

        case R:
            
            if (Snake[ARRAYSIZE(Snake) - 1] % (int) sqrt(SIZE) == sqrt(SIZE) - 1) { // right edge mode
                advanceVal = -(sqrt(SIZE) - 1);
            } else { // normal mode
                advanceVal = 1;
            }

            break;

        case U:
            
            if (Snake[ARRAYSIZE(Snake) - 1] < (int) sqrt(SIZE)) { // upper edge mode
                advanceVal = SIZE - sqrt(SIZE);
            } else { // normal mode
                advanceVal = -sqrt(SIZE);
            }

            break;

        case D:

            if (Snake[ARRAYSIZE(Snake) - 1] > (int) (SIZE - sqrt(SIZE) - 1)) { // left edge mode
                advanceVal = -(SIZE - sqrt(SIZE));
            } else { // normal mode
                advanceVal = sqrt(SIZE);
            }

            break;


        default:
            break;
    };
}

bool lose(char Board[SIZE], unsigned char Cursor) {

}