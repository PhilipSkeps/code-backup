#ifndef __LLIST__
#define __LLIST__

#include <stdio.h>
#include <stdlib.h>

typedef struct __node__ node;

struct __node__ {
    void * bucket;
    node * reve;
    node * forw;
};

typedef struct {
    node * narray;
    size_t size;
} llist;

#endif