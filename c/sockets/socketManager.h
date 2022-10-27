#ifndef __SOCKET_MANAGER__
#define __SOCKET_MANAGER__

#include <stdio.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "argumentHandling.h"

typedef enum {CLIENT, SERVER} socket_side;

#endif