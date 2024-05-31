PKG_HOMEPAGE=https://github.com/showwin/speedtest-go/
PKG_DESCRIPTION="Command line interface to test internet speed using speedtest.net"
PKG_LICENSE="MIT"
PKG_VERSION="1.7.7"
PKG_SRCURL=https://github.com/showwin/speedtest-go/archive/refs/tags/v${PKG_VERSION}.tar.gz

PKG_BASENAME=speedtest-go-${PKG_VERSION}
BUILD_PREFIX=${SCRIPT_DIR}/build/go

build() {
	setup_golang
	go build -ldflags='-w -s'
	install -Dt "${OUTPUT_DIR}/bin" speedtest-go
	file speedtest-go
}
