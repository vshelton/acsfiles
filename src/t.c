#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>
#include <asm-generic/types.h>

#define N_ELEMS(array)          (sizeof(array) / sizeof(array[0]))

#define debug_array(v)          debug_array_segment(v, 0, N_ELEMS(v)-1)
#define debug_array_segment(v, lo, hi)                                  \
    do {                                                                \
        int i;                                                          \
        for ( i = lo; i <= hi; ++i ) {                                  \
            printf("%p  " #v "[%d] = %d (%#x)\n", &v[i], i, v[i], v[i]);\
        }                                                               \
    } while (0)
#define debug_ptr(p, fmt)       printf(#p " = %p; *" #p " = %" #fmt "\n", p, *p)
#define debug_ptr2(p, f1, f2)   printf(#p " = %p; *" #p " = %" #f1 " (%" #f2 ")\n", p, *p, *p)
#define debug_sizeof(typ)       printf("sizeof(" #typ ") = %lu\n", (unsigned long)sizeof(typ))
#define debug_string(s)                                                 \
    do {                                                                \
        int i;                                                          \
        for ( i = 0; s[i]; ++i ) {                                      \
            printf("%p  " #s "[%d] = %c (%#x)\n", &s[i], i, s[i], s[i]);\
        }                                                               \
    } while (0)
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

    if ( getcwd(pathbuf, (size_t)PATH_MAX) == NULL )
        return -1;
    
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
    debug_sizeof(__s8);
    debug_sizeof(__u8);
    debug_sizeof(short);
    debug_sizeof(__s16);
    debug_sizeof(__u16);
    debug_sizeof(int);
    debug_sizeof(__s32);
    debug_sizeof(__u32);
    debug_sizeof(long);
    debug_sizeof(__s64);
    debug_sizeof(__u64);
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
