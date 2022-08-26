#ifndef __STRING_EXTRA__
#define __STRING_EXTRA__
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "UsefulMacros.h"

static inline char* strapp(char* String1, const char* String2) {
    TODO(Add a bunch of preventive meaures for NULL pointers);
    size_t InitLen = 0;
    if (String1 != NULL)
        InitLen = strlen(String1);

    if (String2 == NULL) 
        return String1;

    if ((String1 = (char *) realloc(String1, InitLen + strlen(String2) + 1)) != NULL){
        strcpy(String1 + InitLen, String2);
    } else {
        fprintf(stderr,"%s:%s\n", __FILE__, "strapp: realloc failed!\n");
    }

    return String1;
}

static inline bool isempty(char* String) {
    TODO(Add a bunch of preventive meaures for NULL pointers);
    return strlen(String) == 0;
}

static inline void substrrep(char* String1, char* String2) {
    TODO(Add a bunch of preventive meaures for NULL pointers);
    size_t String2Len = strlen(String2);
    if (strlen(String1) < String2Len) {
        fprintf(stderr,"%s:%s\n", __FILE__, "substrrep: string being modified is smaller in size then second string!\n");
        return;
    }
    for (size_t i = 0; i < String2Len; i++) {
        DEBUG_PRINT("%c %c\n", *String1, String2[i]);
        *String1 = String2[i];
        String1++;
    }
}

#endif // end of __STRING_EXTRA__