#include "argumentHandling.h"

// TODO: add unique parsing for protocol types

uint16_t handlePort(const char const * PortNum) {
    
    if ( PortNum == NULL ) {
        
        fprintf(stderr, "%s\n", "No Port Number Was Provided After Option");
        PRINT_HELP;
        exit(EXIT_FAILURE);
    
    }
    
    char * TempTestString;
    long TempTestPortNum = strtol(PortNum, &TempTestString, 10);
    
    if ( !cmpstr(TempTestString, "\0") ) {
        
        fprintf(stderr, "%s%s\n%s\n", "Unallowed Characters: ", TempTestString, "Please Provide A Decimal Number");
        exit(EXIT_FAILURE);
    
    } else if ( TempTestPortNum < 0 || TempTestPortNum > MAX_PORT_NUM ) {
        
        fprintf(stderr, "%s%d <= PORTNUM <= %d", "PORTNUM Must Be Within Bounds: ", 0, MAX_PORT_NUM);
        exit(EXIT_FAILURE);
    
    }

    return TempTestPortNum; // No error therefore return the correct port

}

// add a method for testing that it is a valid IPv4 or IPv6
char * handleAddress(const char * const Address) {
    
    if (Address == NULL) {
        
        fprintf(stderr, "%s\n", "No Port Number Was Provided After Option");
        PRINT_HELP;
        exit(EXIT_FAILURE);
    
    }

    return Address; // no error therefore return the correct address
}

CLArgs handleArgs(const int argc, const char * const * const argv) {
    
    CLArgs Args = {DEFAULT_PORT_NUM, DEFAULT_ADDRESS};
    
    if ( argc > NUM_ARGS ) {
        
        fprintf(stderr, "%s%d\n", "Too Many Comand Line Arguments Were Given, Max Args: ", NUM_ARGS);
        PRINT_HELP;
        exit(EXIT_FAILURE);
    
    }

    for ( size_t i = 0; i < argc; i+=2 ) {
        
        if ( strcmp(argv[i], "-h") ) {
            
            PRINT_HELP;
            exit(EXIT_SUCCESS);
        
        } else if (strcmp(argv[i], "-p") || strcmp(argv[i], "--port")) {
            
            Args.port = handlePort(argv[i + 1]);
        
        } else if ( strcmp(argv[i], "-a") || strcmp(argv[i], "--address") ) {

            Args.address = handleAddress(argv[i + 1]);

        } else {
            
            fprintf(stderr, "%s%s", "Unkown Argument: ", argv[i]);
            exit(EXIT_FAILURE);
        
        }
    }

    return Args;
}