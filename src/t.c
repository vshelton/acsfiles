#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>
#include <asm-generic/types.h>

#define N_ELEMS(array)          (sizeof(array) / sizeof(array[0]))

#define debug_array(v)                                                  \
    do {                                                                \
        for ( int i = 0; i < N_ELEMS(v); ++i ) {                        \
            printf(#v "[%d] (%p) = %d (%#x)\n", i, &v[i], v[i], v[i]);  \
        }                                                               \
    } while (0)
#define debug_ptr(p, fmt)       printf(#p " = %p; *" #p " = %" #fmt "\n", p, *p)
#define debug_ptr2(p, f1, f2)   printf(#p " = %p; *" #p " = %" #f1 " (%" #f2 ")\n", p, *p, *p)
#define debug_sizeof(typ)       printf("sizeof(" #typ ") = %lu\n", (unsigned long)sizeof(typ))
#define debug_var(v, fmt)       printf(#v " = %" #fmt "\n", v)
#define debug_var2(v, f1, f2)   printf(#v " = %" #f1 " (%" #f2 ")\n", v, v)

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

int
main()
{
    blurfl zap;
    zap.a = 1;
    zap.b = 2;
    char *p = "Test";
    while ( *p ) {
        debug_ptr2(p, c, #x);
        ++p;
    }

    short sarr[] = { 101, 202, 303 };
    debug_array(sarr);

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

// Local Variables:
// c-basic-offset: 4
// indent-tabs-mode: nil
// End:
