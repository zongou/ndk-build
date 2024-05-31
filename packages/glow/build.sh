PKG_HOMEPAGE=https://github.com/charmbracelet/glow
PKG_DESCRIPTION="Render markdown on the CLI, with pizzazz!"
PKG_LICENSE="MIT"

PKG_VERSION="1.5.1"
PKG_EXTNAME=.tar.gz
PKG_BASENAME=glow-${PKG_VERSION}
PKG_SRCURL=https://github.com/charmbracelet/glow/archive/v${PKG_VERSION}${PKG_EXTNAME}
# https://github.com/charmbracelet/glow/archive/refs/tags/v1.5.1.tar.gz
PKG_COMMIT_ID=ad21129

build() {
	setup_golang
	go build -ldflags="-w -s -X main.Version=${PKG_VERSION} -X main.CommitSHA=${PKG_COMMIT_ID}"
	install -Dt "${OUTPUT_DIR}/bin/" glow
}
