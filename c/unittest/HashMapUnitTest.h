#ifdef UNIT_TEST
#ifndef __STRING_EXTRA_UNIT_TEST__
#define __STRING_EXTRA_UNIT_TEST__
#include "../incps/macrosps.h"
#include "UnitTestBuilder.h"
#include "../incps/hmap.h"

#include "Increment.h"
TESTF(INITMAP) {

    hash_map * Test1 = initHMap(0);
    EQ_TEST(Test1->prindx, 0);
    delHMap(Test1);

    hash_map * Test2 = initHMap(24);
    EQ_TEST(Test2->prindx, 3);
    delHMap(Test2);

}

#include "Increment.h"
TESTF(SETDATA__GETDATA) {

    hash_map * Test1 = initHMap(0);

    char * TestData1 = malloc(sizeof(char));
    float * TestData2 = malloc(sizeof(float));

    *TestData1 = 'a';
    *TestData2 = 0.988;

    setData(1, (void*) TestData1, Test1);
    setData(10, (void*) TestData2, Test1);

    EQ_TEST(*((char *) getData(1, Test1)), 'a');
    TEQ_TEST(*((float *) getData(10, Test1)), 0.988, 0.002);

    free(getData(1, Test1));
    free(getData(10,Test1));

    delHMap(Test1);

    hash_map * Test2 = initHMap(0);

    for (size_t i = 0; i < 10; ++i) {
        int * Data = (int *) malloc(sizeof(int));
        * Data = i;
        setData(i, (void *) Data, Test2);
    }

    for (size_t i = 0; i < 10; ++i) {
        EQ_TEST(i, *((int *) getData(i, Test2)));
        free(getData(i, Test2));
    }

    delHMap(Test2);

}

#include "Increment.h"
TESTF(EXISTS) {
    
    hash_map * Test1 = initHMap(0);

    char * TestData1 = malloc(sizeof(char));
    float * TestData2 = malloc(sizeof(float));

    *TestData1 = 'a';
    *TestData2 = 0.988;

    setData(1,(void*) TestData1, Test1);
    setData(10,(void*) TestData2, Test1);

    EQ_TEST(exists(1, Test1), true);
    EQ_TEST(exists(10, Test1), true);

    NEQ_TEST(exists(200, Test1), true);
    NEQ_TEST(exists(56, Test1), true);

    free(getData(1, Test1));
    free(getData(10,Test1));

    delHMap(Test1);

    hash_map * Test2 = initHMap(0);

    for (size_t i = 0; i < 300; ++i) {
        int * Data = (int *) malloc(sizeof(int));
        * Data = i;
        setData(i, (void *) Data, Test2);
    }

    for (size_t i = 0; i < 300; ++i) {
        EQ_TEST(true, exists(i, Test2));
        free(getData(i,Test2));
    }

    NEQ_TEST(exists(400, Test1), true);
    NEQ_TEST(exists(709636, Test1), true);

    delHMap(Test2);

}

#include "Increment.h"
TESTF(ITER) {
    hash_map * Test1 = initHMap(10);
    for (size_t i = 0; i < 3; ++i) {
        int * Data = (int *) malloc(sizeof(int));
        * Data = i;
        setData(i, (void *) Data, Test1);
    }

    hmap_it Iter1 = beginIterator(Test1);

    int count = 0;

    while(advanceIterator(&Iter1, endIterator(Test1))) {
        
        ++count;

        if ( *((int *) Iter1->bucket) == 0 ) {
            continue;
        } else if ( *((int *) Iter1->bucket) == 1 ) {
            continue;
        } else if ( *((int *) Iter1->bucket) == 2 ) {
            continue;
        } else {
            EQ_TEST(1,2); // intenionally fail
        }
    }

    EQ_TEST(count, 2);

    for(size_t i = 0; i < 3; ++i) {
        free(getData(i,Test1));
    }

    delHMap(Test1);
}

#include "Increment.h"
TESTF(RESERVE__SIZE) {

    hash_map * HashMap = initHMap(0);
    reserve(10, HashMap);

    EQ_TEST(size(HashMap), 0);

}

#endif
#endif