#ifndef __STRING_EXTRA_UNIT_TEST__
#define __STRING_EXTRA_UNIT_TEST__
#include "../IncPS/UsefulMacros.h"
#include "../IncPS/UnitTestBuilder.h"
#include "../hashMap/hashMap.h"

#include "../IncPS/Increment.h"
TESTF(INITMAP) {

    hash_map * Test1 = initMap(0);
    EQ_TEST(Test1->prindx, 0);
    free(Test1);

    hash_map * Test2 = initMap(24);
    EQ_TEST(Test2->prindx, 47);
    free(Test2);

}

#include "../IncPS/Increment.h"
TESTF(SETDATA__GETDATA) {

    hash_map * Test1 = initMap(0);

    char * TestData1 = (char *) malloc(sizeof(char));
    *TestData1 = 'a';

    float TestData2_val = 0.999888;
    float * TestData2 = &TestData2_val;

    setData(1,(void*) TestData1, Test1);
    setData(10,(void*) TestData2, Test1);

    EQ_TEST(*((char *) getData(1, Test1)), 'a');
    EQ_TEST(*((float *) getData(10, Test1)), 0.999888);

    delMap(Test1);

    hash_map * Test2 = initMap(0);

    for (size_t i = 0; i < 300; ++i) {
        int * Data = (int *) malloc(sizeof(int));
        * Data = i;
        setData(i, (void *) Data, Test2);
    }

    for (size_t i = 0; i < 300; ++i) {
        EQ_TEST(i, *((int *) getData(i, Test2)));
    }

    delMap(Test2);

}

#include "../IncPS/Increment.h"
TESTF(EXISTS) {
    
    hash_map * Test1 = initMap(0);

    char * TestData1 = (char *) malloc(sizeof(char));
    *TestData1 = 'a';

    float TestData2_val = 0.999888;
    float * TestData2 = &TestData2_val;

    setData(1,(void*) TestData1, Test1);
    setData(10,(void*) TestData2, Test1);

    EQ_TEST(exists(1, Test1), true);
    EQ_TEST(exists(10, Test1), true);

    NEQ_TEST(exists(200, Test1), true);
    NEQ_TEST(exists(56, Test1), true);

    delMap(Test1);

    hash_map * Test2 = initMap(0);

    for (size_t i = 0; i < 300; ++i) {
        int * Data = (int *) malloc(sizeof(int));
        * Data = i;
        setData(i, (void *) Data, Test2);
    }

    for (size_t i = 0; i < 300; ++i) {
        EQ_TEST(true, exists(i, Test2));
    }

    NEQ_TEST(exists(400, Test1), true);
    NEQ_TEST(exists(709636, Test1), true);

    delMap(Test2);

}

#include "../IncPS/Increment.h"
TESTF(ITER) {
    TODO(finish testing iterators);
}

#endif