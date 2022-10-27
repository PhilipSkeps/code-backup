#include "hashMap.h"

#define PRIME_SIZE 62

const static size_t prime[] = {
  /* 0     */ 5ul,
  /* 1     */ 11ul, 
  /* 2     */ 23ul, 
  /* 3     */ 47ul, 
  /* 4     */ 97ul, 
  /* 5     */ 199ul, 
  /* 6     */ 409ul, 
  /* 7     */ 823ul, 
  /* 8     */ 1741ul, 
  /* 9     */ 3469ul, 
  /* 10    */ 6949ul, 
  /* 11    */ 14033ul, 
  /* 12    */ 28411ul, 
  /* 13    */ 57557ul, 
  /* 14    */ 116731ul, 
  /* 15    */ 236897ul,
  /* 16    */ 480881ul, 
  /* 17    */ 976369ul,
  /* 18    */ 1982627ul, 
  /* 19    */ 4026031ul,
  /* 20    */ 8175383ul, 
  /* 21    */ 16601593ul, 
  /* 22    */ 33712729ul,
  /* 23    */ 68460391ul, 
  /* 24    */ 139022417ul, 
  /* 25    */ 282312799ul, 
  /* 26    */ 573292817ul, 
  /* 27    */ 1164186217ul,
  /* 28    */ 2364114217ul, 
  /* 29    */ 4294967291ul,
  /* 30    */ 8589934583ull,
  /* 31    */ 17179869143ull,
  /* 32    */ 34359738337ull,
  /* 33    */ 68719476731ull,
  /* 34    */ 137438953447ull,
  /* 35    */ 274877906899ull,
  /* 36    */ 549755813881ull,
  /* 37    */ 1099511627689ull,
  /* 38    */ 2199023255531ull,
  /* 39    */ 4398046511093ull,
  /* 40    */ 8796093022151ull,
  /* 41    */ 17592186044399ull,
  /* 42    */ 35184372088777ull,
  /* 43    */ 70368744177643ull,
  /* 44    */ 140737488355213ull,
  /* 45    */ 281474976710597ull,
  /* 46    */ 562949953421231ull, 
  /* 47    */ 1125899906842597ull,
  /* 48    */ 2251799813685119ull, 
  /* 49    */ 4503599627370449ull,
  /* 50    */ 9007199254740881ull, 
  /* 51    */ 18014398509481951ull,
  /* 52    */ 36028797018963913ull, 
  /* 53    */ 72057594037927931ull,
  /* 54    */ 144115188075855859ull,
  /* 55    */ 288230376151711717ull,
  /* 56    */ 576460752303423433ull,
  /* 57    */ 1152921504606846883ull,
  /* 58    */ 2305843009213693951ull,
  /* 59    */ 4611686018427387847ull,
  /* 60    */ 9223372036854775783ull,
  /* 61    */ 18446744073709551557ull,
};

int hash1(const size_t Key, const size_t Size) {
    return Key % Size;
}

int hash2(const size_t Key, const size_t Prime) {
    return Prime - (Key % Prime);
}

size_t index(const size_t Key, const hash_map const * HashMap) {

    size_t index1 = hash1(Key, prime[HashMap->prindx]);

    if ( HashMap->narray[index1].bucket == NULL ) {
        
        return index1;
    
    } else {

        for ( int i = 0; i < prime[HashMap->prindx]; ++i ) {

            size_t index2 = (index1 - i * hash2(Key, prime[HashMap->prindx])) % prime[HashMap->prindx];
            index2 < 0 ? prime[HashMap->prindx] + index2 : index2;

            if ( HashMap->narray[index2].bucket == NULL ) {
                
                return index2;

            }

        }

    }

}

void rehash(hash_map * HashMap) {
    
    hash_map * new = malloc(sizeof(hash_map));

    new->prindx = HashMap->prindx + 1;
    new->narray = malloc(sizeof(hash_node) * prime[new->prindx]);

    for (int i = 0; i < prime[HashMap->prindx]; ++i) {
        
        if (HashMap->narray[i].bucket != NULL) {

            size_t NewIndex = index(HashMap->narray[i].key, new);
            new->narray[NewIndex].key = HashMap->narray[i].key;
            new->narray[NewIndex].bucket = HashMap->narray[i].bucket;
        
        }

    }

    HashMap->narray = realloc(HashMap->narray, sizeof(hash_node) * prime[new->prindx]);

    memcpy(*HashMap, *new);

    free(new->narray);
    free(new);
    
}

