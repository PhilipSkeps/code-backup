#include "argumentHandling.h"

int main(int argc, char** argv) {

    CLArgs Args;

    Args = handleArgs(argc, argv);

    return EXIT_SUCCESS;
}