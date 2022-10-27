#ifndef __ARGUMENT_HANDLING__
#define __ARGUMENT_HANDLING__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define NUM_ARGS 4
#define MAX_PORT_NUM 65535

#define DEFAULT_PORT_NUM 8000
#define DEFAULT_ADDRESS "127.0.0.1"

#define PRINT_HELP fprintf(stderr, "%s\n%s\n", "Valid Command Line Arguments Are: ", \
                          "[-h] [-p|--port PORTNUM] [-a|--address ADDRESS]" \
                          )

typedef struct {

    uint16_t port;
    char * address;

} CLArgs;

CLArgs handleArgs(const int argc, const char * const * const argv);

#endif