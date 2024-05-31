PKG_HOMEPAGE="https://zellij.dev/"
PKG_DESCRIPTION="A terminal workspace with batteries included"
PKG_LICENSE="MIT"

PKG_VERSION="0.40.0"
PKG_BASENAME=zellij-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL="https://github.com/zellij-org/zellij/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_SHA256=afb15afce6e37f850aff28a3a6b08abd78ef26a1c9fa3ed39426ef0853154438
PKG_BUILD_DEPENDS="zlib"
PKG_NAME=zellij

# # wasmer doesn't support these platforms yet
# PKG_BLACKLISTED_ARCHES="arm, i686"

# step_make() {
# 	setup_rust
# 	cargo build --jobs ${MAKE_PROCESSES} --target ${CARGO_TARGET_NAME} --release
# }

# step_make_install() {
# 	install -Dm700 -t ${PREFIX}/bin target/${CARGO_TARGET_NAME}/release/zellij

# 	install -Dm644 /dev/null ${PREFIX}/share/bash-completion/completions/zellij.bash
# 	install -Dm644 /dev/null ${PREFIX}/share/zsh/site-functions/_zellij
# 	install -Dm644 /dev/null ${PREFIX}/share/fish/vendor_completions.d/zellij.fish
# }

# step_create_debscripts() {
# 	cat <<-EOF >./postinst
# 		#!${PREFIX}/bin/sh
# 		zellij setup --generate-completion bash > ${PREFIX}/share/bash-completion/completions/zellij.bash
# 		zellij setup --generate-completion zsh > ${PREFIX}/share/zsh/site-functions/_zellij
# 		zellij setup --generate-completion fish > ${PREFIX}/share/fish/vendor_completions.d/zellij.fish
# 	EOF
# }

depends() {
	echo "zlib"
}

build() {
	setup_rust
	export RUSTFLAGS="-C link-arg=-s -C opt-level=s"
	cargo build --jobs "${JOBS}" --release
	install "target/${CARGO_BUILD_TARGET}/release/${PKG_NAME}" -D "${OUTPUT_DIR}/bin/${PKG_NAME}"
}
