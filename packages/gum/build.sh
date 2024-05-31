PKG_HOMEPAGE=https://github.com/charmbracelet/gum
PKG_DESCRIPTION="A tool for glamorous shell scripts 🎀"
PKG_LICENSE="MIT"

PKG_VERSION="0.14.1"
PKG_SRCURL=https://github.com/charmbracelet/gum/archive/refs/tags/v${PKG_VERSION}.tar.gz

PKG_BASENAME=gum-${PKG_VERSION}
BUILD_PREFIX="${GO_BUILD_DIR}"
PKG_COMMIT_ID=ad21129

build() {
	setup_golang
	go build -ldflags="-w -s -X main.Version=${PKG_VERSION} -X main.CommitSHA=${PKG_COMMIT_ID}"
	install -Dt "${OUTPUT_DIR}/bin/" gum
}
