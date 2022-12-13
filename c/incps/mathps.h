#include <math.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "macrosps.h"

typedef struct {

    double** Arr;
    size_t Rows;
    size_t Cols;

} Arr2D;

typedef struct {

    Arr2D* Arr;
    size_t Levels;

} Arr3D;

typedef struct {

    Arr3D* Arr;
    size_t Units;

} Arr4D;

Arr2D initArr2D(const size_t Rows, const size_t Columns) {

    assert(Rows > 0 && Columns > 0);
    
    Arr2D ReturnArr;
    ReturnArr.Rows = Rows;
    ReturnArr.Cols = Columns;

    if ((ReturnArr.Arr = (double**) calloc(Rows, sizeof(double*))) == NULL) {
        fprintf(stderr, "calloc failed in function %s", __FUNCTION_NAME__);
        exit(EXIT_FAILURE);
    }

    for (size_t i = 0; i < Rows; ++i) {

        if ((ReturnArr.Arr[i] = (double*) calloc(Columns, sizeof(double*))) == NULL) {
            fprintf(stderr, "calloc failed in function %s", __FUNCTION_NAME__);
            exit(EXIT_FAILURE);
        }

    }

    return ReturnArr;
}

Arr2D populArr2D(const double const * const * Array, const size_t Rows, const size_t Cols) {
    
    assert(Array != NULL);

    Arr2D ReturnArr = initArr2D(Rows, Cols);

    for (size_t i = 0; i < Rows; ++i) {

        assert(Array[i] != NULL);
        memcpy(ReturnArr.Arr[i], Array[i], Cols);

    }

}

/*
 *   |a B C|
 *   |d E F| => Minor is |B C| => minor element is at [2][2] and is i
 *   |g h i|             |E F|
 *
 *    offset increments and is added to inidice to determine next minor 
 *    modulus is used to get a wrap around effect of indices
 *    recursive to get all minor determinants and sums them to get final determ
 *    stops recursing when Array is 2D
 */  
size_t determArr2D(const Arr2D &Arr) {


    size_t Determ = 0;
    size_t Offset = 1;
    assert(Arr.Rows == Arr.Cols);

    if (Arr.Rows == 1) { // determ of a 1x1 is the only element

        return Arr.Arr[0][0];

    }

    if (Arr.Rows == 2) { // if our matrice is a 2x2 compute determ and finish recursion

        return Arr.Arr[0][0] * Arr.Arr[1][1] - Arr.Arr[0][1] * Arr.Arr[1][0];
    
    }

    for (size_t i = 0; i < Arr.Rows; ++i) { // if Array is greater than a 2x2 
        
        size_t MinorArrRows = Arr.Rows - 1;
        size_t MinorArrCols = Arr.Cols - 1;

        Arr2D MinorArr = initArr2D(MinorArrRows, MinorArrCols); // minor arrays will be top layer of matrix
        size_t MinorElem = Arr.Arr[Arr.Rows - 1][Offset - 1] * (((Arr.Rows + Offset) % 2) ? 1 : -1); // computes the sign of the element by checking if i + j is odd 1 indexed
        
        for (size_t j = 0; j < MinorArrRows; ++j) { // populate the minor array
            
            for (size_t h = 0; h < MinorArrCols; ++h) {
                
                MinorArr.Arr[j][h] = Arr.Arr[j][(h + Offset) % Arr.Cols];
            
            }
        
        }

        Determ += MinorElem * determArr2D(MinorArr);
        ++Offset;
    
    }

    return Determ;
}

Arr2D transposeArr2D(const Arr2D &Array) {
    
    Arr2D ReturnArr = Array;

    for (size_t i = 0; i < Array.Cols; ++i) {
        for (size_t j = 0; j < Array.Rows; ++j) {
            ReturnArr.Arr[i][j] = Array.Arr[i][j];
        }
    }

    return ReturnArr;

}

Arr2D inverseArr2D(const Arr2D &Array) {

    Arr2D TranArray = transposeArr2D(Array);
    TODO(finish doing the inverse using the Minor Arrays)
    TODO(test all of the 2D functionality)
    TODO(Pointerize everything so that I am not copying all the time)

}

Arr2D multiply2D(const Arr2D &Array1, const Arr2D &Array2) {

    TODO(IMPLEMENT: multiply2D)
    UNUSED(Array1)
    UNUSED(Array2)
}

Arr2D psuedoInvert2D(const Arr2D &Array) {

    TODO(IMPLEMENT: psuedoInvert2D)
    UNUSED(Array)

}
