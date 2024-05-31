PKG_HOMEPAGE=https://ohse.de/uwe/software/lrzsz.html
PKG_DESCRIPTION="Tools for zmodem/xmodem/ymodem file transfer"
PKG_LICENSE="GPL-2.0"

# PKG_VERSION=0.12.21-rc1
# PKG_COMMIT=8cb2a6a29f6345f84d5e8248e2d3376166ab844f
# PKG_SRCURL=https://github.com/UweOhse/lrzsz/archive/${PKG_COMMIT}.tar.gz

# PKG_VERSION=0.12.20
PKG_BASENAME=lrzsz-master
PKG_EXTNAME=.tar.gz
# PKG_SRCURL=https://ohse.de/uwe/releases/${PKG_BASENAME}${PKG_EXTNAME}
PKG_SRCURL=https://github.com/UweOhse/lrzsz/archive/refs/heads/master${PKG_EXTNAME}

configure() {
	patch -up1 <"${PKG_CONFIG_DIR}/lib-long-options.c.patch"
	patch -up1 <"${PKG_CONFIG_DIR}/locale.patch"

	export CFLAGS="-Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
	export LDFLAGS="-Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections"

	autoreconf
	./configure \
		--prefix="${OUTPUT_DIR}" \
		--host="${TARGET}"
}

build() {
	make -j"${JOBS}"
	make install
}
