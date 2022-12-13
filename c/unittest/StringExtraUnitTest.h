#ifdef UNIT_TEST
#ifndef __STRING_EXTRA_UNIT_TEST__
#define __STRING_EXTRA_UNIT_TEST__
#include "../incps/macrosps.h"
#include "UnitTestBuilder.h"
#include "../incps/stringps.h"

#include "Increment.h"
TESTF(STRAPP) {
    char* Test = NULL;
    Test = strapp(Test, "hello");
    CSTREQ_TEST(Test, "hello");
    Test = strapp(Test, " phil!");
    CSTREQ_TEST(Test, "hello phil!");
}

#include "Increment.h"
TESTF(ISEMPTY) {
    char* Test = malloc(1);
    Test[0] = '\0';
    EQ_TEST(isempty(Test), true);
    Test = realloc(Test, 2);
    Test[1] = '\0';
    Test[0] = 'i';
    NEQ_TEST(isempty(Test), true);
}

#include "Increment.h"
TESTF(SUBSTRREP) {
    char Test[] = KDFT"slime"KDFT;
    substrrep(Test, KYEL);
    CSTREQ_TEST(Test, KYEL"slime"KDFT);
    substrrep(Test + 5, "gr");
    CSTREQ_TEST(Test, KYEL"grime"KDFT);
}

#endif
#endif
