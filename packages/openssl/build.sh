PKG_HOMEPAGE=https://www.openssl.org/
PKG_DESCRIPTION="Library implementing the SSL and TLS protocols as well as general purpose cryptography functions"
PKG_LICENSE="Apache-2.0"

PKG_VERSION="3.3.0"
PKG_BASENAME=openssl-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://www.openssl.org/source/${PKG_BASENAME}${PKG_EXTNAME}

configure() {
	## Read Configurations/15-android.conf for options
	# export CFLAGS="-Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
	export LDFLAGS="-Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections"

	## -fPIC is required for libevent
	./Configure \
		linux-generic32 \
		-fPIC -static \
		no-asm \
		no-shared \
		no-tests \
		--prefix="${OUTPUT_DIR}"

	# ./Configure \
	# 	linux-generic32 \
	# 	shared \
	# 	zlib-dynamic \
	# 	no-ssl \
	# 	no-hw \
	# 	no-srp \
	# 	no-tests
}

build() {
	make -j"${JOBS}"
	# make install -j"${JOBS}"
	make install_sw install_ssldirs
}

check() {
	test -f "${OUTPUT_DIR}/lib/libssl.a"
}
