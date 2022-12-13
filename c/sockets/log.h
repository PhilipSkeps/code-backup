#ifndef __LOG__
#define __LOG__

#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include <signal.h>

#include "../incps/hmap.h"

#define WLOG(fh, string) fputs(string, fh); fflush(fh);
#define WFLOG(fh, fmt, args...) fprintf(fh, fmt, ##args); fflush(fh);
#define CLOG(fh) fclose(fh);

int openLog( const hash_map * FHMap, const char const * LogFileName);
void signalCloseLog(const hash_map * FHMap, const int Signal);

#endif