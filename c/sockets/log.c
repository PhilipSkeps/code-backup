#include "log.h"

int openLog(const hash_map * FHMap, const char const * LogFileName) {

    FILE * fh;

    if ( (fh = fopen(LogFileName, "a")) == NULL) {
        fprintf(stderr, "log :: openLog : Log File Failed To Open \n");
        return -1;
    }

    setData(1, (void *) fh, FHMap);

    return 0;
}

void signalCloseLog(const hash_map * FHMap, const int Signal) {
    
    printf("%s: %d\n%s\n", "Caught Signal: ", Signal, "Cleaning Up Open Log Map");

    hmap_it endIter = endIterator(FHMap);

    for (hmap_it Iter = beginIterator(FHMap); Iter != endIter; advanceIterator(&Iter)) {
        fclose( (FILE *) (Iter->bucket) );
    }
    
}