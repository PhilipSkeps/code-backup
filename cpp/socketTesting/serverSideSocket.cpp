#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <signal.h>
#include <string>
#include <iostream>
#include <cstring>
#define PORT 3004

// serverside socket

char* itoa(int num) {
    char* tempString;
    sprintf(tempString,"%d",num);
    return tempString;
}

int newSock;
int sock;

void signalCatch(int signum) {
    std::cout << " caught signal " << signum << std::endl
              << "closing and shutting down server" << std::endl;
    close(sock);
    shutdown(newSock,SHUT_RDWR);
    exit(0);
}

int main() {

    signal(SIGINT,signalCatch);

    int sock = socket(AF_INET,SOCK_STREAM,0);
    if (sock < 0) {
        std::cerr << "socket object unable to be created" << std::endl;
        return -1;
    }

    char buffer[1024] = {0};

    sockaddr_in SAddr, CAddr;
    SAddr.sin_addr.s_addr = INADDR_ANY;
    SAddr.sin_family = AF_INET;
    SAddr.sin_port = htons(PORT);

    int opt(1);
    if (setsockopt(sock,SOL_SOCKET,SO_REUSEPORT | SO_REUSEADDR,&opt,sizeof(opt))) {
        std::cerr << "unable to set server side options" << std::endl;
        return -1;
    }

    if (bind(sock,(const sockaddr*) &SAddr,sizeof(SAddr))) {
        std::cerr << " All Address's unable to bind to socket" << std::endl
                  << "returned with ernno " << errno << ": " << strerror(errno) << std::endl;
        return -1;          
    }


    std::cout << "now awake" << std::endl;
    int newSock;
    socklen_t SAddrSize = sizeof(SAddr);
    socklen_t CAddrSize = sizeof(CAddr);
    while(true) {

        if (listen(sock,3)) {
            std::cerr << "server side socket unable to listen something horrible occured" << std::endl
                    << "returned with ernno " << errno << ": " << strerror(errno) << std::endl;
        } 

        newSock = accept(sock,(sockaddr*) &SAddr,&SAddrSize);
        if (newSock < 0) {
            std::cerr << "not connected to client, something horrible happened" << std::endl
                    << "returned with ernno " << errno << ": " << strerror(errno) << std::endl;
        } else {
            getpeername(newSock, (sockaddr *) &CAddr, &CAddrSize);
        }
        
        if (read(newSock,&buffer,sizeof(buffer)) == -1 ) {
            std::cerr << "failed to recieve message oh balls" << std::endl
                      << "returned with ernno " << errno << ": " << strerror(errno) << std::endl;
        } 
    }

    close(newSock);
    shutdown(sock,SHUT_RDWR);
    std::cout << "shutdown normally" << std::endl;

    return 1;

}