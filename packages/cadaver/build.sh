PKG_HOMEPAGE=https://notroj.github.io/cadaver/
PKG_DESCRIPTION="A command-line WebDAV client for Unix"
PKG_LICENSE="GPL-2.0"
PKG_DEPENDS="libneon, readline"

PKG_VERSION=0.24
PKG_BASENAME=cadaver-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://notroj.github.io/cadaver/${PKG_BASENAME}${PKG_EXTNAME}

depends() {
	echo libneon
	echo readline
}

configure() {
	## Add neon-config to path
	export PATH="${PATH}:${OUTPUT_DIR}/bin"
	./configure --prefix="${OUTPUT_DIR}" --host="${TARGET}" --disable-nls --enable-readline

}

build() {
	make -j"${JOBS}" install
}
