## To use, export env TERMINFO=<path_to_terminfo>

PKG_HOMEPAGE=https://tmux.github.io/
PKG_DESCRIPTION="Terminal multiplexer"
PKG_LICENSE="ISC"
_COMMIT=fbe6fe7f55cfc2a32f9cee4cb50502a53d3ce8bb
_COMMIT_DATE=20230428

PKG_VERSION=3.4
PKG_BASENAME=tmux-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
# PKG_SRCURL=https://github.com/tmux/tmux/releases/download/${PKG_VERSION}/${PKG_BASENAME}${PKG_EXTNAME}
PKG_SRCURL=https://github.com/tmux/tmux/archive/refs/tags/3.4.tar.gz

PKG_SHA256=b61189533139bb84bdc0e96546a5420c183d7ba946a559e891d313c1c32d953d
PKG_GIT_BRANCH=master
PKG_AUTO_UPDATE=false
# Link against libandroid-support for wcwidth(), see https://github.com/termux/termux-packages/issues/224
PKG_DEPENDS="ncurses, libevent, libandroid-support, libandroid-glob"
# Set default TERM to screen-256color, see: https://raw.githubusercontent.com/tmux/tmux/3.3/CHANGES
PKG_EXTRA_CONFIGURE_ARGS="--disable-static --with-TERM=screen-256color"

PKG_CONFFILES="etc/tmux.conf etc/profile.d/tmux.sh"

# termux_step_post_get_source() {
# 	git fetch --unshallow
# 	git checkout $_COMMIT

# 	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
# 	if [[ "$PKG_VERSION" != *"${pdate}" ]]; then
# 		echo -n "ERROR: The version string \"$PKG_VERSION\" is"
# 		echo -n " different from what is expected to be; should end"
# 		echo " with \"${pdate}\"."
# 		return 1
# 	fi

# 	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
# 	if [[ "${s}" != "${PKG_SHA256}  "* ]]; then
# 		termux_error_exit "Checksum mismatch for source files."
# 	fi
# }

# termux_step_pre_configure() {
# 	LDFLAGS+=" -landroid-glob"
# 	./autogen.sh
# }

# termux_step_post_make_install() {
# 	cp "$PKG_BUILDER_DIR"/tmux.conf "$PREFIX"/etc/tmux.conf

# 	mkdir -p "$PREFIX"/etc/profile.d
# 	echo "export TMUX_TMPDIR=$PREFIX/var/run" >"$PREFIX"/etc/profile.d/tmux.sh

# 	mkdir -p "$PREFIX"/share/bash-completion/completions
# 	termux_download \
# 		https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux \
# 		"$PREFIX"/share/bash-completion/completions/tmux \
# 		05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae
# }

# termux_step_post_massage() {
# 	mkdir -p "${PKG_MASSAGEDIR}/${PREFIX}"/var/run
# }

depends() {
	# echo "libglob"
	echo "libevent"
	echo "ncurses"
}

# prepare_source() {
# 	cd /media/user/RD20/repos/ndk-pkgs/build/tmux-3.4
# 	git reset --hard
# 	git clean -xdf
# }

configure() {
	# langinfo requires API >= 26
	API=28
	

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
	export CFLAGS="-I${OUTPUT_DIR}/include"
	export LDFLAGS="-L${OUTPUT_DIR}/lib"

	## Make small size stripped
	export CFLAGS="${CFLAGS} -Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
	export LDFLAGS="${LDFLAGS} -ffunction-sections -fdata-sections -Wl,--gc-sections -s"

	## Make static linked
	export LDFLAGS="${LDFLAGS} -static"

	# ./configure --host="${TARGET}" --prefix="${OUTPUT_DIR}" --enable-static --with-TERM=screen-256color --enable-sixel
	./configure --host="${TARGET}" --prefix="${OUTPUT_DIR}" --enable-static --enable-sixel
}

build() {
	make -j"${JOBS}" install
}
