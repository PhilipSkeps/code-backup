#ifdef UNIT_TEST
#ifndef __UNIT_TEST_DRIVER__
#define __UNIT_TEST_DRIVER__
#include "macrosps.h"
#include "../incps/stringps.h"

extern char* __file_line__;
extern size_t __failed__;
extern size_t __total__;

void ____loop_wrapper() {
    #define LOOP_START 1
    #define LOOP_MACRO(x) CONCATSYM(____func, x)();
    #define LOOP_END __INCREMENT__ + 1
    #include "PreProcLoop.h"
}
#define main(args...) OldMain(##args); \
    int main(##args) { \
        printf("%s###############################\n" \ 
               "~~~~~Entering Testing Mode~~~~~\n" \
               "###############################\n%s", KYEL, KDFT); \
        ____loop_wrapper(); \
        if (__file_line__ != NULL) { \
            printf("%s###############################\n" \
                     "~~~~~~~~~Tests Failed:~~~~~~~~~\n%s" \
                     "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" \
                     "###############################%s\n", KRED, __file_line__, KDFT); \
        } else { \
            printf("%s###############################\n" \
                     "~~~~~~~All Tests Passed~~~~~~~~\n" \
                     "###############################%s\n", KGRN, KDFT); \
        } \
        free(__file_line__); \
        TODO(FIX HACK WHERE I INLCUDE THE FILE FOR EVERY UNIT TEST TO FORCE INCREMENT); \
        return -1; \
    } int OldMain(##args)    
#endif
#endif