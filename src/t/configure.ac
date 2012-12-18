#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.68])
AC_INIT([t], [1.4], [ethersoft@gmail.com])
AM_INIT_AUTOMAKE([1.10 no-define])
AC_CONFIG_SRCDIR([debug_print.h])
AC_CONFIG_HEADERS([config.h])

# Checks for programs.
AC_PROG_CC

# For gnulib.
gl_INIT
gl_EARLY

# Checks for libraries.
AC_CHECK_LIB([gnu], [getcwd])

# Checks for header files.
AC_CHECK_HEADERS([OS.h fcntl.h limits.h netdb.h stddef.h stdint.h stdlib.h string.h sys/param.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_TYPE_UID_T
AC_TYPE_INT16_T
AC_TYPE_INT32_T
AC_TYPE_INT64_T
AC_TYPE_INT8_T
AC_TYPE_OFF_T
AC_TYPE_SIZE_T
AC_TYPE_SSIZE_T

# Checks for library functions.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_CHECK_FUNCS([getcwd getpagesize pathconf strdup])

AC_CONFIG_FILES([Makefile
                 gl/Makefile])
AC_OUTPUT
