## To use, export env TERMINFO=<path_to_terminfo>

PKG_HOMEPAGE=https://tmux.github.io/
PKG_DESCRIPTION="Terminal multiplexer"
PKG_LICENSE="ISC"
_COMMIT=fbe6fe7f55cfc2a32f9cee4cb50502a53d3ce8bb
_COMMIT_DATE=20230428

PKG_VERSION=3.4
# PKG_SRCURL=https://github.com/tmux/tmux/releases/download/${PKG_VERSION}/${PKG_BASENAME}.tar.gz
PKG_SRCURL=https://github.com/tmux/tmux/archive/refs/tags/3.4.tar.gz

# Link against libandroid-support for wcwidth(), see https://github.com/termux/termux-packages/issues/224
# Set default TERM to screen-256color, see: https://raw.githubusercontent.com/tmux/tmux/3.3/CHANGES
PKG_EXTRA_CONFIGURE_ARGS="--disable-static --with-TERM=screen-256color"
PKG_CONFFILES="etc/tmux.conf etc/profile.d/tmux.sh"

# PKG_DEPENDS="ncurses libevent libandroid-support libandroid-glob"
PKG_DEPENDS="ncurses libevent"
PKG_BASENAME=tmux-${PKG_VERSION}

configure() {
	# langinfo requires API >= 26	
	patch -up1 <"${PKG_CONFIG_DIR}/configure.ac.patch"
	./autogen.sh
	# exit

	sed -i '1i #include<sys/endian.h>' compat/htonll.c
	patch -up1 <"${PKG_CONFIG_DIR}/compat-setproctitle.c.patch"
	sed -i '1i #include<sys/endian.h>' compat/ntohll.c
	patch -up1 <"${PKG_CONFIG_DIR}/compat-imsg.c.patch"

	## Socket path
	# sed -i 's^#define TMUX_SOCK "$TMUX_TMPDIR:" _PATH_TMP^#define TMUX_SOCK "$TMUX_TMPDIR:" _PATH_TMP^' tmux.h

	## Add to toolchain search dirs
	export CFLAGS="-I${OUTPUT_DIR}/include -I${OUTPUT_DIR}/include/ncursesw"
	export LDFLAGS="-L${OUTPUT_DIR}/lib -ldl"

	# ./configure --host="${TARGET}" --prefix="${OUTPUT_DIR}" --enable-static --with-TERM=screen-256color --enable-sixel
	./configure --host="${TARGET}" --prefix="${OUTPUT_DIR}" --enable-sixel
}

build() {
	make -j"${JOBS}" install
}
