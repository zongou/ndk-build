PKG_HOMEPAGE=https://libexpat.github.io/
PKG_DESCRIPTION="XML parsing C library"
PKG_LICENSE="MIT"
PKG_EXTRA_CONFIGURE_ARGS="--without-xmlwf --without-docbook"

PKG_VERSION="2.6.2"
PKG_BASENAME=expat-${PKG_VERSION}
PKG_EXTNAME=.tar.xz
PKG_SRCURL=https://github.com/libexpat/libexpat/releases/download/R_$(echo "${PKG_VERSION}" | tr . _)/${PKG_BASENAME}${PKG_EXTNAME}

configure() {
	./configure --host="${TARGET}" --prefix="${OUTPUT_DIR}"
}

build() {
	make -j"${JOBS}" install
}

check() {
	test -f "${OUTPUT_DIR}/lib/libexpat.a"
}
