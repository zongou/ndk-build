PKG_HOMEPAGE=https://sites.google.com/site/fullycapable/
PKG_DESCRIPTION="POSIX 1003.1e capabilities"
PKG_LICENSE="BSD 3-Clause, GPL-2.0"
PKG_LICENSE_FILE="License"

PKG_VERSION=2.69
PKG_BASENAME=libcap-${PKG_VERSION}
PKG_EXTNAME=.tar.xz
PKG_SRCURL=https://kernel.org/pub/linux/libs/security/linux-privs/libcap2/${PKG_BASENAME}${PKG_EXTNAME}
PKG_SHA256=f311f8f3dad84699d0566d1d6f7ec943a9298b28f714cae3c931dfd57492d7eb
PKG_DEPENDS="attr"
PKG_BREAKS="libcap-dev"
PKG_REPLACES="libcap-dev"

depends() {
	echo attr
}

build() {
	patch -up1 <"${PKG_CONFIG_DIR}/libcap-makefile.patch"
	patch -up1 <"${PKG_CONFIG_DIR}/Makefile.patch"
	patch -up1 <"${PKG_CONFIG_DIR}/progs-capsh.c.patch"

	make CC="$CC -Wl,-rpath=${OUTPUT_DIR}/lib -Wl,--enable-new-dtags" PREFIX="${OUTPUT_DIR}" PTHREADS=no PAM_CAP=no
	make CC="$CC -Wl,-rpath=${OUTPUT_DIR}/lib -Wl,--enable-new-dtags" prefix="${OUTPUT_DIR}" RAISE_SETFCAP=no lib=/lib PTHREADS=no install PAM_CAP=no
}
