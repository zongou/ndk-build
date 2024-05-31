PKG_HOMEPAGE=https://github.com/messense/aliyundrive-webdav
PKG_DESCRIPTION="AliyunDrive webdav service"
PKG_LICENSE="MIT"

PKG_VERSION="2.3.3"
PKG_SRCURL=https://github.com/messense/aliyundrive-webdav/archive/refs/tags/v${PKG_VERSION}.tar.gz

PKG_BASENAME=aliyundrive-webdav-${PKG_VERSION}
BUILD_PREFIX="${RUST_BUILD_DIR}"

build() {
	setup_rust
	export RUSTFLAGS="-C link-arg=-s -C opt-level=s -C lto=true"
	cargo build --release
	PKG_NAME=aliyundrive-webdav
	install "target/${CARGO_BUILD_TARGET}/release/${PKG_NAME}" -D "${OUTPUT_DIR}/bin/${PKG_NAME}"
}
