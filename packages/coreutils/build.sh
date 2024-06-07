PKG_HOMEPAGE=https://www.gnu.org/software/coreutils/
PKG_DESCRIPTION="Basic file, shell and text manipulation utilities from the GNU project"
PKG_LICENSE="GPL-3.0"
PKG_DEPENDS="libandroid-support, libgmp, libiconv"

PKG_VERSION=9.5
PKG_EXTNAME=.tar.xz
PKG_BASENAME=coreutils-${PKG_VERSION}
# PKG_SRCURL=https://mirrors.kernel.org/gnu/coreutils/${PKG_BASENAME}${PKG_EXTNAME}
PKG_SRCURL=https://ftp.gnu.org/gnu/coreutils/${PKG_BASENAME}${PKG_EXTNAME}

configure() {
	# export CHOST="${TARGET}"
	patch -up1 <"${PKG_CONFIG_DIR}/src-hostid.c.patch"

	export FORCE_UNSAFE_CONFIGURE=1

	./configure \
		gl_cv_host_operating_system=Android \
		ac_cv_func_getpass=yes \
		--disable-xattr \
		--enable-no-install-program=pinky,users,who \
		--enable-single-binary=symlinks \
		--prefix="${OUTPUT_DIR}" \
		--host="${TARGET}"
}

build() {
	make -j"${JOBS}" install
}
