#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include "../incps/macrosps.h"
#include "../incps/stringps.h"
#include "../incps/stdiops.h"
#define SIZE 25


// actions
typedef unsigned short pos;

enum GAMEFLAG {WIN = 'w', TIE = 't', CONTINUE = 'c'};

enum CHECKTYPE {DIAGONAL1, DIAGONAL2, ROW, COL};

enum ACTIONS {LEFT = 'a', RIGHT = 'd', UP = 'w', DOWN = 's' , PLACE = ' '};

char** initBoard(size_t size);
void prettyBoard(char** BOARD, size_t size);
char getUserAction();
enum GAMEFLAG act(char Action, char** BOARD, size_t size);
enum GAMEFLAG checkWin(char** BOARD, size_t size, pos Position);
void destructBoard(char** BOARD, size_t size);

pos Position = 0;

int main() {
    OLOG(game);
    TODO(use ncursors library instead of ansi)
    TODO(Clean up code)
    printf("\n%s %s\n%s %s\n%s\n", "w -> move cursor up", "s -> move cursor down",
                        "a -> move cursor left", "d -> move cursor right",
                        "space bar -> place a piece");
    char** BOARD = initBoard(SIZE);

    enum GAMEFLAG GameFlag = CONTINUE;
    char UserChoice = '\0';
    while(GameFlag == CONTINUE) {
        prettyBoard(BOARD, SIZE);
        UserChoice = getUserAction();
        printf("%s", "\033[A\r\033[2K\r"); // remove stdin print
        printf("\033[%dA\033[2K\r\033[%dB\r", (int) (sqrt(SIZE) + 4), (int) (sqrt(SIZE) + 4)); // remove error message if present
        fflush(stdout);
        GameFlag = act(UserChoice, BOARD, SIZE);
        printf("\033[%dA", (int) (sqrt(SIZE))); // print new board over old board
        fflush(stdout);
    }

    prettyBoard(BOARD, SIZE);
    if (GameFlag == WIN) {
        printf("\033[%dA\033[2K\r%s%s%s\033[%dB\r", (int) (sqrt(SIZE) + 4), KGRN, "You Won!", KDFT, (int) (sqrt(SIZE) + 4));
    } else {
        printf("\033[%dA\033[2K\r%s%s%s\033[%dB\r", (int) (sqrt(SIZE) + 4), KCYN, "Tie!", KDFT, (int) (sqrt(SIZE) + 4));
    }

    CLOG
    destructBoard(BOARD, SIZE);
    return 0;
}

char** initBoard(size_t size) {
    char** BOARD = malloc(size * sizeof(char*));
    for (size_t i = 0; i < size; ++i) {
        BOARD[i] = malloc(sizeof(KDFT"*"KDFT));
        if (i == 0) {
            strcpy(BOARD[i], KYEL"*"KYEL);
        } else {
            strcpy(BOARD[i], KDFT"*"KDFT);
        }
    }
    return BOARD;
}

void prettyBoard(char** BOARD, size_t size) {
    int Rows = sqrt(size);
    for(size_t i = 0; i < Rows; i++) {
        for (size_t j = 0; j < Rows; j++) {
            printf("%s ", BOARD[j + Rows * i]);
            WFLOG("%s ", BOARD[j + Rows * i])
        }
        printf("%c", '\n');
        WFLOG("%c", '\n');
    }
}

char getUserAction() {
    char UserAction = getchar();
    if (UserAction == '\n') {
        printf("%s", "\033[A\r");
    }
    WFLOG("%c\n", UserAction);
    flushstdin(); // empty the rest of the stdin
    return UserAction;
}

