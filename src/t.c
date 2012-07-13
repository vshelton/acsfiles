#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>
#include <asm-generic/types.h>

#define N_ELEMS(array)          (sizeof(array) / sizeof(array[0]))

#define debug_var(v, fmt)       printf(#v " = %" #fmt "\n", v)
#define debug_var2(v, f1, f2)   printf(#v " = %" #f1 " (%" #f2 ")\n", v, v)
#define debug_ptr(p, fmt)       printf(#p " = %p; *" #p " = %" #fmt "\n", p, *p)

#define debug_sizeof(typ)       printf("sizeof(" #typ ") = %lu\n", \
                                       (unsigned long)sizeof(typ))


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
    // long maxpathlen = pathconf(".", _PC_PATH_MAX);
    // debug_var(maxpathlen, ld);
    // char pathbuf[maxpathlen];
    char pathbuf[PATH_MAX];
    (void)getcwd(pathbuf, (size_t)PATH_MAX);

    printf("Current directory is: %s\n", pathbuf);

    return 0;
}

int main()
{
    blurfl zap;
    zap.a = 1;
    zap.b = 2;
    char *p = "Test";
    while ( *p ) {
        debug_ptr(p, c);
        ++p;
    }

    short sarr[] = { 1, 2, 3 };
    short *sp;
    int i;
    for ( sp = sarr, i = N_ELEMS(sarr); i > 0; ++sp, --i ) {
        debug_ptr(sp, d);
    }

    int iarr[2];
    iarr[0] = 4;
    iarr[1] = 5;
    iarr[2] = 6;            // Runs off the end of the array.
                            // Detected by clang, not by gcc.
    int *ip;
    for ( ip = iarr, i = N_ELEMS(iarr); i > 0; ++ip, --i ) {
        debug_ptr(ip, d);
    }

#if defined(PATH_MAX)
    debug_var2(PATH_MAX, d, #x);
#endif
#if defined(__WORDSIZE)
    debug_var2(__WORDSIZE, d, #x);
#endif
    debug_sizeof(int);
    debug_sizeof(long);
    debug_sizeof(size_t);

    debug_sizeof(__s8);
    debug_sizeof(__u8);
    debug_sizeof(__s16);
    debug_sizeof(__u16);
    debug_sizeof(__s32);
    debug_sizeof(__u32);
    debug_sizeof(__s64);
    debug_sizeof(__u64);

#if defined(__int64)
    debug_sizeof(__int64);
#endif

    return pwd();
}
