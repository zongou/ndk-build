PKG_HOMEPAGE=https://www.gnu.org/software/make/
PKG_DESCRIPTION="Tool to control the generation of non-source files from source files"
PKG_LICENSE="GPL-3.0"

PKG_VERSION="4.4.1"
PKG_BASENAME=make-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL="https://ftp.gnu.org/gnu/make/make-${PKG_VERSION}${PKG_EXTNAME}"

configure() {
	# Prevent linking against libelf:
	EXTRA_CONFIGURE_ARGS="${EXTRA_CONFIGURE_ARGS:-} ac_cv_lib_elf_elf_begin=no"
	# Prevent linking against libiconv:
	EXTRA_CONFIGURE_ARGS="${EXTRA_CONFIGURE_ARGS:-} am_cv_func_iconv=no"
	# Prevent linking against guile:
	EXTRA_CONFIGURE_ARGS="${EXTRA_CONFIGURE_ARGS:-} --without-guile"

	if test "$ABI" = "armv7a"; then
		# Fix issue with make on arm hanging at least under cmake:
		# https://github.com/termux/termux-packages/issues/2983
		EXTRA_CONFIGURE_ARGS="${EXTRA_CONFIGURE_ARGS:-} ac_cv_func_pselect=no"
	fi

	## Add to toolchain search dirs
	# export CFLAGS="-I${OUTPUT_DIR}/include"
	# export LDFLAGS="-L${OUTPUT_DIR}/lib"

	## Make small size stripped
	export CFLAGS="${CFLAGS+${CFLAGS}} -Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
	export LDFLAGS="${LDFLAGS+${LDFLAGS}} -ffunction-sections -fdata-sections -Wl,--gc-sections -s"

	## Make static linked
	# export LDFLAGS="${LDFLAGS+${LDFLAGS}} -static -ldl"

	## Statically linked reports TLS alignment error

	# shellcheck disable=SC2086
	./configure \
		--host="${TARGET}" \
		--prefix="${OUTPUT_DIR}" \
		${EXTRA_CONFIGURE_ARGS}
}

build() {
	if command -v make >/dev/null; then
		make -j"${JOBS}" install
	else
		./build.sh
		mkdir -p "${OUTPUT_DIR}/bin"
		install make "${OUTPUT_DIR}/bin/make"
	fi
}

check() {
	test -f "${OUTPUT_DIR}/bin/make"
}
