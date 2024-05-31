PKG_HOMEPAGE=https://notroj.github.io/neon/
PKG_DESCRIPTION="An HTTP/1.1 and WebDAV client library, with a C interface"
PKG_LICENSE="GPL-2.0, LGPL-2.0"

PKG_VERSION=0.32.5
PKG_BASENAME=neon-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://notroj.github.io/neon/${PKG_BASENAME}${PKG_EXTNAME}

depends() {
	echo libexpat
	echo openssl
	echo zlib
}

configure() {
	export LDFLAGS="-L${OUTPUT_DIR}/lib -lcrypto -lssl"
	./configure --enable-static --disable-shared --host="${TARGET}" --prefix="${OUTPUT_DIR}" --with-ssl=openssl --with-expat
}

build() {
	make -j"${JOBS}" install
}
