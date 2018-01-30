# ax_fgb.m4: An m4 macro to detect and configure fgb
#
# Copyright  2017 Marc Stevens <marc.stevens@cwi.nl>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# As a special exception to the GNU General Public License, if you
# distribute this file as part of a program that contains a
# configuration script generated by Autoconf, you may include it under
# the same distribution terms that you use for the rest of that program.
#

#
# SYNOPSIS
#       AX_FGB()
#
# DESCRIPTION
#       Checks the existence of FGb headers and libraries.
#       Options:
#       --with-fgb=(path|yes|no)
#               Indicates whether to use FGb or not, and the path of a non-standard
#               installation location of FGb if necessary.
#
#       This macro calls:
#               AC_SUBST(FGB_CPPFLAGS)
#               AC_SUBST(FGB_LDFLAGS)
#               AC_SUBST(FGB_LIB)
#
AC_DEFUN([AX_FGB],
[
FGBDIR=${FGBDIR:-$(pwd)/fgb/call_FGb}
AC_ARG_WITH([fgb], AS_HELP_STRING([--with-fgb@<:@=yes|no|DIR@:>@],[prefix where fgb is installed (default=autodetect)]),
[
	if test "$withval" = "no"; then
		want_fgb="no"
	elif test "$withval" = "yes"; then
		want_fgb="yes"
	else
		want_fgb="yes"
		FGBDIR=$withval
	fi
],[
	want_openf4="maybe"
]
)

have_fgb=no
if test "x$want_fgb" != "xno" && test -f "$FGBDIR/nv/maple/C/call_fgb.h"; then
	CPPFLAGS_SAVED="$CPPFLAGS"
	LDFLAGS_SAVED="$LDFLAGS"
	LIBS_SAVED="$LIBS"

	FGB_CPPFLAGS="-I$FGBDIR/nv/maple/C -I$FGBDIR/nv/int -I$FGBDIR/nv/protocol -fopenmp"
	FGB_LDFLAGS="-L$FGBDIR/nv/maple/C/x64 -fopenmp"
	FGB_LIB="-lfgb -lfgbexp -lgb -lgbexp -lminpoly -lminpolyvgf -lfgbdef -lgmp -lm"

	CPPFLAGS="$FGB_CPPFLAGS $CPPFLAGS"
	LDFLAGS="$FGB_LDFLAGS $LDFLAGS"
	LIBS="$FGB_LIB $LIBS"

	have_fgb=yes
	AC_CHECK_LIB(gmp, __gmpz_init,,[AC_MSG_WARN([fgb requires gmp])])
	AC_CHECK_FUNC(omp_get_num_threads,,[AC_MSG_WARN([fgb requires openmp])])
	AC_LANG_PUSH(C)
	AC_CHECK_HEADER([call_fgb.h],[],[have_fgb=no])
	AC_LANG_POP
	AC_LANG_PUSH(C++)
	AC_CHECK_HEADER([fgb.h],[],[have_fgb=no])
	AC_MSG_CHECKING(for usability of FGb)
	AC_TRY_RUN([
		#include <fgb.h>
		int main() {
                        return FGb_internal_version()==0;
                }
		],
		[AC_MSG_RESULT(yes)],
		[AC_MSG_RESULT(no)
		have_fgb=no])
	AC_LANG_POP
	CPPFLAGS="$CPPFLAGS_SAVED"
	LDFLAGS="$LDFLAGS_SAVED"
	LIBS="$LIBS_SAVED"
fi
if test "x$want_fgb" != "xno"; then
	AS_IF([test "x$have_fgb" = "xyes"],
		[AC_DEFINE(HAVE_FGB,1,[Define if FGb is installed])],
		[AS_IF([test "x$want_fgb" = "xyes"],[AC_MSG_ERROR(error: see log)],[])])
fi

AM_CONDITIONAL(HAVE_FGB, test "x${have_fgb}" = "xyes")

AC_SUBST(FGB_CPPFLAGS)
AC_SUBST(FGB_LDFLAGS)
AC_SUBST(FGB_LIB)

])
