PKG_HOMEPAGE=https://micro-editor.github.io/
PKG_DESCRIPTION="Modern and intuitive terminal-based text editor"
PKG_LICENSE="MIT"
PKG_VERSION="2.0.13"
PKG_SRCURL=https://github.com/zyedidia/micro/archive/refs/tags/v${PKG_VERSION}.tar.gz

PKG_BASENAME=micro-${PKG_VERSION}
BUILD_PREFIX="${GO_BUILD_DIR}"

build() {
	setup_golang
	# VERSION=$(GOOS=$(go env GOHOSTOS) GOARCH=$(go env GOHOSTARCH) go run tools/build-version.go)
	VERSION=${PKG_VERSION}
	# HASH=$(git rev-parse --short HEAD)
	HASH=68d88b5
	DATE=$(GOOS=$(go env GOHOSTOS) GOARCH=$(go env GOHOSTARCH) go run tools/build-date.go)
	ADDITIONAL_GO_LINKER_FLAGS=$(GOOS=$(go env GOHOSTOS) GOARCH=$(go env GOHOSTARCH) go run tools/info-plist.go "$(go env GOOS)" "${VERSION}")
	GOVARS="-X github.com/zyedidia/micro/v2/internal/util.Version=${VERSION} -X github.com/zyedidia/micro/v2/internal/util.CommitHash=${HASH} -X 'github.com/zyedidia/micro/v2/internal/util.CompileDate=$DATE'"

	# go build -trimpath -ldflags "-s -w ${GOVARS} ${ADDITIONAL_GO_LINKER_FLAGS}" ./cmd/micro
	## -trimpath appears looking like 'clang -v'
	go build -ldflags "-s -w ${GOVARS} ${ADDITIONAL_GO_LINKER_FLAGS}" ./cmd/micro
	install -Dt "${OUTPUT_DIR}/bin" micro
}
