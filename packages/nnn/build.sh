PKG_HOMEPAGE=https://github.com/jarun/nnn
PKG_DESCRIPTION="Free, fast, friendly file browser"
PKG_LICENSE="BSD 2-Clause"

PKG_VERSION="4.9"
PKG_BASENAME="nnn-${PKG_VERSION}"
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/jarun/nnn/archive/v${PKG_VERSION}${PKG_EXTNAME}
PKG_SHA256=9e25465a856d3ba626d6163046669c0d4010d520f2fb848b0d611e1ec6af1b22

PKG_DEPENDS="file, findutils, readline, wget, libandroid-support, lzip"

# termux_step_post_make_install() {
# 	install -Dm600 misc/auto-completion/bash/nnn-completion.bash \
# 		$PREFIX/share/bash-completion/completions/nnn
# 	install -Dm600 misc/auto-completion/fish/nnn.fish \
# 		$PREFIX/share/fish/vendor_completions.d/nnn.fish
# 	install -Dm600 misc/auto-completion/zsh/_nnn \
# 		$PREFIX/share/zsh/site-functions/_nnn
# }

depends() {
	echo "readline"
}

build() {
	API=26
	

	## Add to toolchain search dirs
	export CFLAGS="-I${OUTPUT_DIR}/include "
	export LDFLAGS="-L${OUTPUT_DIR}/lib"

	## Make small size stripped
	export CFLAGS="${CFLAGS} -Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
	export LDFLAGS="${LDFLAGS} -ffunction-sections -fdata-sections -Wl,--gc-sections -s"

	## Make static linked
	export LDFLAGS="${LDFLAGS} -static"

	sed -i 's^-lpthread^^g' Makefile
	make -j"${JOBS}" PREFIX="${OUTPUT_DIR}" install
}
