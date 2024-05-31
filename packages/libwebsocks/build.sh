PKG_HOMEPAGE=https://libwebsockets.org
PKG_DESCRIPTION="Lightweight C websockets library"
PKG_LICENSE="LGPL-2.0"

PKG_VERSION="4.3.3"
PKG_BASENAME=libwebsockets-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/warmcat/libwebsockets/archive/refs/tags/v${PKG_VERSION}${PKG_EXTNAME}

# libwebsocks does not build with mbedtls 3.6.0
depends() {
	echo libuv
	echo mbedtls
	# echo openssl
}

configure() {
	sed -i 's/ websockets_shared//g' cmake/libwebsockets-config.cmake.in
	rm -rf build && mkdir -p build && cd build
	# sed -i '/PC_OPENSSL/d' lib/tls/CMakeLists.txt

	if test -f "${OUTPUT_DIR}/lib/libssl.a"; then
		PKG_CMAKE_ARGS="-DLWS_WITH_SSL=ON"
	elif test -f "${OUTPUT_DIR}/lib/libmbedtls.a"; then
		PKG_CMAKE_ARGS="-DLWS_WITH_MBEDTLS=ON"
	else
		PKG_CMAKE_ARGS="-DLWS_WITH_MBEDTLS=OFF -DLWS_WITH_SSL=OFF"
	fi

	# shellcheck disable=SC2086
	cmake \
		-DCMAKE_FIND_ROOT_PATH="${OUTPUT_DIR}" \
		-DCMAKE_INSTALL_PREFIX="${OUTPUT_DIR}" \
		-DCMAKE_BUILD_TYPE=RELEASE \
		-DCMAKE_FIND_LIBRARY_SUFFIXES=".a" \
		-DCMAKE_EXE_LINKER_FLAGS="-static" \
		-DLWS_WITHOUT_TESTAPPS=ON \
		-DLWS_WITH_LIBUV=ON \
		-DLWS_STATIC_PIC=ON \
		-DLWS_WITH_SHARED=OFF \
		-DLWS_UNIX_SOCK=ON \
		-DLWS_IPV6=ON \
		-DLWS_ROLE_RAW_FILE=OFF \
		-DLWS_WITH_HTTP2=OFF \
		-DLWS_WITH_HTTP_BASIC_AUTH=OFF \
		-DLWS_WITH_UDP=OFF \
		-DLWS_WITHOUT_CLIENT=ON \
		-DLWS_WITH_LEJP=OFF \
		-DLWS_WITH_LEJP_CONF=OFF \
		-DLWS_WITH_LWSAC=OFF \
		-DLWS_WITH_SEQUENCER=OFF \
		${PKG_CMAKE_ARGS} \
		-DLWS_WITHOUT_EXTENSIONS=OFF \
		-DLWS_BUILD_HASH=no_hash \
		..
}

build() {
	make -C build -j"${JOBS}" install
}

check() {
	test -f "${OUTPUT_DIR}/lib/libwebsockets.a"
}
