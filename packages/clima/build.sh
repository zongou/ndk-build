PKG_HOMEPAGE="https://helix-editor.com/"
PKG_DESCRIPTION="A post-modern modal text editor written in rust"
PKG_LICENSE="MPL-2.0"

PKG_VERSION="1.1.0"
PKG_SRCURL=https://github.com/Canop/clima/archive/refs/tags/v${PKG_VERSION}.tar.gz

PKG_BASENAME=clima-${PKG_VERSION}
BUILD_PREFIX="${SCRIPT_DIR}/build/rust"

build() {
	setup_rust
	export RUSTFLAGS="-C target-feature=-crt-static"
	cargo build --target="${CARGO_BUILD_TARGET}" --release

	PKG_NAME=clima
	install "target/${CARGO_BUILD_TARGET}/release/${PKG_NAME}" -D "${OUTPUT_DIR}/bin/${PKG_NAME}"
}
