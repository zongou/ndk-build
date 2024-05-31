#!/bin/sh
set -eu

## Define toolchain
export TOOLCHAIN="${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64"

## Build all
# ./build-all.sh

## Ask and build packages
printf "Packages to build: "
read -r packages
# shellcheck disable=SC2086
./build-package.sh ${packages}
printf '%s\n' "Done!"
