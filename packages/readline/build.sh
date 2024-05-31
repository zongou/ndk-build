PKG_HOMEPAGE="https://tiswww.case.edu/php/chet/readline/rltop.html"
PKG_DESCRIPTION="Library that allow users to edit command lines as they are typed in"
PKG_LICENSE="GPL-3.0"

PKG_DEPENDS="libandroid-support, ncurses"
PKG_BREAKS="bash (<< 5.0), readline-dev"
PKG_REPLACES="readline-dev"
PKG_SHA256=3feb7171f16a84ee82ca18a36d7b9be109a52c04f492a053331d7d1095007c35
PKG_EXTRA_CONFIGURE_ARGS="--with-curses --enable-multibyte bash_cv_wcwidth_broken=no"
PKG_EXTRA_MAKE_ARGS="SHLIB_LIBS=-lncursesw"
PKG_CONFFILES="etc/inputrc"

PKG_VERSION=8.2
PKG_BASENAME=readline-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://mirrors.kernel.org/gnu/readline/${PKG_BASENAME}${PKG_EXTNAME}
PKG_SRCURL=https://ftp.gnu.org/gnu/readline/${PKG_BASENAME}${PKG_EXTNAME}

depends() {
	echo ncurses
}

configure() {
	sed -i 's^/etc/inputrc^/data/data/com.xterm/files/usr/etc/inputrc^g' rlconf.h

	CFLAGS="${CFLAGS-} -fexceptions"
	export LDFLAGS="-L${OUTPUT_DIR}/lib"
	./configure --host="${TARGET}" --prefix="${OUTPUT_DIR}" --with-curses --enable-multibyte bash_cv_wcwidth_broken=no
}

build() {
	make SHLIB_LIBS=-lncursesw -j"${JOBS}" install

	mkdir -p "${OUTPUT_DIR}/lib/pkgconfig"
	cp readline.pc "${OUTPUT_DIR}/lib/pkgconfig/"

	mkdir -p "${OUTPUT_DIR}/etc"
	cp "${PKG_CONFIG_DIR}/inputrc" "${OUTPUT_DIR}/etc/"
}

check() {
	test -f "${OUTPUT_DIR}/libreadline.a"
}
