PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter
PKG_DESCRIPTION="An incremental parsing system for programming tools"
PKG_LICENSE="MIT"

PKG_VERSION="0.22.6"
PKG_SRCURL=https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v${PKG_VERSION}.tar.gz

PKG_BASENAME=tree-sitter-${PKG_VERSION}
BUILD_PREFIX="${RUST_BUILD_DIR}"

build() {
	setup_rust
	# export RUSTFLAGS="-C link-arg=-s -C opt-level=s -C lto=true"
	patch -up1 <"${PKG_CONFIG_DIR}/atomic.h.patch"
	cargo build --release
	PKG_NAME=tree-sitter
	install "target/${CARGO_BUILD_TARGET}/release/${PKG_NAME}" -D "${OUTPUT_DIR}/bin/${PKG_NAME}"
}
