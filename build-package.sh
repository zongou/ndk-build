#!/bin/sh
set -eux

msg() { printf '%s\n' "$*" >&2; }

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

setup_target() {
  TARGET=${TARGET-}

  # shellcheck disable=SC2155
  export JOBS="$(nproc --all)"

  SRCS_DIR="${SCRIPT_DIR}/sources"
  mkdir -p "${SRCS_DIR}"

  case "${TARGET}" in
  *-linux-android*)
    ABI="$(echo "${TARGET}" | grep -E -o -e '.+-.+-android(eabi)?')"
    # API="$(echo "${TARGET}" | sed -E 's/.+-linux-android(eabi)?//')"
    TOOLCHAIN="${TOOLCHAIN-${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64}"

    BUILD_PREFIX="${BUILD_PREFIX-${SCRIPT_DIR}/build/${ABI}}"
    OUTPUT_DIR="${SCRIPT_DIR}/output/${ABI}"

    export CC="${TOOLCHAIN}/bin/${TARGET}-clang"
    export CXX="${TOOLCHAIN}/bin/${TARGET}-clang++"

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

    export CC="${SCRIPT_DIR}/wrappers/zig/cc"
    export CXX="${SCRIPT_DIR}/wrappers/zig/c++"
    export LD="${SCRIPT_DIR}/wrappers/zig/ld.lld"
    ;;
  *)
    BUILD_PREFIX="${BUILD_PREFIX-${SCRIPT_DIR}/build/host}"
    OUTPUT_DIR="${SCRIPT_DIR}/output/host"
    ;;
  esac

  mkdir -p "${BUILD_PREFIX}"
  mkdir -p "${OUTPUT_DIR}"
  mkdir -p "${OUTPUT_DIR}/bin"
  mkdir -p "${OUTPUT_DIR}/lib"

  ## pkg-conf
  export PKG_CONFIG_PATH="${OUTPUT_DIR}/lib/pkgconfig"

  ## autoconf in PRoot enviroment
  export FORCE_UNSAFE_CONFIGURE=1
}

setup_golang() {
  ## Detect GOOS
  case "${TARGET}" in
  *-linux-android*)
    export CGO_ENABLED=1 GOOS=android
    ;;
  esac

  ## Detect GOARCH
  case "${TARGET}" in
  aarch64-*)
    export GOARCH=arm64
    ;;
  esac
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
    curl -Lk "${PKG_SRCURL}" >"${PKG_TARBALL}.tmp"
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
    for package in ${PKG_DEPENDS}; do
      build_package "${package}"
    done
  fi
}

## The steps to build package, and what matters the most
build_package() {
  (
    package="$1"
    PKG_CONFIG_DIR="${SCRIPT_DIR}/packages/${package}"
    export PKG_CONFIG_DIR
    unset PKG_DEPENDS
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
