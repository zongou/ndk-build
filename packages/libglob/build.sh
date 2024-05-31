PKG_HOMEPAGE=https://www.zlib.net/
PKG_DESCRIPTION="Compression library implementing the deflate compression method found in gzip and PKZIP"
PKG_LICENSE="ZLIB"

PKG_VERSION='master'
PKG_BASENAME=libglob-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/leleliu008/libglob/archive/refs/heads/${PKG_VERSION}${PKG_EXTNAME}

configure() {
	rm -rf build && mkdir -p build && cd build
	cmake \
		-DCMAKE_INSTALL_PREFIX="${OUTPUT_DIR}" \
		..
}

build() {
	make -C build -j"${JOBS}" install
}

check() {
	test -f "${OUTPUT_DIR}/lib/libglob.so"
}
