#ifndef _DEBUG_PRINT_H

#if !defined(N_ELEMS)
#define N_ELEMS(array)          (sizeof(array) / sizeof(array[0]))
#endif

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

#endif // _DEBUG_PRINT_H
