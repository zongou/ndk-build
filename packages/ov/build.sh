PKG_HOMEPAGE=https://github.com/noborus/ov
PKG_DESCRIPTION="🎑Feature-rich terminal-based text viewer. It is a so-called terminal pager."
PKG_LICENSE="MIT"

PKG_VERSION="0.33.3"
PKG_SRCURL=https://github.com/noborus/ov/archive/v${PKG_VERSION}.tar.gz

PKG_BASENAME=ov-${PKG_VERSION}
BUILD_PREFIX="${GO_BUILD_DIR}"
PKG_COMMIT_ID=a6b3e1e

build() {
	setup_golang
	go build -ldflags="-w -s -X main.Version=${PKG_VERSION} -X main.Revision=${PKG_COMMIT_ID}"
	install -Dt "${OUTPUT_DIR}/bin/" ov
}
