PKG_HOMEPAGE=https://invisible-island.net/ncurses/
PKG_DESCRIPTION="Library for text-based user interfaces in a terminal-independent manner"
PKG_LICENSE="MIT"

PKG_EXTNAME=.tar.gz
PKG_VERSION=6.4
PKG_BASENAME=ncurses-${PKG_VERSION}
PKG_SRCURL=https://ftp.gnu.org/gnu/ncurses/${PKG_BASENAME}${PKG_EXTNAME}

configure() {
	./configure \
		--host="${TARGET}" \
		--prefix="${OUTPUT_DIR}" \
		--with-pkg-config-libdir="${OUTPUT_DIR}/lib/pkgconfig" \
		--with-cxx-shared \
		--with-shared \
		--without-ada \
		--without-tests \
		--without-debug \
		--without-valgrind \
		--enable-const \
		--enable-widec \
		--enable-termcap \
		--enable-warnings \
		--enable-pc-files \
		--enable-ext-mouse \
		--enable-ext-colors \
		--disable-stripping \
		--disable-assertions \
		--disable-gnat-projects \
		--disable-echo
}

build() {
	make -j"${JOBS}" install
}

check() {
	test -f "${OUTPUT_DIR}/lib/libncursesw.a"
}
