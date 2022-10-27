#ifndef __HASH_MAP__
#define __HASH_MAP__

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

typedef struct {
    size_t key;
    void * bucket;
} hash_node;

typedef  struct {
    char prindx;
    size_t prinodes;
    hash_node * narray;
} hash_map;

typedef hash_node * hmap_it;

hash_map * initMap(const size_t Size); // done
bool exists(const size_t Key, const hash_map * HashMap); // done

void setData(const size_t Key, const void const * Data, const hash_map * HashMap); // done
void * getData(const size_t Key, const hash_map const * HashMap); // done

hmap_it beginIterator(const hash_map const * HashMap);
hmap_it endIterator(const hash_map const *HashMap);
void advanceIterator(hmap_it * Iter); // done
hmap_it find(const size_t Key, const hash_map const * HashMap); // done

void clearNode(const size_t Key, hash_map * HashMap); // done
void delMap(hash_map * HashMap); // done

#endif