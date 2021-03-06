m4_define([orbit_major_version],[2])
m4_define([orbit_minor_version],[14])
m4_define([orbit_micro_version],[20])
m4_define([orbit_version],[orbit_major_version.orbit_minor_version.orbit_micro_version])

dnl Process this file with autoconf to produce a configure script.
AC_INIT([ORBit2],[orbit_version],[http://bugzilla.gnome.org/enter_bug.cgi?product=ORBit2],[ORBit2])

# Process this file with autoconf to produce a configure script.
# require autoconf 2.60
AC_PREREQ(2.60)

# Before making a release, the LT_VERSION string should be modified.
# The string is of the form C:R:A.
# - If interfaces have been changed or added, but binary compatibility has
#   been preserved, change to C+1:0:A+1
# - If binary compatibility has been broken (eg removed or changed interfaces)
#   change to C+1:0:0
# - If the interface is the same as the previous version, change to C:R+1:A

LT_VERSION=1:0:1
AC_SUBST(LT_VERSION)

ORBIT_MAJOR_VERSION=orbit_major_version
ORBIT_MINOR_VERSION=orbit_minor_version
ORBIT_MICRO_VERSION=orbit_micro_version
ORBIT_VERSION=orbit_version
AC_SUBST(ORBIT_MAJOR_VERSION)
AC_SUBST(ORBIT_MINOR_VERSION)
AC_SUBST(ORBIT_MICRO_VERSION)
AC_SUBST(ORBIT_VERSION)

# Increment this every time a feature is added in the .idl compiler
# that needs help from the main libraries.
ORBIT_SERIAL=20
AC_SUBST(ORBIT_SERIAL)

# For automake.

AC_CONFIG_HEADERS([config.h])

dnl Initialize automake stuff
AM_INIT_AUTOMAKE([1.9 no-dist-gzip dist-bzip2 no-define])

dnl Required by autoconf 2.60
AC_SUBST(datarootdir)

AC_CANONICAL_HOST
AC_MSG_CHECKING([for Win32])
case "$host" in
  *-*-mingw*)
    os_win32=yes
    LIBM=
    MINGW_LDFLAGS="-Wl,--enable-runtime-pseudo-reloc"
    ;;
  *)
    os_win32=no
    LIBM=-lm
    MINGW_LDFLAGS=
    ;;
esac
AC_MSG_RESULT([$os_win32])

AM_CONDITIONAL(OS_WIN32, [test "$os_win32" = "yes"])

AC_SUBST(LIBM)
AC_SUBST(MINGW_LDFLAGS)
LDFLAGS="$MINGW_LDFLAGS $LDFLAGS"

if test "$os_win32" = "yes"; then
  if test x$enable_static = xyes -o x$enable_static = x; then
    AC_MSG_WARN([Disabling static library build, must build as DLL on Windows.])
    enable_static=no
  fi
  if test x$enable_shared = xno; then
    AC_MSG_WARN([Enabling shared library build, must build as DLL on Windows.])
  fi
  enable_shared=yes
fi

dnl Checks for programs.
AC_PROG_CC
AC_PROG_INSTALL

AC_LIBTOOL_DLOPEN
AC_LIBTOOL_WIN32_DLL
AM_PROG_LIBTOOL
AM_MAINTAINER_MODE([enable])

dnl Useful for automating stuff
AC_CACHE_CHECK([for aclocal flags], ac_cv_orbit_aclocal_flags,[
   ac_cv_orbit_aclocal_flags="$ACLOCAL_FLAGS"
])
ACLOCAL="$ACLOCAL $ac_cv_orbit_aclocal_flags"

AC_ARG_ENABLE(http, [--enable-http enables http connections],, enable_http=no)
AM_CONDITIONAL(ENABLE_HTTP, test x"$enable_http" = xyes)
if test x"$enable_http" = xyes ; then
  AC_DEFINE(ENABLE_HTTP, 1, [Define if HTTP connections are available])
fi
dnl --enable-compile-warnings
AC_ARG_ENABLE(compile-warnings, [  --enable-compile-warnings=[no/yes] Turn on compiler warnings.], [enable_compile_warnings="$enableval"],[enable_compile_warnings="yes"])

dnl --enable-debug=(yes|minimum|no)
AC_ARG_ENABLE(debug, [  --enable-debug=[no/yes] turn on debugging [default=no]],,enable_debug=minimum)
if test "x$enable_debug" = "xyes"; then
  ORBIT_DEBUG_CFLAGS="-ggdb -O0 -DG_ENABLE_DEBUG"
else
  if test "x$enable_debug" = "xno"; then
    ORBIT_DEBUG_CFLAGS="-DG_DISABLE_ASSERT -DG_DISABLE_CHECKS"
  else
    ORBIT_DEBUG_CFLAGS=""
  fi
fi

AC_ARG_ENABLE(purify, [  --enable-purify        be clean for memory debuggers], enable_purify=yes, enable_purify=no)
if test z$enable_purify = zyes; then
	AC_DEFINE(ORBIT_PURIFY, 1, [defined if purify is enabled])
fi

AC_MSG_CHECKING(which idl compiler to use)
IDL_COMPILER="\$(top_builddir)/src/idl-compiler/orbit-idl-2\$(EXEEXT)"
AC_ARG_WITH(idl-compiler,
    [  --with-idl-compiler    use specific idl compiler (useful when crosscompiling)],
	if test "x$withval" != x; then
		if test -f "$withval"; then
		    IDL_COMPILER=$withval
		fi
	fi
)
if test x$IDL_COMPILER == x"\$(top_builddir)/src/idl-compiler/orbit-idl-2\$(EXEEXT)"; then
  AC_MSG_RESULT(internal)
else
  AC_MSG_RESULT(external ($IDL_COMPILER))
fi
AC_SUBST(IDL_COMPILER)

AC_PROG_AWK

GLIB_REQUIRED=2.8.0
LIBIDL_REQUIRED=0.8.2
AC_SUBST(GLIB_REQUIRED)
AC_SUBST(LIBIDL_REQUIRED)

dnl Check for pkg-config version; want >= 0.14.0 because of -pthread bug
PKG_PROG_PKG_CONFIG([0.18])

LOCAL_LINC_LIBS='$(top_builddir)/linc2/src/liblinc.la'
LOCAL_LINC_CFLAGS='-I$(top_srcdir)/linc2/include -I$(top_builddir)/linc2/include'
AC_SUBST(LOCAL_LINC_LIBS)
AC_SUBST(LOCAL_LINC_CFLAGS)

dnl Checks for libraries.
PKG_CHECK_MODULES(ORBIT, \
	glib-2.0 >= $GLIB_REQUIRED \
	gobject-2.0 >= $GLIB_REQUIRED \
	gthread-2.0 >= $GLIB_REQUIRED \
	gmodule-2.0 >= $GLIB_REQUIRED)
AC_SUBST(ORBIT_LIBS)
AC_SUBST(ORBIT_CFLAGS)

PKG_CHECK_MODULES(ORBIT_IDL, \
	libIDL-2.0 >= $LIBIDL_REQUIRED \
	glib-2.0 >= $GLIB_REQUIRED \
	gobject-2.0 >= $GLIB_REQUIRED \
	gmodule-2.0 >= $GLIB_REQUIRED)
AC_SUBST(ORBIT_IDL_LIBS)
AC_SUBST(ORBIT_IDL_CFLAGS)

PKG_CHECK_MODULES(ORBIT_NAME,
	glib-2.0 >= $GLIB_REQUIRED \
	gobject-2.0 >= $GLIB_REQUIRED \
	gthread-2.0 >= $GLIB_REQUIRED \
	gmodule-2.0 >= $GLIB_REQUIRED)
AC_SUBST(ORBIT_NAME_LIBS)
AC_SUBST(ORBIT_NAME_CFLAGS)

dnl Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS(fcntl.h unistd.h sys/endian.h endian.h machine/endian.h)
AC_CHECK_HEADERS(sys/machine.h sys/isa_defs.h sys/poll.h sys/select.h)
AC_CHECK_HEADERS(sys/time.h netinet/in.h sys/socket.h arpa/inet.h)
AC_CHECK_HEADERS(stddef.h wchar.h wcstr.h wctype.h machine/types.h)
AC_CHECK_HEADERS(sys/un.h sys/uio.h syslog.h)
AC_CHECK_HEADERS(sys/wait.h netdb.h)
AC_CHECK_HEADERS(utime.h sys/utime.h)
AC_CHECK_HEADERS([linux/socket.h])
AC_CHECK_HEADERS(sys/sockio.h)

if test "$os_win32" = "yes"; then
	AC_CHECK_HEADERS(winsock2.h)
	if test $ac_cv_header_winsock2_h = yes; then
		dnl If we have <winsock2.h>, assume we find the functions
		dnl in -lws2_32.
		LIBS="-lws2_32 $LIBS"
	fi
fi

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE
AC_TYPE_SIZE_T

dnl Checks for library functions.
AC_FUNC_VPRINTF

AC_CHECK_FUNC(socket,,[AC_CHECK_LIB(socket,socket)])
AC_CHECK_FUNC(gethostbyname,,[AC_CHECK_LIB(nsl,gethostbyname)])
AC_CHECK_FUNC(sigaction)
AC_CHECK_FUNC(syslog)

dnl This generates warnings from autoconf...
AC_C_BIGENDIAN


dnl
dnl   So many people with broken linking setups asked about this
dnl it turned out to be necessary to check for this.
dnl
dofus_save_libs="$LIBS"
LIBS="$ORBIT_LIBS $LIBS"
AC_TRY_RUN([ #include <stdio.h>
             main ()
             {
               return 0;
             } ],,
           AC_MSG_ERROR([
Linking is badly borked on your system. Please ensure your library path is correct
Check config.log for details - check near the end of the log above 'failed program was'
Alternatively ensure that your /etc/ld.so.conf (and/or LD_LIBRARY_PATH) includes the
prefix you're compiling on: '${prefix}' ]), 
AC_MSG_WARN([Could not check for borked linking while cross-compiling]))
LIBS="$dofus_save_libs"

orig_CPPFLAGS=$CPPFLAGS
CPPFLAGS="$CPPFLAGS $ORBIT_CFLAGS"
AC_CHECK_ALIGNOF(CORBA_octet)
AC_CHECK_ALIGNOF(CORBA_boolean)
AC_CHECK_ALIGNOF(CORBA_char)
AC_CHECK_ALIGNOF(CORBA_wchar)
AC_CHECK_ALIGNOF(CORBA_short)
AC_CHECK_ALIGNOF(CORBA_long)
AC_CHECK_ALIGNOF(CORBA_long_long)
AC_CHECK_ALIGNOF(CORBA_float)
AC_CHECK_ALIGNOF(CORBA_double)
AC_CHECK_ALIGNOF(CORBA_long_double)
AC_CHECK_ALIGNOF(CORBA_struct)
AC_CHECK_ALIGNOF(CORBA_pointer)
CPPFLAGS=$orig_CPPFLAGS 

if test "x$GCC" = "xyes" -a "x$enable_compile_warnings" != "xno"; then
    WARN_CFLAGS="-Wall -Wunused -Wmissing-prototypes -Wmissing-declarations"
else
    WARN_CFLAGS=
fi

AC_MSG_CHECKING(what warning flags to pass to the C compiler)
AC_MSG_RESULT($WARN_CFLAGS)
AC_SUBST(WARN_CFLAGS)

AC_SUBST(pkglibdir)

if test "$enable_maintainer_mode" = "yes"; then
	DISABLE_DEPRECATED_CFLAGS=" \
		-DG_DISABLE_SINGLE_INCLUDES"
	AC_SUBST(DISABLE_DEPRECATED_CFLAGS)
fi

dnl
dnl        --------- start linc bits ---------
dnl

dnl Checks for libraries.
PKG_CHECK_MODULES(LINC, glib-2.0 >= $GLIB_REQUIRED gobject-2.0 >= $GLIB_REQUIRED gthread-2.0 >= $GLIB_REQUIRED)
AC_SUBST(LINC_LIBS)
AC_SUBST(LINC_CFLAGS)

dnl Checks for header files.
AC_HEADER_STDC
AC_HEADER_RESOLV
AC_CHECK_HEADERS(fcntl.h unistd.h sys/endian.h endian.h machine/endian.h sys/machine.h sys/isa_defs.h sys/poll.h)
AC_CHECK_HEADERS(stddef.h wchar.h wcstr.h wctype.h machine/types.h)
AC_CHECK_HEADERS(netinet/in.h netinet/tcp.h sys/un.h)
AC_CHECK_HEADERS(arpa/nameser.h)
dnl AC_CHECK_HEADERS(linux/irda.h)

dnl Checks for library functions.
AC_CHECK_FUNCS(poll basename)
AC_CHECK_FUNC(res_init,,[AC_CHECK_LIB(resolv,res_init)])
AC_CHECK_LIB(resolv,res_9_init)
AC_CHECK_FUNC(socket,,[AC_CHECK_LIB(socket,socket)])
AC_CHECK_FUNC(gethostbyname,,[AC_CHECK_LIB(nsl,gethostbyname)])
AC_CHECK_FUNC(getaddrinfo,,[AC_CHECK_LIB(nsl,getaddrinfo)])
if test x"$ac_cv_func_getaddrinfo" = "xyes" ; then
	AC_DEFINE(HAVE_GETADDRINFO, 1, [Define if getaddrinfo() is available])
fi
AC_CHECK_FUNC(getnameinfo,,[AC_CHECK_LIB(nsl,getnameinfo)])
if test x"$ac_cv_func_getnameinfo" = "xyes" ; then
	AC_DEFINE(HAVE_GETNAMEINFO, 1, [Define if getnameinfo() is available])
fi
have_inet_pton=no
AC_CHECK_FUNC(inet_pton,,)
if test x"$ac_cv_func_inet_pton" = "xyes" ; then
	have_inet_pton=yes
        AC_DEFINE(HAVE_INET_PTON, 1, [Define if inet_pton() is available])
fi

# AC_CHECK_TYPE doesn't work here.
AC_MSG_CHECKING([for socklen_t])
AC_TRY_COMPILE(
  [#ifdef _WIN32
#include <ws2tcpip.h>
#else
#include <sys/types.h>
#include <sys/socket.h>
#endif],
  [socklen_t len;],
  [AC_MSG_RESULT(yes)],
  [AC_DEFINE(socklen_t, size_t, [Define socklen_t to be of type size_t])
   AC_MSG_RESULT(no)])

# Blatantly stolen from configure.in in the sample code from 
# "UNIX Network Programming, Volume 1" by W. Richard Stevens 
AC_CACHE_CHECK(if sockaddr has sa_len member,
ac_cv_sockaddr_has_sa_len,
        AC_TRY_COMPILE([
#               include <sys/types.h>
#               include <sys/socket.h>],
                [unsigned int i = sizeof(((struct sockaddr *)0)->sa_len)],
        ac_cv_sockaddr_has_sa_len=yes,
        ac_cv_sockaddr_has_sa_len=no))
if test x"$ac_cv_sockaddr_has_sa_len" = "xyes" ; then
        AC_DEFINE(HAVE_SOCKADDR_SA_LEN, 1, [Define if sockaddr has sa_len member])
fi

dnl
dnl        --------- end linc bits ---------
dnl

dnl
dnl --------- set additional gcc flags to catch errors ---------
dnl
AX_CFLAGS_GCC_OPTION(-Werror-implicit-function-declaration)
CFLAGS="$CFLAGS $ORBIT_DEBUG_CFLAGS"
AC_SUBST(CFLAGS)


dnl ----- gtk-doc ------
GTK_DOC_CHECK([1.0])


AC_CONFIG_FILES([
Makefile
orbit2-config
ORBit-2.0.pc
ORBit-2.0-uninstalled.pc
ORBit-CosNaming-2.0.pc
ORBit-CosNaming-2.0-uninstalled.pc
ORBit-imodule-2.0.pc
ORBit-imodule-2.0-uninstalled.pc
ORBit.spec
orbit2-zip
src/Makefile
src/idl-compiler/Makefile
src/idl-compiler/ORBit-idl-2.0.pc
src/idl/Makefile
src/idl/CORBA/Makefile
src/idl/CORBA_PIDL/Makefile
src/idl/interop/Makefile
src/idl/misc/Makefile
src/orb/Makefile
src/orb/include/Makefile
src/orb/util/Makefile
src/orb/GIOP/Makefile
src/orb/orb-core/Makefile
src/orb/dynamic/Makefile
src/orb/poa/Makefile
src/services/Makefile
src/services/name/Makefile
src/services/imodule/Makefile
include/Makefile
include/orbit/Makefile
include/orbit/orbit-config.h
include/orbit/GIOP/Makefile
include/orbit/util/Makefile
include/orbit/orb-core/Makefile
include/orbit/poa/Makefile
include/orbit/dynamic/Makefile
test/Makefile
test/everything/Makefile
test/inhibit/Makefile
test/poa/Makefile
docs/Makefile
docs/devel/Makefile
docs/internals/Makefile
docs/api/Makefile

linc2/Makefile
linc2/src/Makefile
linc2/test/Makefile
linc2/include/Makefile
linc2/include/linc/Makefile
linc2/include/linc/linc-config.h
])

AC_OUTPUT

echo "ORBit configuration:

	Source code location:	${srcdir}
	Compiler:		${CC} 

	Purify cleanliness:	${enable_purify}
"
