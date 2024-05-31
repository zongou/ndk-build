PKG_HOMEPAGE=https://www.zlib.net/
PKG_DESCRIPTION="Compression library implementing the deflate compression method found in gzip and PKZIP"
PKG_LICENSE="ZLIB"

PKG_VERSION=1.3.1
PKG_BASENAME=zlib-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://zlib.net/fossils/${PKG_BASENAME}${PKG_EXTNAME}

configure() {
	./configure --static --archs="-fPIC" --prefix="${OUTPUT_DIR}"
}

build() {
	make -j"${JOBS}" install
}

check() {
	test -f "${OUTPUT_DIR}/lib/libz.a"
}