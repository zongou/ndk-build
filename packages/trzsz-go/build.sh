PKG_HOMEPAGE=https://trzsz.github.io/
PKG_DESCRIPTION="A simple file transfer tools, similar to lrzsz ( rz / sz )"
PKG_LICENSE="MIT"

PKG_VERSION="1.1.7"
PKG_BASENAME=trzsz-go-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/trzsz/trzsz-go/archive/refs/tags/v${PKG_VERSION}.tar.gz
PKG_SHA256=ad9f47591d1b2cd6c76e44cf0bcac55906bdff9305d38ad1040bb77529ee3781

# PKG_EXTRA_MAKE_ARGS="
# BIN_DST=$PREFIX/bin
# "

build() {
	setup_golang
	make BIN_DST="${OUTPUT_DIR}" -j"${JOBS}" install
}
