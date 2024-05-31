PKG_HOMEPAGE=https://www.gnu.org/software/gzip/
PKG_DESCRIPTION="Standard GNU file compression utilities"
PKG_LICENSE="GPL-3.0"

PKG_VERSION=1.13
PKG_BASENAME=gzip-${PKG_VERSION}
PKG_EXTNAME=.tar.xz
PKG_SRCURL=https://ftp.gnu.org/gnu/gzip/${PKG_BASENAME}${PKG_EXTNAME}

configure() {
	## Small build, stripped
	export CFLAGS="-Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
	export LDFLAGS="-Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections"

	./configure \
		ac_cv_path_GREP=grep \
		--prefix="${OUTPUT_DIR}" \
		--host="${TARGET}"
}

build() {
	make -j"${JOBS}" install
}

check() {
	test -f "${OUTPUT_DIR}/bin/gzip"
}
