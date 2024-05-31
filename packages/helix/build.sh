PKG_HOMEPAGE="https://helix-editor.com/"
PKG_DESCRIPTION="A post-modern modal text editor written in rust"
PKG_LICENSE="MPL-2.0"

PKG_VERSION="24.03"
PKG_NAME=hx
PKG_SRCURL=https://github.com/helix-editor/helix/archive/refs/tags/${PKG_VERSION}.tar.gz
PKG_GIT_BRANCH="${PKG_VERSION}"
PKG_SUGGESTS="helix-grammars"
PKG_BUILD_IN_SRC=true
PKG_AUTO_UPDATE=true
PKG_RM_AFTER_INSTALL="
opt/helix/runtime/grammars/sources/
"
PKG_DEPENDS="zlib"
PKG_BASENAME=helix-${PKG_VERSION}
BUILD_PREFIX="${SCRIPT_DIR}/build/rust"

# step_make_install() {
# 	setup_rust

# 	cargo build --jobs "${MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release

# 	local datadir="${PREFIX}/opt/${PKG_NAME}"
# 	mkdir -p "${datadir}"

# 	cat >"${PREFIX}/bin/hx" <<-EOF
# 		#!${PREFIX}/bin/sh
# 		HELIX_RUNTIME=${datadir}/runtime exec ${datadir}/hx "\$@"
# 	EOF
# 	chmod 0700 "${PREFIX}/bin/hx"

# 	install -Dm700 target/"${CARGO_TARGET_NAME}"/release/hx "${datadir}/hx"

# 	cp -r ./runtime "${datadir}"
# 	find "${datadir}"/runtime/grammars -type f -name "*.so" -exec chmod 0700 {} \;
# }

build() {
	setup_rust
	# export RUSTFLAGS="-C link-arg=-s -C opt-level=s -C lto=true"

	# export RUSTFLAGS="-C target-feature=-crt-static"
	# export HELIX_DISABLE_AUTO_GRAMMAR_BUILD=1
	# CC_HOST=${}
	# PATH="${SCRIPT_DIR}/wrappers/zig:${PATH}"
	cargo build --release

	DATA_DIR=${OUTPUT_DIR}/lib/helix
	mkdir -p "${DATA_DIR}"

	install "target/${CARGO_BUILD_TARGET}/release/${PKG_NAME}" -D "${DATA_DIR}/${PKG_NAME}"
	cp -r runtime "${DATA_DIR}/runtime"
	rm -rf "${DATA_DIR}/runtime/grammars/sources"
	mkdir -p "${OUTPUT_DIR}/bin/"
	ln -snf ../lib/helix/hx "${OUTPUT_DIR}/bin/hx"
}
