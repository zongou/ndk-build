#!/bin/sh
set -eu

msg() { printf '%s\n' "$*" >&2; }

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
export GO_BUILD_DIR="${SCRIPT_DIR}/build/go"
export RUST_BUILD_DIR="${SCRIPT_DIR}/build/rust"
SRCS_DIR="${SCRIPT_DIR}/sources"
mkdir -p "${SRCS_DIR}"
# shellcheck disable=SC2155
export JOBS="$(nproc --all)"

setup_target() {
	if test "${TARGET+1}"; then
		case "${TARGET}" in
		*-linux-android*)
			ABI="$(echo "${TARGET}" | grep -E -o -e '.+-.+-android(eabi)?')"
			API="$(echo "${TARGET}" | sed -E 's/.+-linux-android(eabi)?//')"
			export ABI API
			TOOLCHAIN="${TOOLCHAIN-${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64}"

			BUILD_PREFIX="${BUILD_PREFIX-${SCRIPT_DIR}/build/${ABI}}"
			OUTPUT_DIR="${SCRIPT_DIR}/output/${ABI}"

			export CC="${CC-${TOOLCHAIN}/bin/${TARGET}-clang}"
			export CXX="${CXX-${TOOLCHAIN}/bin/${TARGET}-clang++}"

			for tool in ar objcopy ld.lld strip objdump ranlib; do
				ENV_KEY=$(echo "${tool}" | cut -d. -f1 | tr "[:lower:]" "[:upper:]")
				for ENV_VAL in "${TOOLCHAIN}/bin/${TARGET}-${tool}" "${TOOLCHAIN}/bin/llvm-${tool}" "${TOOLCHAIN}/bin/${tool}"; do
					if test -x "${ENV_VAL}"; then
						export "${ENV_KEY}=${ENV_VAL}"
						break
					fi
				done
			done
			;;
		*-linux-musl)
			BUILD_PREFIX="${BUILD_PREFIX-${SCRIPT_DIR}/build/${TARGET}}"
			OUTPUT_DIR="${SCRIPT_DIR}/output/${TARGET}"

			export CC="${CC-${SCRIPT_DIR}/wrappers/zig/bin/cc}"
			export CXX="${CXX-${SCRIPT_DIR}/wrappers/zig/bin/c++}"
			export LD="${LD-${SCRIPT_DIR}/wrappers/zig/ld.lld}"
			;;
		*)
			msg "Target '${TARGET}' not supported!"
			exit 1
			;;
		esac
	else
		BUILD_PREFIX="${BUILD_PREFIX-${SCRIPT_DIR}/build/host}"
		OUTPUT_DIR="${SCRIPT_DIR}/output/host"

		CC=${CC-cc}
		CXX=${CXX-c++}
		LD=${LD-ld}
	fi

	mkdir -p "${BUILD_PREFIX}"
	mkdir -p "${OUTPUT_DIR}" "${OUTPUT_DIR}/bin" "${OUTPUT_DIR}/lib"

	## pkg-conf
	export PKG_CONFIG_PATH="${OUTPUT_DIR}/lib/pkgconfig"

	## autoconf in PRoot enviroment
	export FORCE_UNSAFE_CONFIGURE=1
}

setup_golang() {
	if test "${TARGET+1}"; then
		## Detect GOOS
		case "${TARGET}" in
		*-linux-android*) export CGO_ENABLED=1 GOOS=android ;;
		*-linux-musl*) export CGO_ENABLED=1 GOOS=linux ;;
		esac

		## Detect GOARCH
		case "${TARGET}" in
		aarch64-*) export GOARCH=arm64 ;;
		arm-*) export GOARCH=arm ;;
		x86_64-*) export GOARCH=amd64 ;;
		i686-*) export GOARCH=386 ;;
		esac
	fi
}

setup_rust() {
	case "${TARGET}" in
	*-linux-android*)
		CARGO_BUILD_TARGET="$(echo "${ABI}" | sed 's/armv7a/armv7/')"
		export CARGO_BUILD_TARGET
		;;
	aarch64-linux-musl)
		export CARGO_BUILD_TARGET=aarch64-unknown-linux-musl
		;;
	esac

	export "CARGO_TARGET_$(echo "${CARGO_BUILD_TARGET}" | tr "[:lower:]" "[:upper:]" | tr '-' '_')_LINKER=${CC}"
	export CARGO_BUILD_JOBS="${JOBS}"
}

prepare_source() {
	case "${PKG_SRCURL}" in
	*.tar.gz) PKG_EXTNAME=.tar.gz ;;
	*.tar.xz) PKG_EXTNAME=.tar.xz ;;
	*.tar.bz2) PKG_EXTNAME=.tar.bz2 ;;
	esac

	PKG_TARBALL="${SRCS_DIR}/${PKG_BASENAME}${PKG_EXTNAME}"

	if ! test -f "${PKG_TARBALL}"; then
		msg "Downloading ${package}..."
		if command -v curl >/dev/null; then
			DOWNLOAD_CMD="curl -Lk"
		elif command -v wget >/dev/null; then
			DOWNLOAD_CMD="wget -O-"
		else
			msg "Cannot find neither 'curl' nor 'wget'"
			exit 1
		fi
		${DOWNLOAD_CMD} "${PKG_SRCURL}" >"${PKG_TARBALL}.tmp"
		mv "${PKG_TARBALL}.tmp" "${PKG_TARBALL}"
	fi

	case "${PKG_SRCURL}" in
	*.tar.gz) gzip -d <"${PKG_TARBALL}" | tar -C "${BUILD_PREFIX}" -x ;;
	*.tar.xz) xz -d <"${PKG_TARBALL}" | tar -C "${BUILD_PREFIX}" -x ;;
	*.tar.bz2) bzip2 -d <"${PKG_TARBALL}" | tar -C "${BUILD_PREFIX}" -x ;;
	esac

	cd "${BUILD_PREFIX}/${PKG_BASENAME}"
}

build_depends() {
	if test "${PKG_DEPENDS+1}"; then
		msg "Package '${package}' depends on '${PKG_DEPENDS}'"
		for package in ${PKG_DEPENDS}; do
			(
				unset -f check
				# shellcheck disable=SC1090
				. "${SCRIPT_DIR}/packages/${package}/build.sh"
				if command -v check >/dev/null && ! check; then
					build_package "${package}"
				fi
			)
		done
	fi
}

## The steps to build package, and what matters the most
build_package() {
	(
		package="$1"
		PKG_CONFIG_DIR="${SCRIPT_DIR}/packages/${package}"
		export PKG_CONFIG_DIR
		unset BUILD_PREFIX PKG_DEPENDS
		msg "Building package '${package}'"
		# shellcheck disable=SC1090
		. "${SCRIPT_DIR}/packages/${package}/build.sh"
		for step in setup_target build_depends prepare_source configure build; do
			if command -v "${step}" >/dev/null; then
				"${step}"
			fi
		done
	)
}

main() {
	for package in "$@"; do
		build_package "${package}"
	done
}

main "$@"
