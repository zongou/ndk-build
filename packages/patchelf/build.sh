PKG_HOMEPAGE=https://nixos.org/patchelf.html
PKG_DESCRIPTION="Utility to modify the dynamic linker and RPATH of ELF executables"
PKG_LICENSE="GPL-3.0"
PKG_VERSION="0.18.0"
PKG_SRCURL=https://github.com/NixOS/patchelf/archive/$PKG_VERSION.tar.gz
# PKG_DEPENDS="libc++"

PKG_BASENAME=patchelf-${PKG_VERSION}

configure() {
	./bootstrap.sh
	./configure --host="${TARGET}" --prefix="${OUTPUT_DIR}"
}

build() {
	make -j"${JOBS}"
	"${OBJCOPY-objcopy}" --strip-all src/patchelf "${OUTPUT_DIR}/bin/patchelf"
	file src/patchelf
}
