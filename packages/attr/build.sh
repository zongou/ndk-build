PKG_HOMEPAGE=http://savannah.nongnu.org/projects/attr/
PKG_DESCRIPTION="Utilities for manipulating filesystem extended attributes"
PKG_LICENSE="GPL-2.0"

PKG_VERSION="2.5.2"
PKG_BASENAME=attr-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=http://download.savannah.gnu.org/releases/attr/${PKG_BASENAME}${PKG_EXTNAME}
PKG_SHA256=39bf67452fa41d0948c2197601053f48b3d78a029389734332a6309a680c6c87

PKG_BREAKS="attr-dev"
PKG_REPLACES="attr-dev"

PKG_EXTRA_CONFIGURE_ARGS="--enable-gettext=no"
# PKG_MAKE_INSTALL_TARGET="install install-lib"
# attr.5 man page is in manpages:
PKG_RM_AFTER_INSTALL="share/man/man5/attr.5"

configure() {
	patch -up1 <"${PKG_CONFIG_DIR}/tools-attr.c.patch"
	patch -up1 <"${PKG_CONFIG_DIR}/walk_tree.c.patch"
	./configure --host="${TARGET}" --prefix="${OUTPUT_DIR}" --enable-gettext=no
}

build() {
	make -j"${JOBS}" install
}
