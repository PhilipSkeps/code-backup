#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string>
#include <iostream>
#include <cstring>
#include <stdlib.h>
#include <iomanip>
#define PORT 3004
#define IP_ADDRESS "127.0.0.1"

char* itoa(int num) {
    char* tempString = NULL;
    sprintf(tempString,"%d",num);
    return tempString;
}

char** split( const char* string, const char* delim) { // figure this out
    char tempString[strlen(string) + 1] = {0};
    std::cout << "here" << std::endl;
    strcpy(tempString,string);
    *(tempString + strlen(string)) = ' ';

    unsigned int dCount(0),i(0);
    while(tempString[i] != 0) { 
        if (tempString[i] == *delim) dCount++;
        i++;
    }

    char* tokenString = strtok(tempString,delim);
    char** arrayTokenString = NULL;
    while(tokenString != NULL) {
        tokenString = strtok(tempString,delim);
        arrayTokenString[1] = tokenString; // need null terminator on sub strings 
    }

    return arrayTokenString;
}

int main() {

    int sock = socket(AF_INET,SOCK_STREAM,0);
    if (sock < 0) {
        std::cerr << "socket unable to open please fix me" << std::endl;
        return -1;
    }

    char buffer[1024] = {0};
    const char quitOption[1024] = "done!";

    sockaddr_in SAddr;
    SAddr.sin_addr.s_addr = inet_addr(IP_ADDRESS);
    SAddr.sin_family = AF_INET;
    SAddr.sin_port = htons(PORT);

    int opt = 1;
    if (setsockopt(sock,SOL_SOCKET,SO_REUSEADDR | SO_REUSEPORT, &opt,sizeof(opt))) {
        std::cerr << "Address unable to connect to socket with IP: " << IP_ADDRESS << std::endl
                  << "Returned with errno" << errno << ": " << strerror(errno) << std::endl;
    }

    if (connect(sock,(const sockaddr *) &SAddr,sizeof(SAddr))) {
        std::cerr << "Address unable to connect to socket with IP: " << IP_ADDRESS << std::endl
                  << "Returned with errno " << errno << ": " << strerror(errno) << std::endl;
    } else {
        std::cout << std::setfill('#') << std::setw(26) << "" << std::endl;
        std::cout << "connected to IP: " << inet_ntoa(SAddr.sin_addr) << std::endl
                  << "on port: " << ntohs(SAddr.sin_port) << std::endl;
        std::cout << std::endl << "type bash commands or type" << std::endl 
                  << "done! to be finished" << std::endl;
        std::cout << std::setfill('#') << std::setw(26) << "" <<  std::endl << std::endl;   
    }
    
    char test[4] = "pwd";
    char** test2 = split(test," ");
    std::cout << "here " << *test2 << std::endl;


    while(strcmp(buffer,quitOption)) {

        memset(buffer,0,strlen(buffer));
        std::cin >> buffer;
        pid_t child = fork();
        if ( child == -1 ) {
            std::cerr << "process unable to be forked" << std::endl
                      << "Returned with errno " << errno << ": " << strerror(errno) << std::endl;
        } else if ( child == 0 ) {
            char** splitBuffer = split(buffer," ");
            if(execvp(*splitBuffer,splitBuffer) == -1 && strcmp(buffer,quitOption) ) {
                std::cerr << "failed to use command " << buffer << std::endl
                          << "returned with ernno " << errno << ": " << strerror(errno) << std::endl;
            } 
        } else {
           continue;
        }
    }

    close(sock);
    return 0;

}