PKG_HOMEPAGE=https://github.com/termux/termux-am-socket
PKG_DESCRIPTION="A faster version of am with less features that only works while Termux is running"
PKG_LICENSE="GPL-3.0"

PKG_VERSION=1.5.0
PKG_SRCURL=https://github.com/termux/termux-am-socket/archive/refs/tags/${PKG_VERSION}.tar.gz

# PKG_DEPENDS="libc++"
PKG_BASENAME=termux-am-socket-${PKG_VERSION}

build() {
	export LDFLAGS="-w -s"
	export TERMUX_APP_PACKAGE=my.term
	export TERMUX_APPS_DIR=/data/data/${TERMUX_APP_PACKAGE}/files/apps

	rm -rf build && mkdir build && cd build
	cmake .. -DTERMUX_APPS_DIR="${TERMUX_APPS_DIR}" -DTERMUX_APP_PACKAGE=${TERMUX_APP_PACKAGE}
	make -j"${JOBS}"
	install -Dt "${OUTPUT_DIR}/bin" termux-am-socket
}
