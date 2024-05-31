PKG_HOMEPAGE=https://xz.tukaani.org/xz-utils/
PKG_DESCRIPTION="XZ-format compression library"
PKG_LICENSE="LGPL-2.1, GPL-2.0, GPL-3.0"
PKG_LICENSE_FILE="COPYING, COPYING.GPLv2, COPYING.GPLv3, COPYING.LGPLv2.1"

PKG_VERSION="5.4.5"
PKG_BASENAME="xz-${PKG_VERSION}"
PKG_EXTNAME=.tar.gz
# PKG_SRCURL=https://tukaani.org/xz/${PKG_BASENAME}${PKG_EXTNAME}
PKG_SRCURL=https://github.com/tukaani-project/xz/releases/download/v${PKG_VERSION}/${PKG_BASENAME}${PKG_EXTNAME}

configure() {
	## Small build, stripped
	export CFLAGS="-Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
	export LDFLAGS="-Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections"

	export LDFLAGS="-w -s"
	./configure \
		--enable-static \
		--disable-shared \
		--prefix="${OUTPUT_DIR}" \
		--host="${TARGET}"
}

build() {
	make -j"${JOBS}" install
}

check() {
	test -f "${OUTPUT_DIR}/lib/liblzma.a"
}
