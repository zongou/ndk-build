PKG_HOMEPAGE=https://github.com/aandrew-me/tgpt
PKG_DESCRIPTION="Command line interface to test internet speed using speedtest.net"
PKG_LICENSE="GPL-3.0"
PKG_VERSION="2.8.0"
PKG_SRCURL=https://github.com/aandrew-me/tgpt/archive/refs/tags/v${PKG_VERSION}.tar.gz

PKG_BASENAME=tgpt-${PKG_VERSION}
BUILD_PREFIX="${GO_BUILD_DIR}"

build() {
	setup_golang
	go build -ldflags='-w -s'
	install -Dt "${OUTPUT_DIR}/bin" tgpt
}
