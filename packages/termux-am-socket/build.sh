PKG_HOMEPAGE=https://github.com/termux/termux-am-socket
PKG_DESCRIPTION="A faster version of am with less features that only works while Termux is running"
PKG_LICENSE="GPL-3.0"

PKG_VERSION=1.5.0
PKG_BASENAME=termux-am-socket-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://ghproxy.net/https://github.com/termux/termux-am-socket/archive/refs/tags/${PKG_VERSION}.tar.gz
PKG_SHA256=5175023c7fd675492451a72d06b75c772f257685b69fe117227bae5a5e6f5494
PKG_DEPENDS="libc++"

# step_post_get_source() {

# 	for file in "${PKG_SRCDIR}/"*; do
# 		sed -i'' -E -e "s|^(AM_SOCKET_VERSION=).*|\1$PKG_FULLVERSION|" \
# 			-e "s|\@APP_PACKAGE\@|${APP_PACKAGE}|g" \
# 			-e "s|\@APPS_DIR\@|${APPS_DIR}|g" \
# 			"$file"
# 	done

# }

configure() {
	export LDFLAGS="-w -s"
	export TERMUX_APP_PACKAGE=my.term
	export TERMUX_APPS_DIR=/data/data/${TERMUX_APP_PACKAGE}/files/apps

	rm -rf build && mkdir build && cd build
	cmake .. -DTERMUX_APPS_DIR="${TERMUX_APPS_DIR}" -DTERMUX_APP_PACKAGE=${TERMUX_APP_PACKAGE}
	make CFLAGS="-O3 -lto"
	du -ahd0 termux-am-socket
	file termux-am-socket
	install -Dt "${OUTPUT_DIR}/bin" termux-am-socket
}
