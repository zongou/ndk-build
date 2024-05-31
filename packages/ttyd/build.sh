## Dependencies is defined in libwebsocks
## Version is defined at cmake/GetGitVersion.cmake

## Type/Size			dynamic			static
## Without ssl 	 	720 KB			1.3 MB
## With mbedtls  	1.4 MB			2.0 MB
## With openssl  	4.8 MB			4.9 MB

PKG_HOMEPAGE=https://tsl0922.github.io/ttyd/
PKG_DESCRIPTION="Command-line tool for sharing terminal over the web"
PKG_LICENSE="MIT"

# PKG_VERSION="1.7.4"
# PKG_SRCURL=https://github.com/tsl0922/ttyd/archive/refs/tags/${PKG_VERSION}.tar.gz
# 300d8cef4b0b32b0ec30d7bf4d3721a5d180e22607f9467a95ab7b6d9652ca9b sources/ttyd-1.7.4.tar.gz

PKG_VERSION='1.7.7'
PKG_BASENAME=ttyd-main
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/zongou/ttyd/archive/refs/heads/main${PKG_EXTNAME}

depends() {
	echo zlib
	echo json-c
	echo libwebsocks
}

configure() {
	rm -rf build && mkdir build && cd build
	STATIC_FLAGS="-static -ldl"
	cmake \
		-DCMAKE_FIND_ROOT_PATH="${OUTPUT_DIR}" \
		-DCMAKE_INSTALL_PREFIX="${OUTPUT_DIR}" \
		-DCMAKE_BUILD_TYPE=RELEASE \
		-DCMAKE_FIND_LIBRARY_SUFFIXES=".a" \
		-DCMAKE_C_FLAGS="-Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables ${STATIC_FLAGS+${STATIC_FLAGS}}" \
		-DCMAKE_EXE_LINKER_FLAGS="-Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections ${STATIC_FLAGS+${STATIC_FLAGS}}" \
		..
}

build() {
	make -C build install

	## Print output info
	if command -v du >/dev/null; then
		du -ahd0 build/ttyd
	fi
	if command -v file >/dev/null; then
		file build/ttyd
	fi
}

check() {
	test -f "${OUTPUT_DIR}/bin/ttyd"
}
