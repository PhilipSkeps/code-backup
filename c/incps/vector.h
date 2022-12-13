#ifndef __VECTOR__
#define __VECTOR__

#include <stdlib.h>
#include <stdio.h>
#include <string.h> // memmove, memcpy

typedef struct {
    void * bucket;
} buckwrap;

typedef struct {
    buckwrap * array;
    size_t size;
    size_t reserve;
} vector;

vector * initHVec(const size_t Size);
vector initSVec(const size_t Size);

void resize(const size_t Size, vector * Vec);
void reserve(const size_t Size, vector * Vec);

size_t size(const vector * Vec);
void * safeAt(const size_t Idx, const vector * Vec);
void * At(const size_t Idx, const vector * Vec);

void push(void * Data, vector * Vec);
void * pop(vector * Vec);

vector subVec(const size_t Start, const size_t End, const vector * Vec);
vector safeSubVec(const size_t Start, const size_t End, const vector * Vec);
vector subVecd(const size_t Start, const size_t End, vector * Vec);
vector safeSubVecd(const size_t Start, const size_t End, vector * Vec);

void foreach(const size_t Start, const size_t end, vector * Vec, void (* func)(void *));
void safeForeach(const size_t Start, const size_t End, vector * Vec, void (* func)(void *));

void delHVec();
void delSVec();

#endif