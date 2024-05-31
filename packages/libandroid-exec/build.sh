PKG_HOMEPAGE=https://github.com/zongou/libandroid-exec
PKG_DESCRIPTION="A execve() wrapper to fix problem with shebangs."
PKG_LICENSE="Apache-2.0"

PKG_VERSION=main
PKG_BASENAME=libandroid-exec-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/zongou/libandroid-exec/archive/refs/heads/main.tar.gz

build() {
	export LDFLAGS="-s"
	mkdir -p "${OUTPUT_DIR}/lib"
	make PREFIX="${OUTPUT_DIR}" install
}

check() {
	test -f "${OUTPUT_DIR}/lib/libandroid-exec.so"
}
