#include "config.h"
#include <stdio.h>
#include "base32.h"

int
checkbase32(char testchar)
{
    printf("isbase32 of %#x returned %s.\n",
           testchar, isbase32(testchar) ? "TRUE" : "FALSE");
    return 0;
}

int
main(void)
{
    printf("Hello world!\n");

    checkbase32(10);
    checkbase32('A');
    checkbase32('a');

    return 0;
}
