#include "config.h"
#include "debug_print.h"
#ifdef STDC_HEADERS
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

typedef int foo;
foo bar = 2;

struct baz {
    int a;
    short b;
};
typedef struct baz      blurfl;

int
pwd(void)
{
#ifdef HAVE_PATHCONF
     long maxpathlen = pathconf(".", _PC_PATH_MAX);
     debug_var(maxpathlen, ld);
     char pathbuf[maxpathlen];
#else
    char pathbuf[PATH_MAX];
#endif

#ifdef HAVE_GETCWD
    if ( getcwd(pathbuf, (size_t)PATH_MAX) == NULL )
        return -1;
#else
    fprintf(stderr, "getcwd not defined.\n");
    pathbuf[0] = 0;
#endif

    printf("Current directory is: %s\n", pathbuf);
    return 0;
}

int
main(int argc, char *argv[])
{
    blurfl zap;
    zap.a = 1;
    zap.b = 2;
    debug_var(zap.a, d);
    debug_var(zap.b, d);
    char *p = "Test";
    debug_string(p);

    short sarr[] = { 101, 202, 303 };
    debug_array(sarr);
    if ( argc > 1 ) {
        int sarr_index = atoi(argv[1]);
        debug_var(sarr_index, d);
        if ( sarr_index >= N_ELEMS(sarr) )
            printf("Index specified (%d) exceeds upper bound of sarr: %d\n",
                   sarr_index, N_ELEMS(sarr)-1);
        sarr[sarr_index] = 0xff;
        debug_array_segment(sarr, 0, sarr_index);
        debug_var(sarr_index, d);
    }

    int iarr[2];
    iarr[0] = 404;
    iarr[1] = 505;
    iarr[2] = 606;          // Runs off the end of the array.
                            // Detected by clang, not by gcc.
    debug_array(iarr);

#if defined(PATH_MAX)
    debug_var2(PATH_MAX, d, #x);
#endif
#if defined(__WORDSIZE)
    debug_var2(__WORDSIZE, d, #x);
#endif

    debug_sizeof(char);
    debug_sizeof(short);
    debug_sizeof(int);
    debug_sizeof(long);
    debug_sizeof(int8_t);
    debug_sizeof(int16_t);
    debug_sizeof(int32_t);
    debug_sizeof(int64_t);
    debug_sizeof(size_t);
    debug_sizeof(char *);
    debug_sizeof(short *);
    debug_sizeof(int *);
    debug_sizeof(long * );
    debug_sizeof(size_t *);

#if defined(__int64)
    debug_sizeof(__int64);
#endif

    return pwd();
}

// Local Variables:
// c-basic-offset: 4
// indent-tabs-mode: nil
// End:
