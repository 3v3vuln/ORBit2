#######################
# type alignment test #
#######################

AC_DEFUN([AC_CHECK_ALIGNOF],
	[changequote(<<, >>)dnl
	dnl The name to #define.
	define(<<AC_TYPE_NAME>>,
		translit(orbit_alignof_$1, [a-z *], [A-Z_P]))dnl
	dnl The cache variable name.
	define(<<AC_CV_NAME>>,
		translit(ac_cv_alignof_$1, [ *], [_p]))dnl
	changequote([, ])dnl
	AC_MSG_CHECKING(alignment of $1)
	align_save_libs="$LIBS"
	LIBS="$ORBIT_LIBS $LIBS"
	AC_CACHE_VAL(AC_CV_NAME,
		[AC_TRY_RUN(
			[ #include <stdio.h>
                          #include <stdlib.h>

			#include "$srcdir/include/orbit/util/basic_types.h"
			typedef struct {char s1;} CORBA_struct;
			typedef void *CORBA_pointer;
			struct test {char s1; $1 s2;};
			main()
			{
			FILE *f=fopen("conftestval", "w");
			if (!f) exit(1);
			fprintf(f, "%d\n", &(((struct test*)0)->s2));
			exit(0);
			} ],
			AC_CV_NAME=`cat conftestval`,
			AC_CV_NAME=0, AC_CV_NAME=0)
		])dnl
	AC_MSG_RESULT($AC_CV_NAME)
	if test "$AC_CV_NAME" = "0" ; then
		AC_MSG_ERROR([Failed to find alignment. Check config.log for details.])
	fi
	LIBS="$align_save_libs"
	AC_TYPE_NAME=$AC_CV_NAME
	AC_SUBST(AC_TYPE_NAME)
	undefine([AC_TYPE_NAME])dnl
	undefine([AC_CV_NAME])dnl
])


dnl @synopsis AX_CFLAGS_GCC_OPTION (optionflag [,[shellvar][,[A][,[NA]]])
dnl
dnl AX_CFLAGS_GCC_OPTION(-fvomit-frame) would show a message as like
dnl "checking CFLAGS for gcc -fvomit-frame ... yes" and adds
dnl the optionflag to CFLAGS if it is understood. You can override
dnl the shellvar-default of CFLAGS of course. The order of arguments
dnl stems from the explicit macros like AX_CFLAGS_WARN_ALL.
dnl
dnl The cousin AX_CXXFLAGS_GCC_OPTION would check for an option to add
dnl to CXXFLAGS - and it uses the autoconf setup for C++ instead of C
dnl (since it is possible to use different compilers for C and C++).
dnl
dnl The macro is a lot simpler than any special AX_CFLAGS_* macro (or
dnl ac_cxx_rtti.m4 macro) but allows to check for arbitrary options.
dnl However, if you use this macro in a few places, it would be great
dnl if you would make up a new function-macro and submit it to the
dnl ac-archive.
dnl
dnl   - $1 option-to-check-for : required ("-option" as non-value)
dnl   - $2 shell-variable-to-add-to : CFLAGS (or CXXFLAGS in the other case)
dnl   - $3 action-if-found : add value to shellvariable
dnl   - $4 action-if-not-found : nothing
dnl
dnl note: in earlier versions, $1-$2 were swapped. We try to detect the
dnl situation and accept a $2=~/-/ as being the old option-to-check-for.
dnl
dnl also: there are other variants that emerged from the original macro
dnl variant which did just test an option to be possibly added. However,
dnl some compilers accept an option silently, or possibly for just
dnl another option that was not intended. Therefore, we have to do a
dnl generic test for a compiler family. For gcc we check "-pedantic"
dnl being accepted which is also understood by compilers who just want
dnl to be compatible with gcc even when not being made from gcc sources.
dnl
dnl see also:
dnl       AX_CFLAGS_SUN_OPTION               AX_CFLAGS_HPUX_OPTION
dnl       AX_CFLAGS_AIX_OPTION               AX_CFLAGS_IRIX_OPTION
dnl
dnl @, tested, experimental
dnl @version $Id$
dnl @author Guido Draheim <guidod@gmx.de>
dnl
AC_DEFUN([AX_CFLAGS_GCC_OPTION_OLD], [dnl
AS_VAR_PUSHDEF([FLAGS],[CFLAGS])dnl
AS_VAR_PUSHDEF([VAR],[ac_cv_cflags_gcc_option_$2])dnl
AC_CACHE_CHECK([m4_ifval($1,$1,FLAGS) for gcc m4_ifval($2,$2,-option)],
VAR,[VAR="no, unknown"
 AC_LANG_SAVE
 AC_LANG_C
 ac_save_[]FLAGS="$[]FLAGS"
for ac_arg dnl
in "-pedantic  % m4_ifval($2,$2,-option)"  dnl   GCC
   #
do FLAGS="$ac_save_[]FLAGS "`echo $ac_arg | sed -e 's,%%.*,,' -e 's,%,,'`
   AC_TRY_COMPILE([],[return 0;],
   [VAR=`echo $ac_arg | sed -e 's,.*% *,,'` ; break])
done
 FLAGS="$ac_save_[]FLAGS"
 AC_LANG_RESTORE
])
case ".$VAR" in
     .ok|.ok,*) m4_ifvaln($3,$3) ;;
   .|.no|.no,*) m4_ifvaln($4,$4) ;;
   *) m4_ifvaln($3,$3,[
   if echo " $[]m4_ifval($1,$1,FLAGS) " | grep " $VAR " 2>&1 >/dev/null
   then AC_RUN_LOG([: m4_ifval($1,$1,FLAGS) does contain $VAR])
   else AC_RUN_LOG([: m4_ifval($1,$1,FLAGS)="$m4_ifval($1,$1,FLAGS) $VAR"])
                      m4_ifval($1,$1,FLAGS)="$m4_ifval($1,$1,FLAGS) $VAR"
   fi ]) ;;
esac
AS_VAR_POPDEF([VAR])dnl
AS_VAR_POPDEF([FLAGS])dnl
])


dnl the only difference - the LANG selection... and the default FLAGS

AC_DEFUN([AX_CXXFLAGS_GCC_OPTION_OLD], [dnl
AS_VAR_PUSHDEF([FLAGS],[CXXFLAGS])dnl
AS_VAR_PUSHDEF([VAR],[ac_cv_cxxflags_gcc_option_$2])dnl
AC_CACHE_CHECK([m4_ifval($1,$1,FLAGS) for gcc m4_ifval($2,$2,-option)],
VAR,[VAR="no, unknown"
 AC_LANG_SAVE
 AC_LANG_CXX
 ac_save_[]FLAGS="$[]FLAGS"
for ac_arg dnl
in "-pedantic  % m4_ifval($2,$2,-option)"  dnl   GCC
   #
do FLAGS="$ac_save_[]FLAGS "`echo $ac_arg | sed -e 's,%%.*,,' -e 's,%,,'`
   AC_TRY_COMPILE([],[return 0;],
   [VAR=`echo $ac_arg | sed -e 's,.*% *,,'` ; break])
done
 FLAGS="$ac_save_[]FLAGS"
 AC_LANG_RESTORE
])
case ".$VAR" in
     .ok|.ok,*) m4_ifvaln($3,$3) ;;
   .|.no|.no,*) m4_ifvaln($4,$4) ;;
   *) m4_ifvaln($3,$3,[
   if echo " $[]m4_ifval($1,$1,FLAGS) " | grep " $VAR " 2>&1 >/dev/null
   then AC_RUN_LOG([: m4_ifval($1,$1,FLAGS) does contain $VAR])
   else AC_RUN_LOG([: m4_ifval($1,$1,FLAGS)="$m4_ifval($1,$1,FLAGS) $VAR"])
                      m4_ifval($1,$1,FLAGS)="$m4_ifval($1,$1,FLAGS) $VAR"
   fi ]) ;;
esac
AS_VAR_POPDEF([VAR])dnl
AS_VAR_POPDEF([FLAGS])dnl
])

dnl -------------------------------------------------------------------------

AC_DEFUN([AX_CFLAGS_GCC_OPTION_NEW], [dnl
AS_VAR_PUSHDEF([FLAGS],[CFLAGS])dnl
AS_VAR_PUSHDEF([VAR],[ac_cv_cflags_gcc_option_$1])dnl
AC_CACHE_CHECK([m4_ifval($2,$2,FLAGS) for gcc m4_ifval($1,$1,-option)],
VAR,[VAR="no, unknown"
 AC_LANG_SAVE
 AC_LANG_C
 ac_save_[]FLAGS="$[]FLAGS"
for ac_arg dnl
in "-pedantic  % m4_ifval($1,$1,-option)"  dnl   GCC
   #
do FLAGS="$ac_save_[]FLAGS "`echo $ac_arg | sed -e 's,%%.*,,' -e 's,%,,'`
   AC_TRY_COMPILE([],[return 0;],
   [VAR=`echo $ac_arg | sed -e 's,.*% *,,'` ; break])
done
 FLAGS="$ac_save_[]FLAGS"
 AC_LANG_RESTORE
])
case ".$VAR" in
     .ok|.ok,*) m4_ifvaln($3,$3) ;;
   .|.no|.no,*) m4_ifvaln($4,$4) ;;
   *) m4_ifvaln($3,$3,[
   if echo " $[]m4_ifval($2,$2,FLAGS) " | grep " $VAR " 2>&1 >/dev/null
   then AC_RUN_LOG([: m4_ifval($2,$2,FLAGS) does contain $VAR])
   else AC_RUN_LOG([: m4_ifval($2,$2,FLAGS)="$m4_ifval($2,$2,FLAGS) $VAR"])
                      m4_ifval($2,$2,FLAGS)="$m4_ifval($2,$2,FLAGS) $VAR"
   fi ]) ;;
esac
AS_VAR_POPDEF([VAR])dnl
AS_VAR_POPDEF([FLAGS])dnl
])


dnl the only difference - the LANG selection... and the default FLAGS

AC_DEFUN([AX_CXXFLAGS_GCC_OPTION_NEW], [dnl
AS_VAR_PUSHDEF([FLAGS],[CXXFLAGS])dnl
AS_VAR_PUSHDEF([VAR],[ac_cv_cxxflags_gcc_option_$1])dnl
AC_CACHE_CHECK([m4_ifval($2,$2,FLAGS) for gcc m4_ifval($1,$1,-option)],
VAR,[VAR="no, unknown"
 AC_LANG_SAVE
 AC_LANG_CXX
 ac_save_[]FLAGS="$[]FLAGS"
for ac_arg dnl
in "-pedantic  % m4_ifval($1,$1,-option)"  dnl   GCC
   #
do FLAGS="$ac_save_[]FLAGS "`echo $ac_arg | sed -e 's,%%.*,,' -e 's,%,,'`
   AC_TRY_COMPILE([],[return 0;],
   [VAR=`echo $ac_arg | sed -e 's,.*% *,,'` ; break])
done
 FLAGS="$ac_save_[]FLAGS"
 AC_LANG_RESTORE
])
case ".$VAR" in
     .ok|.ok,*) m4_ifvaln($3,$3) ;;
   .|.no|.no,*) m4_ifvaln($4,$4) ;;
   *) m4_ifvaln($3,$3,[
   if echo " $[]m4_ifval($2,$2,FLAGS) " | grep " $VAR " 2>&1 >/dev/null
   then AC_RUN_LOG([: m4_ifval($2,$2,FLAGS) does contain $VAR])
   else AC_RUN_LOG([: m4_ifval($2,$2,FLAGS)="$m4_ifval($2,$2,FLAGS) $VAR"])
                      m4_ifval($2,$2,FLAGS)="$m4_ifval($2,$2,FLAGS) $VAR"
   fi ]) ;;
esac
AS_VAR_POPDEF([VAR])dnl
AS_VAR_POPDEF([FLAGS])dnl
])

AC_DEFUN([AX_CFLAGS_GCC_OPTION],[ifelse(m4_bregexp([$2],[-]),-1,
[AX_CFLAGS_GCC_OPTION_NEW($@)],[AX_CFLAGS_GCC_OPTION_OLD($@)])])

AC_DEFUN([AX_CXXFLAGS_GCC_OPTION],[ifelse(m4_bregexp([$2],[-]),-1,
[AX_CXXFLAGS_GCC_OPTION_NEW($@)],[AX_CXXFLAGS_GCC_OPTION_OLD($@)])])
