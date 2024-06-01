PKG_HOMEPAGE=https://github.com/gokcehan/lf
PKG_DESCRIPTION="Terminal file manager"
PKG_LICENSE="MIT"
PKG_MAINTAINER="@termux"
PKG_VERSION="32"
PKG_SRCURL=https://github.com/gokcehan/lf/archive/r$PKG_VERSION.tar.gz

PKG_BASENAME=lf-r${PKG_VERSION}
BUILD_PREFIX="${GO_BUILD_DIR}"

build() {
	setup_golang
	go build -ldflags="-X main.gVersion=r$PKG_VERSION" -trimpath
	install -Dt "${OUTPUT_DIR}/bin" lf
}

termux_step_make() {
	termux_setup_golang
	export GOPATH="$PKG_BUILDDIR"
	mkdir -p "$GOPATH/src/github.com/gokcehan"
	ln -sf "$PKG_SRCDIR" "$GOPATH/src/github.com/gokcehan/lf"
	cd "$GOPATH/src/github.com/gokcehan/lf"
}

termux_step_make_install() {
	cd "$GOPATH/src/github.com/gokcehan/lf"
	install -Dm755 -t "$PREFIX/bin" lf
	install -Dm644 -T etc/lfrc.example "$PREFIX/etc/lf/lfrc"
	install -Dm644 -t "$PREFIX/share/applications" lf.desktop
	install -Dm644 -t "$PREFIX/share/doc/lf" README.md
	install -Dm644 -t "$PREFIX/share/man/man1" lf.1
	# bash integration
	install -Dm644 -t "$PREFIX/etc/profile.d" etc/lfcd.sh
	# csh integration
	install -Dm644 -t "$PREFIX/etc/profile.d" etc/lf.csh etc/lfcd.csh
	# fish integration
	install -Dm644 -t "$PREFIX/share/fish/vendor_functions.d" etc/lfcd.fish
	install -Dm644 -t "$PREFIX/share/fish/vendor_completions.d" etc/lf.fish
	# vim integration
	install -Dm644 -t "$PREFIX/share/vim/vimfiles/plugin" etc/lf.vim
	# zsh integration
	install -Dm644 -T etc/lfcd.sh "$PREFIX/share/zsh/site-functions/lfcd"
	install -Dm644 -T etc/lf.zsh "$PREFIX/share/zsh/site-functions/_lf"
}
