#include "../incps/vector.h"

#define MAX sizeof(size_t) / 2

// test

vector * initHVec(size_t Size) {

    vector * ReturnVec;

    if (Size > MAX) {
        fprintf(stderr, "%s%lu%s%lu%s\n", "Size provided: ", Size, " larger than maximum size: ", MAX, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    if ( (ReturnVec = malloc(sizeof(vector))) == NULL) {
        fprintf(stderr, "Malloc failed during initialization >Fatal Error\n");
        exit(EXIT_FAILURE);
    }

    if (Size < 1) {
        ReturnVec->reserve = 1;
        ReturnVec->size = 0;
    } else {
        ReturnVec->reserve = Size * 2;
    }

    if ( (ReturnVec->array = malloc(sizeof(buckwrap) * ReturnVec->reserve)) == NULL) {
        fprintf(stderr, "%s%lu%s\n","Malloc failed during creation of internal array of size: ", Size, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    return(ReturnVec);

}

vector initSVec(const size_t Size) {
    
    vector ReturnVec;

    if (Size > MAX) {
        fprintf(stderr, "%s%lu%s%lu%s\n", "Size provided: ", Size, " larger than maximum size: ", MAX, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    if (Size < 1) {
        ReturnVec.reserve = 1;
        ReturnVec.size = 0;
    } else {
        ReturnVec.reserve = Size * 2;
    }

    if ( (ReturnVec.array = malloc(sizeof(buckwrap) * ReturnVec.reserve)) == NULL) {
        fprintf(stderr, "%s%lu%s\n","Malloc failed during creation of internal array of size: ", Size, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    return(ReturnVec);

}

void reserve(const size_t Size, vector * Vec) {

    if (Size < Vec->reserve) {
        return;
    }

    if (Size > MAX * 2) {
        fprintf(stderr, "%s%lu%s%lu%s\n", "Size provided: ", Size, " larger than maximum size: ", MAX, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    if ( (Vec->array = realloc(Vec->array, sizeof(buckwrap) * Size)) == NULL) {
        fprintf(stderr, "%s%lu%s\n","Realloc failed during resize of internal array of size: ", Size, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    Vec->reserve = Size;

}

void resize(const size_t Size, vector * Vec) {
    
    size_t Reserve = Size * 2;
    size_t NewSize = Size;

    if ( Size > MAX ) {
        fprintf(stderr, "%s%lu%s%lu%s\n", "Size provided: ", Size, " larger than maximum size: ", MAX, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    if ( Size < 1 ) {
        Reserve = 1;
        NewSize = 0;
    }

    if ( (Vec->array = realloc(Vec->array, sizeof(buckwrap) * Reserve)) == NULL ) {
        fprintf(stderr, "%s%lu%s\n","Realloc failed during resize of internal array of size: ", Reserve, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    Vec->size = NewSize;
    Vec->reserve = Reserve;

}

size_t size(const vector * Vec) {

    return Vec->size;

}

void * safeAt(const size_t Idx, const vector * Vec) {
    
    if (Idx > Vec->size) {
        fprintf(stderr, "%s%lu%s%lu%s\n", "Index: ", Idx, " out of range ", Vec->size, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    return Vec->array[Idx].bucket;

}

void * At(const size_t Idx, const vector * Vec) {

    return Vec->array[Idx].bucket;

}

void push(void * Data, vector * Vec) {

    if (Vec->size == Vec->reserve) {
        
        Vec->reserve = Vec->size * 2;
        if ( (Vec->array = realloc(Vec->array, sizeof(buckwrap) * Vec->reserve)) == NULL ) {
            fprintf(stderr, "%s%lu%s\n","Realloc failed during resize of internal array of size: ", Vec->reserve, " >Fatal Error");
            exit(EXIT_FAILURE);
        }

    }

    ++Vec->size;

    Vec->array[Vec->size].bucket = Data;

}

void * pop(vector * Vec) {

    if (Vec->size == Vec->reserve / 4) {
        
        Vec->reserve = Vec->size * 2;
        if ( (Vec->array = realloc(Vec->array, sizeof(buckwrap) * Vec->reserve)) == NULL ) {
            fprintf(stderr, "%s%lu%s\n","Realloc failed during resize of internal array of size: ", Vec->reserve, " >Fatal Error");
            exit(EXIT_FAILURE);
        }

    }

    --Vec->size;

    return(Vec->array[Vec->size + 1].bucket);

}

vector subVec(const size_t Start, const size_t End, const vector * Vec) {

    size_t NewSize = End - Start + 1;

    vector ReturnVec = initSVec(NewSize);

    memcpy(ReturnVec.array, Vec->array + Start, sizeof(buckwrap) * NewSize);

    return(ReturnVec);

}

vector safeSubVec(const size_t Start, const size_t End, const vector * Vec) {

    if ( Start > End ) {
        fprintf(stderr, "%s%lu%s%lu%s\n", "Start: ", Start, " greater than End: ", End, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    if (End > Vec->size) {
        fprintf(stderr, "%s%lu%s%lu%s\n", "Index: ", End, " out of range ", Vec->size, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    return(subVec(Start, End, Vec));

}

vector subVecd(const size_t Start, const size_t End, vector * Vec) {

    size_t NewSize = End - Start + 1;

    vector ReturnVec = initSVec(NewSize);

    memcpy(ReturnVec.array, Vec->array + Start, sizeof(buckwrap) * NewSize);
    memmove(Vec->array + Start, Vec->array + End, sizeof(buckwrap) * Vec->size - End - 1);

    Vec->size = Vec->size - NewSize;

    if (Vec->size == Vec->reserve / 4) {
        
        Vec->reserve = Vec->size * 2;
        if ( (Vec->array = realloc(Vec->array, sizeof(buckwrap) * Vec->reserve)) == NULL ) {
            fprintf(stderr, "%s%lu%s\n","Realloc failed during resize of internal array of size: ", Vec->reserve, " >Fatal Error");
            exit(EXIT_FAILURE);
        }

    }

    return(ReturnVec);

}

vector safeSubVecd(const size_t Start, const size_t End, vector * Vec) {

    if ( Start > End ) {
        fprintf(stderr, "%s%lu%s%lu%s\n", "Start: ", Start, " greater than End: ", End, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    if (End > Vec->size) {
        fprintf(stderr, "%s%lu%s%lu%s\n", "Index: ", End, " out of range ", Vec->size, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    return(subVecd(Start, End, Vec));

}

void foreach(const size_t Start, const size_t End, vector * Vec, void ( * func)(void *)) {
    
    for (size_t i = Start; i <= End; i++) {

        func(Vec->array[i].bucket);
    
    }

}

void safeForeach(const size_t Start, const size_t End, vector * Vec, void (* func)(void *)) {

    if ( Start > End ) {
        fprintf(stderr, "%s%lu%s%lu%s\n", "Start: ", Start, " greater than End: ", End, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    if (End > Vec->size) {
        fprintf(stderr, "%s%lu%s%lu%s\n", "Index: ", End, " out of range ", Vec->size, " >Fatal Error");
        exit(EXIT_FAILURE);
    }

    foreach(Start, End, Vec, func);
}