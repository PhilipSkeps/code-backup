#include "socketManager.h"

#define ERROR(function) fprintf(stderr, "socketManager :: %s:\n%s\n\n", #function, strerror(errno))

int initSocket(CLArgs Args, const int * SocketHandle, const void * Buffer, const socket_side Side) {

    int optionValue;

    // TCP socket using INET
    if ( (SocketHandle = socket(AF_INET, SOCK_STREAM, 0)) < 0 ) {
        ERROR("initSocket");
        return -1;
    }

    struct sockaddr_in ServerAddr = {.sin_family = AF_INET, 
                                     .sin_port = htons(Args.port), 
                                     .sin_addr.s_addr = inet_pton(AF_INET, Args.address, Buffer)
                                    };

    if (Side == CLIENT) {
        if ( connect(SocketHandle, (struct sockaddr *) &ServerAddr, sizeof(ServerAddr)) < 0 ) {
            ERROR("initSocket");
            return -1;
        }
    } else {
        if ( setsockopt(SocketHandle, SOL_SOCKET, SO_REUSEADDR, &optionValue, sizeof(optionValue)) < 0) {
            ERROR("initSocket");
            return -1;
        }

        if ( bind(SocketHandle, (struct sockaddr *) &ServerAddr, sizeof(ServerAddr)) < 0 ) {
            ERROR("initSocket");
            return -1;
        }
    }

    return 0; // success
}

int serverManager(const int * SocketHandle, const size_t TotalUsers) {

    if ( SocketHandle == NULL ) {
        fprintf(stderr, "");
    }

}