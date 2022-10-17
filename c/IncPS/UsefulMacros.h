#ifndef __USEFUL_MACROS__
#define __USEFULE_MACROS__
#include <stdio.h>

#define KDFT  "\x1B[00m"
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"

#ifndef __PRETTY_FUNCTION_NAME__
    #ifdef WIN32   //WINDOWS
        #define __PRETTY_FUNCTION_NAME__   __FUNSIG__
    #else          //*NIX
        #define __PRETTY_FUNCTION_NAME__   __PRETTY_FUNCTION__
    #endif
#endif

#ifndef __FUNCTION_NAME__
    #ifdef WIN32 //WINDOWS
        #define __FUNCTION_NAME__ __FUNCTION_NAME__
    #else
        #define __FUNCTION_NAME__ __func__
    #endif
#endif            

#ifdef SAY_TODO
    #define TODO(Statement) printf("%sTODO: %s\n%s^~~~ %s\n%s",KYEL, #Statement, KGRN, __PRETTY_FUNCTION_NAME__, KDFT);
#else
    #define TODO(Statement)
#endif

#define UNUSED(x) #x;

// DEBUG
#ifdef DEBUG
    #define DEBUG_PRINT(fmt, args...) fprintf(stderr, "%sDEBUG: %s:%d:%s(): " fmt "\n%s", \
    KCYN, __FILE__, __LINE__, __PRETTY_FUNCTION_NAME__, ##args, KDFT)
#else
    #define DEBUG_PRINT(fmt, args...) /* Don't do anything in release builds */
#endif

#ifdef LOG
    FILE* logp;
    #define OLOG(filename) logp = fopen(#filename ".log", "w");
    #define WLOG(string) fputs(string, logp); fflush(logp);
    #define WFLOG(fmt, args...) fprintf(logp, fmt, ##args); fflush(logp);
    #define CLOG fclose(logp);
#else
    #define OLOG(filename)
    #define WLOG(string)
    #define WFLOG(fmt, args...)
    #define CLOG
#endif

#define ____CONCATSYM_H____(x,y) x##y
#define CONCATSYM(x,y) ____CONCATSYM_H____(x,y)

#define __STRINGIFY_H__(x) #x
#define STRINGIFY(x) __STRINGIFY_H__(x)

#define ARRAYSIZE(x) sizeof(x) / sizeof(x[0])

#endif // __USEFULE_MACROS__