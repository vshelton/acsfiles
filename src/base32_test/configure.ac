#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.68])
AC_INIT([base32_test], [1.3.1], [ethersoft@gmail.com])
AC_CONFIG_SRCDIR([config.h.in])
AC_CONFIG_HEADERS([config.h])

# Initialize automake.
AM_INIT_AUTOMAKE([foreign -Wall -Werror])

# Checks for programs.
AC_PROG_CC

# Initialize gnulib.
gl_EARLY
gl_INIT

# Checks for libraries.
gl_FUNC_BASE32
AC_CHECK_LIB([gnu], [isbase32])

# Checks for header files.
AC_CHECK_HEADERS([OS.h fcntl.h limits.h netdb.h stddef.h stdint.h stdlib.h string.h sys/param.h unistd.h wchar.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_HEADER_STDBOOL
AC_TYPE_UID_T
AC_TYPE_INT32_T
AC_TYPE_OFF_T
AC_C_RESTRICT
AC_TYPE_SIZE_T
AC_TYPE_SSIZE_T

# Checks for library functions.
AC_FUNC_MALLOC
AC_CHECK_FUNCS([getpagesize memchr])

AC_CONFIG_FILES([Makefile
                 gl/Makefile])
AC_OUTPUT
