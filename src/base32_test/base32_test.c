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
print_variable_sizes(void)
{
#if defined(__WORDSIZE)
    printf("Word size = %d\n", __WORDSIZE);
#endif

#if defined(__STDC_VERSION__) && (__STDC_VERSION__ - 0 >= 199901L)
# define SIZEOF_FORMAT	"zu"
#else
# define SIZEOF_FORMAT	"lu"
#endif

    printf("sizeof(long) = %" SIZEOF_FORMAT " bytes \n", sizeof(long));
    printf("sizeof(int) = %" SIZEOF_FORMAT " bytes \n", sizeof(int));
    printf("sizeof(short) = %" SIZEOF_FORMAT " bytes \n", sizeof(short));
    printf("sizeof(char) = %" SIZEOF_FORMAT " bytes \n", sizeof(char));

    return 0;
}

int
main(void)
{
    printf("Hello world!\n");

    print_variable_sizes();

    checkbase32(10);
    checkbase32('A');
    checkbase32('a');

    return 0;
}
