PKG_VERSION="2.1.12"
PKG_SRCURL=https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/${PKG_BASENAME}.tar.gz

PKG_BASENAME=libevent-2.1.12-stable
PKG_DEPENDS="openssl"

configure() {
	./autogen.sh
	./configure CFLAGS="-I${OUTPUT_DIR}/include" LDFLAGS="-L${OUTPUT_DIR}/lib" --host="${TARGET}" --prefix="${OUTPUT_DIR}"
}

build() {
	make -j"${JOBS}" install
}

check() {
	test -f "${OUTPUT_DIR}/lib/libevent.a"
}
