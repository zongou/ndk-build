PKG_HOMEPAGE=https://upx.github.io/
PKG_DESCRIPTION="the Ultimate Packer for eXecutables"
PKG_LICENSE="GPL-2.0"

PKG_VERSION="4.2.3"
PKG_NAME=upx
PKG_BASENAME=${PKG_NAME}-${PKG_VERSION}-src
PKG_EXTNAME=.tar.xz
PKG_SRCURL=https://github.com/upx/upx/releases/download/v${PKG_VERSION}/upx-${PKG_VERSION}-src.tar.xz
PKG_SHA256=d6357eec6ed4c1b51f40af2316b0958ff1b7fa6f53ef3de12da1d5c96d30e412

PKG_DEPENDS="libc++"

configure() {
	rm -rf build && mkdir -p build && cd build
	STATIC_FLAGS="-static"
	cmake \
		-DCMAKE_FIND_ROOT_PATH="${OUTPUT_DIR}" \
		-DCMAKE_INSTALL_PREFIX="${OUTPUT_DIR}" \
		-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_C_FLAGS="-Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables ${STATIC_FLAGS+${STATIC_FLAGS}}" \
		-DCMAKE_EXE_LINKER_FLAGS="-Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections ${STATIC_FLAGS+${STATIC_FLAGS}}" \
		..
}

build() {
	cmake --build build -- -j"${JOBS}" install
}
