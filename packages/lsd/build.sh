PKG_HOMEPAGE=https://github.com/lsd-rs/lsd
PKG_DESCRIPTION="Next gen ls command"
PKG_LICENSE="Apache-2.0"

PKG_VERSION="1.1.2"
PKG_NAME=lsd
PKG_BASENAME=${PKG_NAME}-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_REVISION=1
PKG_SRCURL=https://github.com/lsd-rs/lsd/archive/v${PKG_VERSION}${PKG_EXTNAME}
PKG_DEPENDS="zlib"

build() {
	setup_rust
	export RUSTFLAGS="-C link-arg=-s -C opt-level=s -C lto=true"
	cargo build --release
	install "target/${CARGO_BUILD_TARGET}/release/${PKG_NAME}" -D "${OUTPUT_DIR}/bin/${PKG_NAME}"
}