hash_map * initMap(const size_t Size) {
    
    hash_map * ReturnMap;

    if ( (ReturnMap = malloc(sizeof(hash_map))) == NULL ) {
        
        fprintf(stderr, "Failed to intialize hash map, fatal error\n");
        exit(EXIT_FAILURE);

    }

    if ( Size >= prime[PRIME_SIZE - 1] ) {
        
        fprintf(stderr, "Requested size of hashmap is too large, fatal error\n");
        exit(EXIT_FAILURE);
    
    }

    for (size_t i = 0; i < sizeof(prime) / sizeof(size_t); ++i) {
        
        if (Size < prime[i]) {
            
            ReturnMap->prindx = i;
            break;
        
        }

    }

    if ( (ReturnMap->narray = malloc(sizeof(hash_node) * prime[ReturnMap->prindx])) == NULL ) {
        
        fprintf(stderr, "Failed to intitalize internal node array of hash map, fatal error\n");
        exit(EXIT_FAILURE);

    }

    ReturnMap->prinodes = 0;

    return ReturnMap;
}

bool exists(const size_t Key, const hash_map const * HashMap) {

    hmap_it Iter = find(Key, HashMap);

    if (Iter == NULL) {

        return false;

    } else {

        return true;

    }

}

void setPair(const size_t Key, const void const * Data, hash_map * HashMap) {
    
    hmap_it Iter = find(Key, HashMap);

    if (Iter == NULL) {

        if ( HashMap->prinodes / prime[HashMap->prindx] > 0.7 ) {

            rehash(HashMap);
    
        }

            size_t DataIndex = index(Key, HashMap);

            HashMap->narray[DataIndex].key = Key;
            HashMap->narray[DataIndex].bucket = Data;
            ++HashMap->prinodes;

    } else {
        
        Iter->bucket = Data;
    
    }

}

void * getData(const size_t Key, const hash_map const * HashMap) {
    
    hmap_it Iter = find(Key, HashMap);

    if (Iter == NULL) {

        fprintf(stderr, "Key does not exist within current hash map, fatal error");
        exit(EXIT_FAILURE);
    
    } else {

        return Iter->bucket;

    }

}

hmap_it beginIterator(const hash_map const * HashMap) {
    
    hmap_it Iter;
    Iter = &HashMap->narray[0];

    return Iter;

}

hmap_it endIterator(const hash_map const * HashMap) {
    
    hmap_it Iter;
    Iter = &HashMap->narray[prime[HashMap->prindx]];

    return Iter;

}

hmap_it find(const size_t Key, const hash_map const * HashMap) {
    
    hmap_it ReturnIt;

    size_t index1 = hash1(Key, prime[HashMap->prindx]);

    if ( HashMap->narray[index1].bucket == NULL ) {

        ReturnIt = NULL;
        return ReturnIt;
    
    } else if ( HashMap->narray[index1].key == Key ) {

        ReturnIt = malloc(sizeof(hash_node) * (prime[HashMap->prindx] - index1));
        ReturnIt = &HashMap->narray[index1];
        return ReturnIt;

    } else {

        for (size_t i = 0; i < prime[HashMap->prindx]; ++i) {
            
            size_t index2 = (index1 - i * hash2(Key, prime[HashMap->prindx])) % prime[HashMap->prindx];
            index2 < 0 ? prime[HashMap->prindx] + index2 : index2;

            if ( HashMap->narray[index2].bucket == NULL ) {
                
                ReturnIt = NULL;
                return ReturnIt;

            } else if ( HashMap->narray[index2].key == Key ) {
                
                ReturnIt = malloc(sizeof(hash_node) * (prime[HashMap->prindx] - index2));
                ReturnIt = &HashMap->narray[index2];
                return ReturnIt;

            }

        }

    }

    ReturnIt = NULL;
    return ReturnIt;

}

// will let the user segfault and access memory that is not theres
void advanceIterator(hmap_it * Iter) {

    while (true) {
        
        ++(* Iter);

        if ( (* Iter)->bucket != NULL ) {

            break;

        }

    }

}

void clearNode(const size_t Key, hash_map * HashMap) {

    hmap_it Iter = find(Key, HashMap);

    if ( Iter == NULL ) {
        
        fprintf(stderr, "Unable to delete non existent node with key: %s", Key);
    
    } else {

        free(Iter->bucket);
        Iter->bucket = NULL;
    
    }

}

void delMap(hash_map * HashMap) {
    
    for (int i = 0; i < prime[HashMap->prindx]; ++i) {
        
        free(HashMap->narray[i].bucket);
    
    }

    free(HashMap->narray);
    free(HashMap);

}