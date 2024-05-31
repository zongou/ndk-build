PKG_HOMEPAGE=https://github.com/termux/termux-elf-cleaner
PKG_DESCRIPTION="Cleaner of ELF files for Android"
PKG_LICENSE="GPL-3.0"

PKG_VERSION=2.2.1
PKG_BASENAME=termux-elf-cleaner-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://kkgithub.com/termux/termux-elf-cleaner/archive/v${PKG_VERSION}${PKG_EXTNAME}
PKG_SHA256=105be3c8673fd377ea7fd6becb6782b2ba060ad764439883710a5a7789421c46
PKG_DEPENDS="libc++"

configure() {
	autoreconf -vfi

	# sed "s%@PKG_API_LEVEL@%$PKG_API_LEVEL%g" \
	# 	"$PKG_BUILDER_DIR"/android-api-level.diff | patch --silent -p1

	## Add to toolchain search dirs
	export CFLAGS="-I${OUTPUT_DIR}/include"
	export LDFLAGS="-L${OUTPUT_DIR}/lib"

	## Make small size stripped
	export CFLAGS="${CFLAGS} -Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
	export LDFLAGS="${LDFLAGS} -ffunction-sections -fdata-sections -Wl,--gc-sections -s"

	## Make static linked
	export LDFLAGS="${LDFLAGS} -static"

	./configure --host="${TARGET}" --prefix="${OUTPUT_DIR}"
}

build() {
	make -j"${JOBS}" install
}
