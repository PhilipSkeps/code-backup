#ifndef __HASH_MAP__
#define __HASH_MAP__

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <string.h>

typedef struct {
    size_t key;
    void * bucket;
} hash_node;

typedef  struct {
    uint8_t prindx;
    size_t prinodes;
    hash_node * narray;
} hash_map;

typedef hash_node * hmap_it;

hash_map * initHMap(const size_t Size); // done
hash_map initSMap(const size_t Size); 

void reserve(const size_t Size, hash_map * HashMap); // done
size_t size(const hash_map * HashMap); // done
bool exists(const size_t Key, const hash_map * HashMap); // done

void setData(const size_t Key, void * Data, hash_map * HashMap); // done
void * getData(const size_t Key, const hash_map * HashMap); // done

hmap_it beginIterator(const hash_map * HashMap);
hmap_it endIterator(const hash_map * HashMap);
bool advanceIterator(hmap_it * Iter, const hmap_it endIter);
hmap_it find(const size_t Key, const hash_map * HashMap); // done

void clearNode(const size_t Key, hash_map * HashMap); // done

void delHMap(hash_map * HashMap); // done
void delSMap(hash_map * Hash);

#endif