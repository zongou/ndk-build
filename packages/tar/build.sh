PKG_HOMEPAGE=https://www.gnu.org/software/tar/
PKG_DESCRIPTION="GNU tar for manipulating tar archives"
PKG_LICENSE="GPL-3.0"

PKG_VERSION=1.35
PKG_BASENAME=tar-${PKG_VERSION}
PKG_EXTNAME=.tar.xz
PKG_SRCURL=https://ftp.gnu.org/gnu/tar/${PKG_BASENAME}${PKG_EXTNAME}

configure() {
	API=28
	

	# When cross-compiling configure guesses that d_ino in struct dirent only exists
	# if triplet matches linux*-gnu*, so we force set it explicitly:
	PKG_EXTNAMERA_CONFIGURE_ARGS="gl_cv_struct_dirent_d_ino=yes"
	# this needed to disable tar's implementation of mkfifoat() so it is possible
	# to use own implementation (see patch 'mkfifoat.patch').
	PKG_EXTNAMERA_CONFIGURE_ARGS="${PKG_EXTNAMERA_CONFIGURE_ARGS} ac_cv_func_mkfifoat=yes"

	case "${TARGET}" in
	armv7*)
		# https://android.googlesource.com/platform/bionic/+/master/docs/32-bit-abi.md#is-32_bit-on-lp32-y2038
		PKG_EXTNAMERA_CONFIGURE_ARGS="${PKG_EXTNAMERA_CONFIGURE_ARGS} --disable-year2038"
		;;
	esac

	sed -i 's/!defined __UCLIBC__)/!defined __UCLIBC__) || defined __ANDROID__/' gnu/vasnprintf.c #1
	sed -i "s/USE_FORTIFY_LEVEL/BIONIC_FORTIFY/g" gnu/cdefs.h                                     #3
	sed -i "s/USE_FORTIFY_LEVEL/BIONIC_FORTIFY/g" gnu/stdio.in.h                                  #3

	## Error glob not defined => Build with api >=28 or with libglob
	## https://github.com/android/ndk/issues/702
	# ./configure CFLAGS="-I${OUTPUT_DIR}/include" LDFLAGS="-s -L${OUTPUT_DIR}/lib" LIBS="-lglob" \

	export CPPFLAGS="-D__USE_FORTIFY_LEVEL=0 -D__POSIX_VISIBLE=199209 -D__BSD_VISIBLE"

	./configure \
		--host="${TARGET}" \
		--prefix="${OUTPUT_DIR}" \
		--disable-nls
}

build() {
	make -j"${JOBS}" install
}
