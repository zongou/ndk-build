## zig objcopy currently is not compatible to strip

PKG_HOMEPAGE=https://proot-me.github.io/
PKG_DESCRIPTION="Emulate chroot, bind mount and binfmt_misc for non-root users"
PKG_LICENSE="GPL-2.0"

# Just bump commit and version when needed:

PKG_VERSION=5.1.107
PKG_BASENAME=proot-master
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/termux/proot/archive/master${PKG_EXTNAME}
# PKG_EXTRA_MAKE_ARGS="-C src"

depends() {
	echo libtalloc
}

configure() {
	patch -up1 <"${WORK_DIR}/pending_packages/proot/base.patch"
	# patch -up1 <"${WORK_DIR}/packages/proot/proot-try-TMPDIR.patch"
}

build() {
	## Add to toolchain search dirs
	export CFLAGS="-I${OUTPUT_DIR}/include"
	export LDFLAGS="-L${OUTPUT_DIR}/lib"

	## Make small size stripped
	export CFLAGS="${CFLAGS} -Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
	export LDFLAGS="${LDFLAGS} -ffunction-sections -fdata-sections -Wl,--gc-sections -s"

	## Make static linked
	export LDFLAGS="${LDFLAGS} -static"

	## Make loader unbundled
	# export PROOT_UNBUNDLE_LOADER='../libexec/proot'

	make -C src distclean || true
	make -C src V=1 "PREFIX=${OUTPUT_DIR}" ${STRIP+STRIP="${STRIP}"} -j"${JOBS}" install

	file src/proot
	du -ahd0 src/proot
	ldd src/proot
}
