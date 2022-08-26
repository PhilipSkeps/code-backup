#include <stdio.h>
extern size_t __failed__;
extern size_t __total__;
extern char* __file_line__;

#ifndef __UNIT_TEST_BUILDER__
#define __UNIT_TEST_BUILDER__
#include <stdlib.h>
#include "UsefulMacros.h"
#include "stringExtra.h"
#define __INCREMENT__ 0
#define __LOCATION__ __FILE__ ": " STRINGIFY(__LINE__)

// MONEY MAKER / BUILDER
#define TESTF(TestName) \
    void TestName(); \
    void CONCATSYM(____func, __INCREMENT__)() { \
        printf("%sRunning Test: %s in File: %s%s\n",KCYN, #TestName, __FILE__, KDFT); \
        TestName(); \
        printf("%sExiting Test: %s%s\n",KCYN, #TestName, KDFT); \
    } void TestName()

// TESTING FUNCTIONS
size_t __failed__ = 0;
size_t __total__ = 0;
char* __file_line__ = NULL;

#define __UNIT_TEST_HELPER__ { \
            printf("%s( line: %d ) : PASSED%s\n", \
            KGRN, __LINE__, KDFT);  \
        } else { \
            printf("%s( line: %d ) : FAILED%s\n", \
            KRED, __LINE__, KDFT); \
            __file_line__ = strapp(__file_line__, __LOCATION__ "\n"); \
        }
#define EQ_TEST(x, y) if (x == y) __UNIT_TEST_HELPER__
#define NEQ_TEST(x, y) if (x != y) __UNIT_TEST_HELPER__
#define GT_TEST(x, y) if (x > y) __UNIT_TEST_HELPER__
#define LT_TEST(x, y) if (x < y) __UNIT_TEST_HELPER__
#define GTE_TEST(x, y) if (x >= y) __UNIT_TEST_HELPER__
#define LTE_TEST(x, y) if (x <= y) __UNIT_TEST_HELPER__
#define ARREQ_TEST(x, y) if (ARRAYSIZE(x) == ARRAYSIZE(y)) { \
        for (size_t i = 0; i < ARRAYSIZE(x); ++i) { \
            if (x[i] != y[i]) { \
                break; \
                printf("%s( line: %d ) : FAILED%s\n", \
                KRED, __LINE__, KDFT); \
                __file_line__ = strapp(__file_line__, __LOCATION__ "\n"); \
            } else if (i == (ARRAYSIZE(x)) - 1) { \
                printf("%s( line: %d ) : PASSED%s\n", \
                KGRN, __LINE__, KDFT);  \
            } \
        } \
    } else { \
        printf("%s( line: %d ) : FAILED%s\n", \
        KRED, __LINE__, KDFT); \
        __file_line__ = strapp(__file_line__, __LOCATION__ "\n"); \
    }
#define ARRNEQ_TEST(x, y) if (ARRAYSIZE(x) == ARRAYSIZE(y)) { \
        for (size_t i = 0; i < ARRAYSIZE(x); ++i) { \
            if (x[i] == y[i]) { \
                break; \
                printf("%s( line: %d ) : FAILED%s\n", \
                KRED, __LINE__, KDFT); \
                __file_line__ = strapp(__file_line__, __LOCATION__ "\n"); \
            } else if (i == (ARRAYSIZE(x)) - 1) { \
                printf("%s( line: %d ) : PASSED%s\n", \
                KGRN, __LINE__, KDFT);  \
            } \
        } \
    } else { \
        printf("%s( line: %d ) : PASSED%s\n", \
        KGRN, __LINE__, KDFT);  \
    }
#define CSTREQ_TEST(x, y) if (!strcmp(x, y)) { \
    printf("%s( line: %d ) : PASSED%s\n", \
    KGRN, __LINE__, KDFT);  \
    } else { \
        printf("%s( line: %d ) : FAILED%s\n", \
        KRED, __LINE__, KDFT); \
        __file_line__ = strapp(__file_line__, __LOCATION__ "\n"); \
    }
#define CSTRNEQ_TEST(x, y) if (strcmp(x, y)) { \
    printf("%s( line: %d ) : PASSED%s\n", \
    KGRN, __LINE__, KDFT);  \
    } else { \
        printf("%s( line: %d ) : FAILED%s\n", \
        KRED, __LINE__, KDFT); \
        __file_line__ = strapp(__file_line__, __LOCATION__ "\n"); \
    }
#endif