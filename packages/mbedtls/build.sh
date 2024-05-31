PKG_VERSION="3.5.2"
PKG_BASENAME=mbedtls-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL="https://github.com/Mbed-TLS/mbedtls/archive/v${PKG_VERSION}.tar.gz"

# PKG_VERSION="3.6.0"
# PKG_BASENAME=mbedtls-${PKG_VERSION}
# PKG_EXTNAME=.tar.bz2
# PKG_SRCURL=https://github.com/Mbed-TLS/mbedtls/releases/download/v${PKG_VERSION}/${PKG_BASENAME}${PKG_EXTNAME}

configure() {
	patch -up1 <"${PKG_CONFIG_DIR}/CMakeLists.txt.patch"
	sed -i 's^info->MBEDTLS_PRIVATE(key_bitlen) << MBEDTLS_KEY_BITLEN_SHIFT^(size_t)(info->MBEDTLS_PRIVATE(key_bitlen) << MBEDTLS_KEY_BITLEN_SHIFT)^' include/mbedtls/cipher.h
	rm -rf build && mkdir -p build && cd build

	# -DUSE_STATIC_MBEDTLS_LIBRARY=OFF
	# -DUSE_SHARED_MBEDTLS_LIBRARY=ON
	cmake \
		-DCMAKE_FIND_ROOT_PATH="${OUTPUT_DIR}" \
		-DCMAKE_INSTALL_PREFIX="${OUTPUT_DIR}" \
		-DCMAKE_BUILD_TYPE=RELEASE \
		-DENABLE_TESTING=OFF \
		-DENABLE_PROGRAMS=OFF \
		..
}

build() {
	make CFLAGS=-fPIC -C build -j"${JOBS}" install
}

check() {
	test -f "${OUTPUT_DIR}/lib/libmbedtls.a"
}
