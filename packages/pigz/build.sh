PKG_HOMEPAGE=https://www.zlib.net/pigz
PKG_DESCRIPTION="Parallel implementation of the gzip file compressor"
PKG_LICENSE="ZLIB"
PKG_VERSION=2.8
PKG_SRCURL=https://www.zlib.net/pigz/pigz-$PKG_VERSION.tar.gz
PKG_DEPENDS="zlib"

PKG_BASENAME=pigz-${PKG_VERSION}

# termux_step_make_install() {
# 	install -Dm700 pigz $PREFIX/bin/pigz
# 	ln -sfr $PREFIX/bin/pigz $PREFIX/bin/unpigz
# 	install -Dm600 pigz.1 $PREFIX/share/man/man1/pigz.1
# }

build() {
	make -B CC="${CC}" CFLAGS="-I${OUTPUT_DIR}/include" LDFLAGS="-L${OUTPUT_DIR}/lib"
	"${OBJCOPY-objcopy}" --strip-all pigz "${OUTPUT_DIR}/bin/pigz"
}