enum GAMEFLAG act(char Action, char** BOARD, size_t size) {
    static size_t i = 0;
    size_t Rows = sqrt(size);
    switch(Action) {
        case LEFT:
            substrrep(BOARD[Position], KDFT); // perform a replace on the previous yellow
            if (!(Position % Rows)) {
                Position+=(Rows-1); // if the user is at the end force a wrap back
            } else {
                --Position; // otherwise moving left is the same as decrementing
            }
            substrrep(BOARD[Position], KYEL); // perform a replace on the current default
            break;
        case RIGHT:
            substrrep(BOARD[Position], KDFT); // perform a replace on the previous yellow
            if (Position % 3 == (Rows-1)) { 
                Position-=(Rows - 1); // if the user is at the end force a wrap back
            } else {
                ++Position; // otherwise moving right is the same as incrementing
            }
            substrrep(BOARD[Position], KYEL); // perform a replace on the current default
            break;
        case UP:
            substrrep(BOARD[Position], KDFT); // perform a replace on the previous yellow
            if (Position < Rows) {
                Position+=(size-Rows); // if the user is at the end force a wrap back
            } else {
                Position-=Rows; // otherwise moving up is same as decrementing by 3
            }
            substrrep(BOARD[Position], KYEL); // perform a replace on the current default
            break;
        case DOWN:
            substrrep(BOARD[Position], KDFT); // perform a replace on the previous yellow
            if (Position > (size - 1 - Rows)) {
                Position-=(size-Rows);
            } else {
                Position+=Rows;
            }
            substrrep(BOARD[Position], KYEL); // perform a replace on the current default
            break;
        case PLACE:
            if (BOARD[Position][5] != 'o' && BOARD[Position][5] != 'x') { // check for piece placement
                if (i % 2) { // alternate who plays
                    BOARD[Position][5] = 'o';
                } else {
                    BOARD[Position][5] = 'x'; // x goes first
                }

                i++;

                if (checkWin(BOARD, size, Position) == 'w') {
                    return WIN;
                } else if (i == size) {
                    return TIE;
                } else {
                    return CONTINUE;
                }
            }
            break;
        default:
            fprintf(stderr, "%s\033[%ldA\033[2K\r%s\033[%ldB\r%s", KRED, Rows + 4, "Error: No valid option was given", Rows + 4, KDFT);
            break;
    }
    WFLOG("%s:%d\n", "Position", Position);
    return CONTINUE;
}

void nextPos(pos* Position, enum CHECKTYPE CheckType, size_t size) {
    size_t Rows = sqrt(size);
    switch(CheckType) {
        case DIAGONAL1:
            if ((*Position) == size - 1) {
                (*Position)=0;
            } else {
                (*Position)+=(Rows + 1);
            }
            WFLOG("%s\n", "HERE1");
            break;
        case DIAGONAL2:
            if ((*Position) == (size - Rows)) {
                (*Position)=(Rows-1);
            } else {
                (*Position)+=(Rows-1);
            }
            WFLOG("%s\n", "HERE2");
            break;
        case ROW:
            if (!((*Position) % Rows)) {
                (*Position)+=(Rows-1);
            } else {
                (*Position)--;
            }
            WFLOG("%s\n", "HERE3");
            break;
        case COL:
            if ((*Position) > (size - Rows - 1)) {
                (*Position)-=(size-Rows);
            } else {
                (*Position)+=Rows;
            }
            WFLOG("%s\n", "HERE4");
            break;
        default:
            break;
    }
}

enum GAMEFLAG checkWin(char** BOARD, size_t size, pos Position) {
    size_t Rows = sqrt(size);
    char Player = BOARD[Position][5];
    for (size_t j = 0; j < 4; j++) {
        int count = 0;
        pos checkPosition = Position;
        for (size_t i = 0; i < (Rows - 1); i++) {
            nextPos(&checkPosition, j, size);
            if (checkPosition > (size - 1)) 
                break;
            WFLOG("%s%ld%s%d\n", "Type: ", j, " Check position: ", checkPosition)
            if ((BOARD[checkPosition][5] == Player)) {
                WFLOG("%s\n", "Match");
                count++; // only a winner if one of these evaluates to sqrt(BOARD size) - 1
            } else {
                WFLOG("%s\n", "No Match");
            }
        }
        if (count == (Rows - 1)) {
            return WIN;
        }
    }
    return CONTINUE;
}

void destructBoard(char** BOARD, size_t size) {
    for (size_t i = 0; i < size; i++) {
        free(BOARD[i]);
    }
    free(BOARD);
}