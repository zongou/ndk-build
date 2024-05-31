PKG_HOMEPAGE=https://rclone.org/
PKG_DESCRIPTION="rsync for cloud storage"
PKG_LICENSE="MIT"
PKG_VERSION="1.66.0"
PKG_SRCURL=https://github.com/rclone/rclone/releases/download/v${PKG_VERSION}/rclone-v${PKG_VERSION}.tar.gz

PKG_BASENAME=rclone-v${PKG_VERSION}
BUILD_PREFIX="${GO_BUILD_DIR}"

build() {
	setup_golang

	go build -v -ldflags "-X github.com/rclone/rclone/fs.Version=v${PKG_VERSION} -w -s" -tags noselfupdate -o rclone

	# XXX: Fix read-only files which prevents removal of src dir.
	chmod u+w -R .

	cp rclone "${OUTPUT_DIR}/bin/rclone"
	mkdir -p "${OUTPUT_DIR}/share/man/man1/"
	cp rclone.1 "${OUTPUT_DIR}/share/man/man1/"
}
